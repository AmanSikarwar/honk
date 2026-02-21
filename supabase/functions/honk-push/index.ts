import { GoogleAuth } from 'npm:google-auth-library@9.15.1'
import { createClient } from 'npm:@supabase/supabase-js@2.57.4'

type HonkRecord = {
  id: string
  user_id: string
  location: string
  status: string
  created_at: string
  expires_at: string
}

type WebhookPayload = {
  type: 'INSERT' | 'UPDATE' | 'DELETE'
  table: string
  schema: string
  record: HonkRecord | null
  old_record: HonkRecord | null
}

type FriendshipRow = {
  user_id: string
  friend_id: string
}

type SenderProfileRow = {
  username: string | null
}

type FriendProfileRow = {
  id: string
  fcm_token: string | null
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

    if (payload.schema !== 'public' || payload.table !== 'honks') {
      return Response.json({
        skipped: true,
        reason: 'Unsupported table or schema.',
      })
    }

    if (payload.type !== 'INSERT' || payload.record == null) {
      return Response.json({ skipped: true, reason: 'Not an insert event.' })
    }

    const honk = payload.record

    const [senderProfileResult, friendsResult] = await Promise.all([
      supabaseAdmin
        .from('profiles')
        .select('username')
        .eq('id', honk.user_id)
        .maybeSingle<SenderProfileRow>(),
      supabaseAdmin
        .from('friendships')
        .select('user_id, friend_id')
        .eq('status', 'accepted')
        .or(`user_id.eq.${honk.user_id},friend_id.eq.${honk.user_id}`)
        .returns<FriendshipRow[]>(),
    ])

    if (senderProfileResult.error) {
      throw senderProfileResult.error
    }

    if (friendsResult.error) {
      throw friendsResult.error
    }

    const senderName = senderProfileResult.data?.username ?? 'Your friend'
    const friendIds = Array.from(
      new Set(
        (friendsResult.data ?? [])
          .map((row) =>
            row.user_id == honk.user_id ? row.friend_id : row.user_id,
          )
          .filter((friendId) => friendId.length > 0 && friendId != honk.user_id),
      ),
    )

    if (friendIds.length === 0) {
      return Response.json({ delivered: 0, failed: 0, skipped: true })
    }

    const friendProfilesResult = await supabaseAdmin
      .from('profiles')
      .select('id, fcm_token')
      .in('id', friendIds)
      .not('fcm_token', 'is', null)
      .returns<FriendProfileRow[]>()

    if (friendProfilesResult.error) {
      throw friendProfilesResult.error
    }

    const tokens = Array.from(
      new Set(
        (friendProfilesResult.data ?? [])
          .map((profile) => profile.fcm_token)
          .filter((token): token is string => token != null && token.length > 0),
      ),
    )

    if (tokens.length == 0) {
      return Response.json({ delivered: 0, failed: 0, skipped: true })
    }

    const ttlSeconds = calculateTtlSeconds(honk.expires_at)
    if (ttlSeconds <= 0) {
      return Response.json({
        delivered: 0,
        failed: 0,
        skipped: true,
        reason: 'Honk already expired.',
      })
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
    const title = 'New Honk'
    const body = `${senderName} honked: Heading to ${honk.location}!`

    const deliveryResult = await Promise.allSettled(
      tokens.map((token) =>
        sendFcmMessage({
          accessToken,
          projectId: firebaseConfig.projectId,
          token,
          title,
          body,
          ttlSeconds,
          data: {
            honk_id: honk.id,
            user_id: honk.user_id,
            location: honk.location,
            status: honk.status,
            created_at: honk.created_at,
            expires_at: honk.expires_at,
          },
        }),
      ),
    )

    const delivered = deliveryResult.filter((result) => result.status === 'fulfilled').length
    const failed = deliveryResult.length - delivered

    return Response.json({ delivered, failed })
  } catch (error) {
    console.error('honk-push function failed:', error)
    return Response.json(
      { error: error instanceof Error ? error.message : String(error) },
      { status: 500 },
    )
  }
})

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
    projectId,
    clientEmail,
    privateKey: privateKeyRaw.replace(/\\n/g, '\n'),
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
