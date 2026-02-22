import { GoogleAuth } from 'npm:google-auth-library@9.15.1'
import { createClient } from 'npm:@supabase/supabase-js@2.57.4'

type HonkActivityRecord = {
  id: string
  creator_id: string
  activity: string
  location: string
  details: string | null
  status_reset_seconds: number
  invite_code: string
}

type HonkParticipantStatusRecord = {
  activity_id: string
  user_id: string
  status_key: string
  updated_at: string
  expires_at: string
}

type HonkParticipantRecord = {
  activity_id: string
  user_id: string
  role: string
  join_status: string
  joined_at: string
  left_at: string | null
}

type WebhookPayload = {
  type: 'INSERT' | 'UPDATE' | 'DELETE'
  table: string
  schema: string
  record: Record<string, unknown> | null
  old_record: Record<string, unknown> | null
}

type ParticipantRow = {
  user_id: string
  join_status: string
}

type ProfileWithTokenRow = {
  id: string
  fcm_token: string | null
}

type ProfileNameRow = {
  username: string | null
}

type StatusOptionRow = {
  label: string
}

type ActivityCoreRow = {
  id: string
  activity: string
  location: string
  creator_id: string
}

type FirebaseConfig = {
  projectId: string
  clientEmail: string
  privateKey: string
}

const supabaseUrl = getRequiredEnv('SUPABASE_URL')
const serviceRoleKey = getRequiredEnv('SUPABASE_SERVICE_ROLE_KEY')
const cachedSecretTtlMs = 60 * 1000
let cachedWebhookSecret: string | null = null
let cachedWebhookSecretAt = 0

const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey)

Deno.serve(async (req) => {
  try {
    const webhookSecret = await readWebhookSecret()
    if (webhookSecret == null) {
      return Response.json(
        { error: 'Webhook secret is not configured.' },
        { status: 503 },
      )
    }

    if (!isAuthorizedWebhookRequest(req, webhookSecret)) {
      return Response.json(
        { error: 'Unauthorized webhook request.' },
        { status: 401 },
      )
    }

    const payload = (await req.json()) as WebhookPayload
    if (payload.schema !== 'public') {
      return Response.json({ skipped: true, reason: 'Unsupported schema.' })
    }

    if (payload.table === 'honk_activities') {
      return await handleActivityCreated(payload)
    }

    if (payload.table === 'honk_participant_statuses') {
      return await handleParticipantStatusUpdated(payload)
    }

    if (payload.table === 'honk_activity_participants') {
      return await handleParticipantJoinChanged(payload)
    }

    return Response.json({ skipped: true, reason: 'Unsupported table.' })
  } catch (error) {
    console.error('honk-push function failed:', error)
    return Response.json(
      { error: error instanceof Error ? error.message : String(error) },
      { status: 500 },
    )
  }
})

async function handleActivityCreated(payload: WebhookPayload): Promise<Response> {
  if (payload.type !== 'INSERT' || payload.record == null) {
    return Response.json({ skipped: true, reason: 'Not an insert event.' })
  }

  const activity = payload.record as HonkActivityRecord
  const creatorId = activity.creator_id
  if (creatorId == null || creatorId.length === 0) {
    return Response.json({ skipped: true, reason: 'Missing creator_id.' })
  }

  const participantIds = await fetchActiveParticipantIds({
    activityId: activity.id,
    excludeUserId: creatorId,
  })
  if (participantIds.length === 0) {
    return Response.json({ delivered: 0, failed: 0, skipped: true })
  }

  const tokens = await fetchTokensForUsers(participantIds)
  if (tokens.length === 0) {
    return Response.json({ delivered: 0, failed: 0, skipped: true })
  }

  const creatorName = await fetchUsername(creatorId) ?? 'Your friend'

  const firebaseConfig = readFirebaseConfig()
  if (firebaseConfig == null) {
    return Response.json({
      delivered: 0,
      failed: 0,
      skipped: true,
      reason:
        'Missing Firebase configuration (FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY).',
    })
  }

  const accessToken = await getFirebaseAccessToken(firebaseConfig)
  const title = 'New Activity Honk'
  const details = activity.details?.trim()
  const body = details != null && details.length > 0
    ? `${creatorName} created "${activity.activity}" at ${activity.location}. ${details}`
    : `${creatorName} created "${activity.activity}" at ${activity.location}.`

  const deliveryResult = await Promise.allSettled(
    tokens.map((token) =>
      sendFcmMessage({
        accessToken,
        projectId: firebaseConfig.projectId,
        token,
        title,
        body,
        ttlSeconds: 3600,
        data: {
          event_type: 'activity_created',
          activity_id: activity.id,
          actor_user_id: creatorId,
          activity: activity.activity,
          location: activity.location,
          status_key: '',
        },
      }),
    ),
  )

  return buildDeliveryResponse(deliveryResult, 'activity_created')
}

async function handleParticipantStatusUpdated(payload: WebhookPayload): Promise<Response> {
  if ((payload.type !== 'INSERT' && payload.type !== 'UPDATE') || payload.record == null) {
    return Response.json({ skipped: true, reason: 'Not a status update event.' })
  }

  const statusRecord = payload.record as HonkParticipantStatusRecord
  const activityId = statusRecord.activity_id
  const actorUserId = statusRecord.user_id
  if (activityId == null || actorUserId == null) {
    return Response.json({ skipped: true, reason: 'Missing activity/user in status event.' })
  }

  const participantIds = await fetchActiveParticipantIds({
    activityId,
    excludeUserId: actorUserId,
  })
  if (participantIds.length === 0) {
    return Response.json({ delivered: 0, failed: 0, skipped: true })
  }

  const tokens = await fetchTokensForUsers(participantIds)
  if (tokens.length === 0) {
    return Response.json({ delivered: 0, failed: 0, skipped: true })
  }

  const [activity, actorName, statusLabel] = await Promise.all([
    fetchActivityCore(activityId),
    fetchUsername(actorUserId),
    fetchStatusLabel(activityId, statusRecord.status_key),
  ])

  if (activity == null) {
    return Response.json({ skipped: true, reason: 'Activity not found.' })
  }

  const firebaseConfig = readFirebaseConfig()
  if (firebaseConfig == null) {
    return Response.json({
      delivered: 0,
      failed: 0,
      skipped: true,
      reason:
        'Missing Firebase configuration (FIREBASE_PROJECT_ID, FIREBASE_CLIENT_EMAIL, FIREBASE_PRIVATE_KEY).',
    })
  }

  const accessToken = await getFirebaseAccessToken(firebaseConfig)
  const resolvedActorName = actorName ?? 'A participant'
  const resolvedStatusLabel = statusLabel ?? statusRecord.status_key
  const title = 'Activity Status Honk'
  const body = `${resolvedActorName} is now "${resolvedStatusLabel}" for "${activity.activity}".`

  const ttlSeconds = calculateTtlSeconds(statusRecord.expires_at)
  const safeTtlSeconds = ttlSeconds > 0 ? ttlSeconds : 3600

  const deliveryResult = await Promise.allSettled(
    tokens.map((token) =>
      sendFcmMessage({
        accessToken,
        projectId: firebaseConfig.projectId,
        token,
        title,
        body,
        ttlSeconds: safeTtlSeconds,
        data: {
          event_type: 'status_updated',
          activity_id: activity.id,
          actor_user_id: actorUserId,
          activity: activity.activity,
          location: activity.location,
          status_key: statusRecord.status_key,
        },
      }),
    ),
  )

  return buildDeliveryResponse(deliveryResult, 'status_updated')
}

// ── Participant join request changed ──────────────────────────────────────────

async function handleParticipantJoinChanged(payload: WebhookPayload): Promise<Response> {
  if (payload.record == null) {
    return Response.json({ skipped: true, reason: 'Empty record.' })
  }

  const record = payload.record as HonkParticipantRecord
  const { activity_id: activityId, user_id: userId, join_status: joinStatus } = record

  if (activityId == null || userId == null || joinStatus == null) {
    return Response.json({ skipped: true, reason: 'Missing required fields.' })
  }

  if (payload.type === 'INSERT' && joinStatus === 'pending') {
    return await notifyCreatorOfJoinRequest(activityId, userId)
  }

  if (payload.type === 'UPDATE' && joinStatus === 'active') {
    return await notifyJoinerOfApproval(activityId, userId)
  }

  return Response.json({ skipped: true, reason: 'No notification needed for this event.' })
}

async function notifyCreatorOfJoinRequest(
  activityId: string,
  joinerId: string,
): Promise<Response> {
  const activity = await fetchActivityCore(activityId)
  if (activity == null) {
    return Response.json({ skipped: true, reason: 'Activity not found.' })
  }

  const tokens = await fetchTokensForUsers([activity.creator_id])
  if (tokens.length === 0) {
    return Response.json({ delivered: 0, failed: 0, skipped: true })
  }

  const joinerName = await fetchUsername(joinerId) ?? 'Someone'

  const firebaseConfig = readFirebaseConfig()
  if (firebaseConfig == null) {
    return Response.json({ delivered: 0, failed: 0, skipped: true, reason: 'Missing Firebase configuration.' })
  }

  const accessToken = await getFirebaseAccessToken(firebaseConfig)
  const deliveryResult = await Promise.allSettled(
    tokens.map((token) =>
      sendFcmMessage({
        accessToken,
        projectId: firebaseConfig.projectId,
        token,
        title: 'Join Request',
        body: `${joinerName} wants to join "${activity.activity}".`,
        ttlSeconds: 86400,
        data: {
          event_type: 'join_request',
          activity_id: activityId,
          actor_user_id: joinerId,
          activity: activity.activity,
          location: activity.location,
          status_key: '',
        },
      }),
    ),
  )

  return buildDeliveryResponse(deliveryResult, 'join_request')
}

async function notifyJoinerOfApproval(
  activityId: string,
  joinerId: string,
): Promise<Response> {
  const activity = await fetchActivityCore(activityId)
  if (activity == null) {
    return Response.json({ skipped: true, reason: 'Activity not found.' })
  }

  const tokens = await fetchTokensForUsers([joinerId])
  if (tokens.length === 0) {
    return Response.json({ delivered: 0, failed: 0, skipped: true })
  }

  const firebaseConfig = readFirebaseConfig()
  if (firebaseConfig == null) {
    return Response.json({ delivered: 0, failed: 0, skipped: true, reason: 'Missing Firebase configuration.' })
  }

  const accessToken = await getFirebaseAccessToken(firebaseConfig)
  const deliveryResult = await Promise.allSettled(
    tokens.map((token) =>
      sendFcmMessage({
        accessToken,
        projectId: firebaseConfig.projectId,
        token,
        title: 'Join Approved!',
        body: `You\'ve been approved to join "${activity.activity}".`,
        ttlSeconds: 86400,
        data: {
          event_type: 'join_approved',
          activity_id: activityId,
          actor_user_id: activity.creator_id,
          activity: activity.activity,
          location: activity.location,
          status_key: '',
        },
      }),
    ),
  )

  return buildDeliveryResponse(deliveryResult, 'join_approved')
}

async function fetchActiveParticipantIds(args: {
  activityId: string
  excludeUserId?: string
}): Promise<string[]> {
  const result = await supabaseAdmin
    .from('honk_activity_participants')
    .select('user_id, join_status')
    .eq('activity_id', args.activityId)
    .eq('join_status', 'active')
    .is('left_at', null)
    .returns<ParticipantRow[]>()

  if (result.error != null) {
    throw result.error
  }

  return Array.from(
    new Set(
      (result.data ?? [])
        .map((row) => row.user_id)
        .filter((userId) => userId.length > 0 && userId !== args.excludeUserId),
    ),
  )
}

async function fetchTokensForUsers(userIds: string[]): Promise<string[]> {
  if (userIds.length === 0) {
    return []
  }

  const result = await supabaseAdmin
    .from('profiles')
    .select('id, fcm_token')
    .in('id', userIds)
    .not('fcm_token', 'is', null)
    .returns<ProfileWithTokenRow[]>()

  if (result.error != null) {
    throw result.error
  }

  return Array.from(
    new Set(
      (result.data ?? [])
        .map((row) => row.fcm_token)
        .filter((token): token is string => token != null && token.length > 0),
    ),
  )
}

async function fetchUsername(userId: string): Promise<string | null> {
  const result = await supabaseAdmin
    .from('profiles')
    .select('username')
    .eq('id', userId)
    .maybeSingle<ProfileNameRow>()

  if (result.error != null) {
    throw result.error
  }

  return result.data?.username ?? null
}

function buildDeliveryResponse(
  results: PromiseSettledResult<void>[],
  eventType: string,
): Response {
  const delivered = results.filter((r) => r.status === 'fulfilled').length
  const failed = results.length - delivered
  const errors = results
    .filter((r): r is PromiseRejectedResult => r.status === 'rejected')
    .map((r) => r.reason instanceof Error ? r.reason.message : String(r.reason))

  if (errors.length > 0) {
    console.error(`FCM delivery failures (${eventType}):`, JSON.stringify(errors))
  }

  return Response.json({ delivered, failed, errors: errors.length > 0 ? errors : undefined })
}

async function fetchActivityCore(activityId: string): Promise<ActivityCoreRow | null> {
  const result = await supabaseAdmin
    .from('honk_activities')
    .select('id, activity, location, creator_id')
    .eq('id', activityId)
    .maybeSingle<ActivityCoreRow>()

  if (result.error != null) {
    throw result.error
  }

  return result.data ?? null
}

async function fetchStatusLabel(
  activityId: string,
  statusKey: string,
): Promise<string | null> {
  const result = await supabaseAdmin
    .from('honk_activity_status_options')
    .select('label')
    .eq('activity_id', activityId)
    .eq('status_key', statusKey)
    .maybeSingle<StatusOptionRow>()

  if (result.error != null) {
    throw result.error
  }

  return result.data?.label ?? null
}

function getRequiredEnv(key: string): string {
  const value = Deno.env.get(key)
  if (value == null || value.length === 0) {
    throw new Error(`Missing required environment variable: ${key}`)
  }

  return value
}

function isAuthorizedWebhookRequest(req: Request, webhookSecret: string): boolean {
  const incomingSecret = req.headers.get('x-honk-webhook-secret')
  const authorization = req.headers.get('authorization')
  if (incomingSecret == null || authorization == null) {
    return false
  }

  if (!authorization.toLowerCase().startsWith('bearer ')) {
    return false
  }

  const bearerToken = authorization.substring(7)
  if (bearerToken.length === 0) {
    return false
  }

  return incomingSecret === webhookSecret
}

async function readWebhookSecret(): Promise<string | null> {
  const envSecret = Deno.env.get('HONK_PUSH_WEBHOOK_SECRET')
  if (envSecret != null && envSecret.length > 0) {
    return envSecret
  }

  const now = Date.now()
  if (
    cachedWebhookSecret != null &&
    now - cachedWebhookSecretAt < cachedSecretTtlMs
  ) {
    return cachedWebhookSecret
  }

  const result = await supabaseAdmin
    .from('runtime_config')
    .select('value')
    .eq('key', 'honk_push_webhook_secret')
    .maybeSingle<{ value: string }>()

  if (result.error != null) {
    console.error('Failed to read runtime webhook secret:', result.error)
    return null
  }

  const secret = result.data?.value
  if (secret == null || secret.length === 0) {
    return null
  }

  cachedWebhookSecret = secret
  cachedWebhookSecretAt = now
  return secret
}

function readFirebaseConfig(): FirebaseConfig | null {
  const projectId = Deno.env.get('FIREBASE_PROJECT_ID')
  const clientEmail = Deno.env.get('FIREBASE_CLIENT_EMAIL')
  const privateKeyRaw = Deno.env.get('FIREBASE_PRIVATE_KEY')

  if (
    projectId == null ||
    projectId.length === 0 ||
    clientEmail == null ||
    clientEmail.length === 0 ||
    privateKeyRaw == null ||
    privateKeyRaw.length === 0
  ) {
    return null
  }

  return {
    projectId: projectId.trim(),
    clientEmail: clientEmail.trim(),
    privateKey: privateKeyRaw.trim().replace(/\\n/g, '\n'),
  }
}

type SendFcmMessageArgs = {
  accessToken: string
  projectId: string
  token: string
  title: string
  body: string
  ttlSeconds: number
  data: Record<string, string>
}

async function sendFcmMessage(args: SendFcmMessageArgs): Promise<void> {
  const apnsExpiration = Math.floor(Date.now() / 1000) + args.ttlSeconds

  const response = await fetch(
    `https://fcm.googleapis.com/v1/projects/${args.projectId}/messages:send`,
    {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${args.accessToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        message: {
          token: args.token,
          notification: {
            title: args.title,
            body: args.body,
          },
          data: args.data,
          android: {
            priority: 'high',
            ttl: `${args.ttlSeconds}s`,
            notification: {
              channel_id: 'honk_notifications',
            },
          },
          apns: {
            headers: {
              'apns-priority': '10',
              'apns-expiration': String(apnsExpiration),
            },
            payload: {
              aps: {
                sound: 'default',
              },
            },
          },
        },
      }),
    },
  )

  if (!response.ok) {
    const errorBody = await response.text()
    throw new Error(
      `FCM request failed with status ${response.status}: ${errorBody}`,
    )
  }
}

function calculateTtlSeconds(expiresAtIso: string): number {
  const maxTtlSeconds = 2_419_200
  const expiresAtMillis = Date.parse(expiresAtIso)
  if (!Number.isFinite(expiresAtMillis)) {
    return 0
  }

  const ttlSeconds = Math.floor((expiresAtMillis - Date.now()) / 1000)
  if (ttlSeconds <= 0) {
    return 0
  }

  return Math.min(ttlSeconds, maxTtlSeconds)
}

async function getFirebaseAccessToken(config: FirebaseConfig): Promise<string> {
  const auth = new GoogleAuth({
    credentials: {
      client_email: config.clientEmail,
      private_key: config.privateKey,
      project_id: config.projectId,
    },
    scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
  })

  const accessToken = await auth.getAccessToken()
  if (accessToken == null || accessToken.length === 0) {
    throw new Error('Unable to fetch Firebase access token.')
  }

  return accessToken
}
