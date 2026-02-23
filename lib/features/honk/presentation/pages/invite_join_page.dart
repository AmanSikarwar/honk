import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/join_honk_cubit.dart';

class InviteJoinPage extends StatefulWidget {
  const InviteJoinPage({required this.inviteCode, super.key});
  final String inviteCode;

  @override
  State<InviteJoinPage> createState() => _InviteJoinPageState();
}

class _InviteJoinPageState extends State<InviteJoinPage> {
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    context.read<JoinHonkCubit>().joinByCode(widget.inviteCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinHonkCubit, JoinHonkState>(
      listener: (ctx, state) {
        state.mapOrNull(
          success: (s) {
            if (_didNavigate) return;
            _didNavigate = true;
            HonkDetailsRoute(activityId: s.activityId).go(ctx);
          },
        );
      },
      child: BlocBuilder<JoinHonkCubit, JoinHonkState>(
        builder: (ctx, state) {
          return Scaffold(
            body: state.map(
              idle: (_) => const _JoinStateView(
                emoji: '🔗',
                title: 'Preparing…',
                subtitle: 'Getting things ready',
                showSpinner: true,
              ),
              loading: (_) => const _JoinStateView(
                emoji: '🏃',
                title: 'Joining activity…',
                subtitle: 'Just a moment',
                showSpinner: true,
              ),
              pendingApproval: (_) => const _JoinStateView(
                emoji: '⏳',
                title: 'Waiting for approval',
                subtitle: 'The creator will let you in shortly.\nHang tight!',
                showSpinner: true,
              ),
              success: (_) => const _JoinStateView(
                emoji: '🎉',
                title: "You're in!",
                subtitle: 'Redirecting you now…',
                showSpinner: true,
              ),
              failure: (f) => _JoinFailureView(
                message: f.failure.toString(),
                onRetry: () {
                  _didNavigate = false;
                  ctx.read<JoinHonkCubit>().joinByCode(widget.inviteCode);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── State view ────────────────────────────────────────────────────────────────

class _JoinStateView extends StatelessWidget {
  const _JoinStateView({
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.showSpinner = false,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.gradientStart, AppColors.gradientMid],
            ),
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 72)),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
              if (showSpinner) ...[
                const SizedBox(height: AppSpacing.xl),
                const SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

// ── Failure view ──────────────────────────────────────────────────────────────

class _JoinFailureView extends StatelessWidget {
  const _JoinFailureView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.gradientStart, AppColors.gradientMid],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('😕', style: TextStyle(fontSize: 72)),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Couldn\'t join',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.brandPurple,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try again'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => const HomeRoute().go(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                    ),
                    child: const Text('Back to home'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
