# Repository Guidelines

## Project Structure & Module Organization
- `lib/main.dart` bootstraps Firebase, Supabase, dependency injection, and routing.
- `lib/core/` holds shared infrastructure: DI (`core/di`), routing (`core/router`), deep links, and env access.
- `lib/features/` contains feature modules split by layer: `data/`, `domain/`, and `presentation/` (see `lib/features/auth/`).
- Platform/integration files live in `android/`, `firebase.json`, and `lib/firebase_options.dart`.
- Generated files (`*.g.dart`, `*.freezed.dart`, `lib/core/di/injection.config.dart`, `lib/core/router/app_router.g.dart`) are codegen outputs; do not edit them manually.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies.
- `dart run build_runner build --delete-conflicting-outputs` regenerates Freezed, JSON, Injectable, Envied, and GoRouter code.
- `dart run build_runner watch --delete-conflicting-outputs` keeps generated code updated during development.
- `flutter run` launches the app on a connected emulator/device.
- `flutter analyze` runs static analysis using `flutter_lints`.
- `dart format .` formats the codebase.
- `flutter test` runs tests (once `test/` files are present).

## Coding Style & Naming Conventions
- Follow standard Dart style: 2-space indentation, `lowerCamelCase` members, `UpperCamelCase` types, and `snake_case.dart` file names.
- Keep business logic in `domain`, IO/integrations in `data`, and UI/state handling in `presentation`.
- Prefer dependency injection through `get_it`/`injectable`; register bindings via `lib/core/di/register_module.dart`.

## Testing Guidelines
- Use `flutter_test` for unit and widget tests.
- Mirror `lib/` structure under `test/` (example: `test/features/auth/presentation/login_page_test.dart`).
- Name test files `*_test.dart` and avoid real network/Firebase/Supabase calls in tests; mock repositories/services.
- Run `flutter analyze` and `flutter test` before submitting changes. No enforced coverage gate exists yet, so add tests for new logic and bug fixes.

## Commit & Pull Request Guidelines
- Prefer Conventional Commit style already used in history, for example: `feat(auth): add password reset flow` or `chore: bump dependencies`.
- Keep commits focused and independently buildable.
- PRs should include: a short summary, linked issue/task, verification steps run locally, and screenshots/screen recordings for UI changes.

## Security & Configuration Tips
- Store secrets in `.env`; never commit real credentials.
- `.env` and generated env outputs are ignored by git; regenerate code after env changes.
- `main.dart` currently initializes `AppEnv.dev`; call out any environment changes in PR descriptions.
