import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/honk_activity_summary.dart';
import '../bloc/honk_feed_bloc.dart';
import '../cubit/join_honk_cubit.dart';

class HonkFeedPage extends StatelessWidget {
  const HonkFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Honks'),
        actions: [
          IconButton(
            tooltip: 'Join by code',
            icon: const Icon(Icons.login_rounded),
            onPressed: () => _showJoinSheet(context),
          ),
          IconButton(
            tooltip: 'Friends',
            icon: const Icon(Icons.group_outlined),
            onPressed: () => const FriendManagementRoute().push(context),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => const SettingsRoute().push(context),
          ),
        ],
      ),
      body: BlocBuilder<HonkFeedBloc, HonkFeedState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loadInProgress: () =>
                const Center(child: CircularProgressIndicator()),
            loadFailure: (failure) => _ErrorView(
              message: failure.toString(),
              onRetry: () => context.read<HonkFeedBloc>().add(
                const HonkFeedEvent.started(),
              ),
            ),
            loadSuccess: (activities) => activities.isEmpty
                ? const _EmptyFeedView()
                : _ActivityList(activities: activities),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => const CreateHonkRoute().push(context),
        icon: const Icon(Icons.add),
        label: const Text('New Honk'),
      ),
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

class _ActivityList extends StatelessWidget {
  const _ActivityList({required this.activities});

  final List<HonkActivitySummary> activities;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: activities.length,
      separatorBuilder: (_, _) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return _ActivityCard(activity: activity);
      },
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});

  final HonkActivitySummary activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final schedule = _formatSchedule(activity);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Icon(
          activity.isCreator ? Icons.star_rounded : Icons.campaign_rounded,
          color: theme.colorScheme.onPrimaryContainer,
          size: 20,
        ),
      ),
      title: Text(
        activity.activity,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${activity.location} • $schedule',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${activity.participantCount} ${activity.participantCount == 1 ? 'member' : 'members'}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
      onTap: () => HonkDetailsRoute(activityId: activity.id).push(context),
    );
  }

  String _formatSchedule(HonkActivitySummary a) {
    final startsAt = a.startsAt.toLocal();
    final month = startsAt.month.toString().padLeft(2, '0');
    final day = startsAt.day.toString().padLeft(2, '0');
    final hour = startsAt.hour.toString().padLeft(2, '0');
    final minute = startsAt.minute.toString().padLeft(2, '0');
    final dateStr = '$month/$day $hour:$minute';
    if (a.recurrenceRrule == null || a.recurrenceRrule!.trim().isEmpty) {
      return dateStr;
    }
    return dateStr;
  }
}

class _EmptyFeedView extends StatelessWidget {
  const _EmptyFeedView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 72,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No honks yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a new honk or join one using an invite code.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ],
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
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

// ── Join by code bottom sheet ─────────────────────────────────────────────────

class _JoinByCodeSheet extends StatefulWidget {
  const _JoinByCodeSheet({required this.parentContext});

  final BuildContext parentContext;

  @override
  State<_JoinByCodeSheet> createState() => _JoinByCodeSheetState();
}

class _JoinByCodeSheetState extends State<_JoinByCodeSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinHonkCubit, JoinHonkState>(
      listener: (context, state) {
        state.when(
          idle: () {},
          loading: () {},
          success: (activityId) {
            Navigator.of(context).pop();
            HonkDetailsRoute(activityId: activityId).push(widget.parentContext);
          },
          failure: (failure) {
            ScaffoldMessenger.of(
              widget.parentContext,
            ).showSnackBar(SnackBar(content: Text(failure.toString())));
          },
        );
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join by invite code',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            BlocBuilder<JoinHonkCubit, JoinHonkState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );
                return TextField(
                  controller: _controller,
                  enabled: !isLoading,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Invite code',
                    hintText: 'Paste the 12-character code',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _join(context),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<JoinHonkCubit, JoinHonkState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.icon(
                      onPressed: isLoading ? null : () => _join(context),
                      icon: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.login_rounded),
                      label: const Text('Join'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () {
                              Navigator.of(context).pop();
                              const QrScannerRoute().push(widget.parentContext);
                            },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan QR code'),
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
    context.read<JoinHonkCubit>().joinByCode(_controller.text);
  }
}
