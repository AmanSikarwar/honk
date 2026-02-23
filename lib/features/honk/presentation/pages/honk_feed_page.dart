import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/comic_ui.dart';
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
      backgroundColor: AppColors.comicLavender,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: _FeedHeader()),
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
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: AppSpacing.md),
                            itemBuilder: (ctx, i) =>
                                ActivityCard(activity: activities[i]),
                          ),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

enum _FeedMenuAction { newHonk, joinByCode, scanQr, settings }

class _FeedHeader extends StatelessWidget {
  const _FeedHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xl,
      ),
      child: Row(
        children: [
          const ComicBrandMark(fontSize: 42),
          const Spacer(),
          PopupMenuButton<_FeedMenuAction>(
            color: Colors.white,
            tooltip: 'Actions',
            onSelected: (value) {
              if (value == _FeedMenuAction.newHonk) {
                const CreateHonkRoute().push(context);
                return;
              }
              if (value == _FeedMenuAction.joinByCode) {
                _showJoinSheet(context);
                return;
              }
              if (value == _FeedMenuAction.scanQr) {
                const QrScannerRoute().push(context);
                return;
              }
              const SettingsRoute().push(context);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: _FeedMenuAction.newHonk,
                child: Text('New Honk'),
              ),
              PopupMenuItem(
                value: _FeedMenuAction.joinByCode,
                child: Text('Join by code'),
              ),
              PopupMenuItem(
                value: _FeedMenuAction.scanQr,
                child: Text('Scan QR'),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: _FeedMenuAction.settings,
                child: Text('Settings'),
              ),
            ],
            child: const ComicSettingsIcon(size: 52),
          ),
        ],
      ),
    );
  }

  void _showJoinSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider(
        create: (_) => getIt<JoinHonkCubit>(),
        child: _JoinByCodeSheet(parentContext: context),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});
  final HonkActivitySummary activity;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => HonkDetailsRoute(activityId: activity.id).push(context),
        borderRadius: BorderRadius.circular(16),
        child: ComicCardContainer(
          radius: 16,
          backgroundColor: AppColors.comicPanel,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ComicOutlinedText(
                      activity.activity.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                      strokeWidth: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              const ComicHornIcon(size: 48),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyFeedView extends StatelessWidget {
  const _EmptyFeedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ComicCardContainer(
          backgroundColor: AppColors.comicPanelSoft,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ComicHornIcon(size: 68),
              const SizedBox(height: AppSpacing.md),
              ComicOutlinedText(
                'NO HONKS YET',
                style: const TextStyle(fontSize: 28),
                strokeWidth: 4,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Create one from the top-right menu.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.comicInk.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ComicCardContainer(
          backgroundColor: AppColors.comicPanelSoft,
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
      ),
    );
  }
}

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
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: ComicCardContainer(
          backgroundColor: AppColors.comicPanel,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ComicOutlinedText(
                'JOIN BY CODE',
                style: const TextStyle(fontSize: 24),
                strokeWidth: 4,
              ),
              const SizedBox(height: AppSpacing.md),
              BlocBuilder<JoinHonkCubit, JoinHonkState>(
                builder: (ctx, state) {
                  final loading = state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  );

                  final fieldFill = AppColors.comicPanelSoft;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _ctrl,
                        enabled: !loading,
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.comicInk,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Paste invite code',
                          filled: true,
                          fillColor: fieldFill,
                          prefixIcon: const Icon(Icons.key_rounded),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.md,
                          ),
                        ),
                        onSubmitted: (_) => _join(ctx),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton.icon(
                        onPressed: loading ? null : () => _join(ctx),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.comicPanelDark,
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: AppColors.comicInk,
                            width: 2,
                          ),
                        ),
                        icon: loading
                            ? const SmallSpinner()
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
      ),
    );
  }

  void _join(BuildContext context) {
    context.read<JoinHonkCubit>().joinByCode(_ctrl.text.trim());
  }
}
