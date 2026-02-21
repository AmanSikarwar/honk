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
  friend_id: string
}

type SenderProfileRow = {
  username: string | null
}

type FriendProfileRow = {
  id: string
  fcm_token: string | null
}

const supabaseUrl = getRequiredEnv('SUPABASE_URL')
const serviceRoleKey = getRequiredEnv('SUPABASE_SERVICE_ROLE_KEY')
const firebaseProjectId = getRequiredEnv('FIREBASE_PROJECT_ID')
const firebaseClientEmail = getRequiredEnv('FIREBASE_CLIENT_EMAIL')
const firebasePrivateKey = getRequiredEnv('FIREBASE_PRIVATE_KEY').replace(
  /\\n/g,
  '\n',
)

const supabaseAdmin = createClient(supabaseUrl, serviceRoleKey)

Deno.serve(async (req) => {
  try {
    const payload = (await req.json()) as WebhookPayload

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
        .select('friend_id')
        .eq('user_id', honk.user_id)
        .eq('status', 'accepted')
        .returns<FriendshipRow[]>(),
    ])

    if (senderProfileResult.error) {
      throw senderProfileResult.error
    }

    if (friendsResult.error) {
      throw friendsResult.error
    }

    const senderName = senderProfileResult.data?.username ?? 'Your friend'
    const friendIds = (friendsResult.data ?? []).map((row) => row.friend_id)

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

    const accessToken = await getFirebaseAccessToken()
    const title = 'New Honk'
    const body = `${senderName} honked: Heading to ${honk.location}!`

    const deliveryResult = await Promise.allSettled(
      tokens.map((token) =>
        sendFcmMessage({
          accessToken,
          projectId: firebaseProjectId,
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

async function getFirebaseAccessToken(): Promise<string> {
  const auth = new GoogleAuth({
    credentials: {
      client_email: firebaseClientEmail,
      private_key: firebasePrivateKey,
      project_id: firebaseProjectId,
    },
    scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
  })

  const accessToken = await auth.getAccessToken()
  if (accessToken == null || accessToken.length === 0) {
    throw new Error('Unable to fetch Firebase access token.')
  }

  return accessToken
}
