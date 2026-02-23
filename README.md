<div align="center">

# 📣 Honk

**Real-time group activity coordination — who's in, and what are they up to?**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Firebase](https://img.shields.io/badge/Firebase-FCM-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-Private-red)](LICENSE)

</div>

---

## What is Honk?

Honk is a Flutter mobile app that lets groups of people effortlessly coordinate around shared activities. Create an activity (a "honk"), invite friends via a QR code or invite link, and everyone sees each other's real-time status at a glance — whether that's "on my way", "already there", "skipping today", or any custom label you define.

Think of it as a lightweight, ephemeral status board for your crew.

---

## Features

| Feature | Description |
|---|---|
| **Activity Feed** | See all your active honks and the current status of every participant at a glance |
| **Create a Honk** | Define an activity, location, optional details, custom status options, and an auto-reset timer |
| **Invite via QR / Link** | Share a unique invite code as a scannable QR code or a deep link |
| **Join Approval Flow** | Creators approve or deny join requests before members see group statuses |
| **Real-time Status Updates** | Participant statuses sync live via Supabase Realtime — no refresh needed |
| **Status Auto-reset** | Statuses automatically expire after a configurable window, keeping the feed fresh |
| **Push Notifications** | FCM notifications for join requests, approvals, and honk activity |
| **Google Sign-In** | One-tap authentication with Google |
| **Deep Link Handling** | Auth redirects and invite codes work seamlessly via deep links |

---

## Tech Stack

### Mobile

- **[Flutter](https://flutter.dev)** — cross-platform UI toolkit
- **[BLoC / Cubit](https://bloclibrary.dev)** — predictable state management
- **[GoRouter](https://pub.dev/packages/go_router)** — declarative navigation with deep link support
- **[Freezed](https://pub.dev/packages/freezed)** — immutable, union-type domain models
- **[Injectable](https://pub.dev/packages/injectable) + [GetIt](https://pub.dev/packages/get_it)** — compile-safe dependency injection
- **[ForUI](https://pub.dev/packages/forui)** — component library; Material 3 with an electric-violet brand palette and Fredoka/Nunito typography
- **[mobile_scanner](https://pub.dev/packages/mobile_scanner) + [pretty_qr_code](https://pub.dev/packages/pretty_qr_code)** — QR scanning and generation

### Backend

- **[Supabase](https://supabase.com)** — Postgres database, Row-Level Security, Realtime subscriptions, and Edge Functions (Deno)
- **[Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)** — push notifications via a Supabase Edge Function webhook

---

## Architecture

The project follows **Clean Architecture** with a feature-first folder structure:

```
lib/
├── core/                   # Shared infrastructure
│   ├── di/                 # Dependency injection (Injectable + GetIt)
│   ├── router/             # App routing (GoRouter)
│   ├── deep_link/          # Deep link & invite-code parsing
│   ├── env/                # Environment config (Envied)
│   └── theme/              # Material 3 theme, colours, spacing
│
└── features/
    ├── auth/               # Authentication (Google Sign-In, session management)
    │   ├── data/
    │   ├── domain/
    │   └── presentation/   # BLoC, pages, widgets
    ├── honk/               # Core activity feature
    │   ├── data/
    │   ├── domain/         # HonkActivity, Participant, StatusOption entities
    │   └── presentation/   # Feed, details, create, QR scanner, invite pages
    └── notifications/      # FCM token management & local notifications
```

Each feature layer has a clear responsibility:

- **`domain/`** — entities, repository interfaces, pure business logic
- **`data/`** — Supabase/Firebase implementations of domain interfaces
- **`presentation/`** — BLoC/Cubit, pages, and widgets

---

## Database Schema (Supabase / Postgres)

```
profiles                    User profiles (username, FCM token)
honk_activities             Group activities (location, invite code, recurrence, status-reset window)
honk_activity_status_options  Per-activity custom status labels
honk_activity_participants  Members with join-approval flow (pending → active / denied)
honk_participant_statuses   Per-user ephemeral status per occurrence (expires automatically)
```

All tables have Row-Level Security enabled. Access is governed by the `can_access_honk_activity` database function.

---

## Getting Started

### Prerequisites

- Flutter SDK `^3.x` with Dart `^3.12`
- A [Supabase](https://supabase.com) project with migrations applied
- A Firebase project with FCM enabled and `google-services.json` placed in `android/app/`
- A `.env` file at the project root (see `.env.example` if provided)

### Installation

```bash
# 1. Clone the repository
git clone <repo-url>
cd honk

# 2. Install dependencies
flutter pub get

# 3. Run code generation (Freezed, Injectable, GoRouter, Envied, JSON)
dart run build_runner build --delete-conflicting-outputs

# 4. Launch the app
flutter run
```

> **Tip:** Run `dart run build_runner watch --delete-conflicting-outputs` during development to keep generated files up to date automatically.

### Environment Variables

Create a `.env` file (gitignored) with at minimum:

```dotenv
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
HONK_WEBHOOK_SECRET=your-webhook-secret
```

After editing `.env`, re-run code generation to regenerate the `Env` class.

---

## Development Commands

| Command | Purpose |
|---|---|
| `flutter pub get` | Install dependencies |
| `dart run build_runner build --delete-conflicting-outputs` | One-shot code generation |
| `dart run build_runner watch --delete-conflicting-outputs` | Watch mode code generation |
| `flutter run` | Run on a connected emulator or device |
| `flutter analyze` | Static analysis (`flutter_lints`) |
| `dart format .` | Format all Dart files |
| `flutter test` | Run unit and widget tests |

---

## Contributing

1. Follow [Conventional Commits](https://www.conventionalcommits.org/) — e.g. `feat(honk): add recurrence picker`
2. Keep commits focused and independently buildable
3. Run `flutter analyze` and `flutter test` before opening a PR
4. PRs should include a short summary, linked issue/task, verification steps, and screenshots for UI changes
5. Never commit secrets — store them in `.env` only

---

## Project Structure Notes

- Generated files (`*.g.dart`, `*.freezed.dart`, `injection.config.dart`, `app_router.g.dart`) are produced by `build_runner` — **do not edit them manually**
- Register new dependencies in `lib/core/di/register_module.dart`
- Environment switches (dev / prod) are handled in `main.dart` via `configureDependencies(AppEnv.dev)`
- The Supabase Edge Function powering push notifications lives in `supabase/functions/honk-push/`
