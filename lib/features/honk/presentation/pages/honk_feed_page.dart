import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/honk_activity_summary.dart';
import '../bloc/honk_feed_bloc.dart';
import '../cubit/join_honk_cubit.dart';

class HonkFeedPage extends StatelessWidget {
  const HonkFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _HonkAppBar(),
          BlocBuilder<HonkFeedBloc, HonkFeedState>(
            builder: (context, state) {
              return state.when(
                initial: () => const SliverFillRemaining(child: SizedBox()),
                loadInProgress: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                loadFailure: (failure) => SliverFillRemaining(
                  child: _ErrorView(
                    message: failure.toString(),
                    onRetry: () => context.read<HonkFeedBloc>().add(
                      const HonkFeedEvent.started(),
                    ),
                  ),
                ),
                loadSuccess: (activities) => activities.isEmpty
                    ? const SliverFillRemaining(child: _EmptyFeedView())
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.md,
                          AppSpacing.sm,
                          AppSpacing.md,
                          AppSpacing.xxl,
                        ),
                        sliver: SliverList.separated(
                          itemCount: activities.length,
                          separatorBuilder: (_, i) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (ctx, i) =>
                              ActivityCard(activity: activities[i]),
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => const CreateHonkRoute().push(context),
        icon: const Text('📣', style: TextStyle(fontSize: 18)),
        label: const Text('New Honk'),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────

class _HonkAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SliverAppBar(
      expandedHeight: 0,
      pinned: true,
      title: Text(
        'Honks 📣',
        style: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: cs.onSurface,
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Scan QR',
          icon: const Icon(Icons.qr_code_scanner_rounded),
          onPressed: () => const QrScannerRoute().push(context),
        ),
        IconButton(
          tooltip: 'Join by code',
          icon: const Icon(Icons.link_rounded),
          onPressed: () => _showJoinSheet(context),
        ),
        IconButton(
          tooltip: 'Settings',
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => const SettingsRoute().push(context),
        ),
      ],
    );
  }

  void _showJoinSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(
        create: (_) => getIt<JoinHonkCubit>(),
        child: _JoinByCodeSheet(parentContext: context),
      ),
    );
  }
}

// ── Activity card ─────────────────────────────────────────────────────────────

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});
  final HonkActivitySummary activity;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isCreator = activity.isCreator;

    return Card(
      child: InkWell(
        onTap: () => HonkDetailsRoute(activityId: activity.id).push(context),
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Role indicator strip
              Container(
                width: 4,
                height: 48,
                margin: const EdgeInsets.only(right: AppSpacing.md),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isCreator
                        ? [AppColors.brandPurple, AppColors.accentFuchsia]
                        : [
                            AppColors.accentFuchsia.withValues(alpha: 0.6),
                            AppColors.brandPurpleLight,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            activity.activity,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCreator)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.xs + 2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.creatorBadge,
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                            ),
                            child: Text(
                              'Creator',
                              style: GoogleFonts.nunito(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.creatorBadgeFg,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 13,
                          color: cs.onSurfaceVariant,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            activity.location,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people_outline, size: 14, color: cs.primary),
                      const SizedBox(width: 3),
                      Text(
                        '${activity.participantCount}',
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: cs.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Icon(Icons.chevron_right, size: 18, color: cs.outlineVariant),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyFeedView extends StatelessWidget {
  const _EmptyFeedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('📣', style: TextStyle(fontSize: 72)),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No honks yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create one or join an existing honk\nwith an invite code.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.md),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Join by code sheet ────────────────────────────────────────────────────────

class _JoinByCodeSheet extends StatefulWidget {
  const _JoinByCodeSheet({required this.parentContext});
  final BuildContext parentContext;

  @override
  State<_JoinByCodeSheet> createState() => _JoinByCodeSheetState();
}

class _JoinByCodeSheetState extends State<_JoinByCodeSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinHonkCubit, JoinHonkState>(
      listener: (ctx, state) {
        state.when(
          idle: () {},
          loading: () {},
          pendingApproval: (_) {
            Navigator.of(ctx).pop();
            ScaffoldMessenger.of(widget.parentContext).showSnackBar(
              const SnackBar(
                content: Text('Request sent! Waiting for approval.'),
              ),
            );
          },
          success: (activityId) {
            Navigator.of(ctx).pop();
            HonkDetailsRoute(activityId: activityId).push(widget.parentContext);
          },
          failure: (f) => ScaffoldMessenger.of(
            widget.parentContext,
          ).showSnackBar(SnackBar(content: Text(f.toString()))),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          top: AppSpacing.sm,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join by invite code 🔗',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            BlocBuilder<JoinHonkCubit, JoinHonkState>(
              builder: (ctx, state) {
                final loading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _ctrl,
                      enabled: !loading,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Invite code',
                        hintText: 'Paste the 12-character code',
                        prefixIcon: Icon(Icons.key_rounded),
                      ),
                      onSubmitted: (_) => _join(ctx),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.icon(
                      onPressed: loading ? null : () => _join(ctx),
                      icon: loading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.login_rounded),
                      label: const Text('Join'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _join(BuildContext context) {
    context.read<JoinHonkCubit>().joinByCode(_ctrl.text.trim());
  }
}
