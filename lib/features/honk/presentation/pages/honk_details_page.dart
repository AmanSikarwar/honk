import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../common/widgets/honk_chip.dart';
import '../../../../common/widgets/user_avatar.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/honk_activity.dart';
import '../../domain/entities/honk_activity_details.dart';
import '../../domain/entities/honk_participant.dart';
import '../../domain/entities/honk_status_option.dart';
import '../cubit/honk_details_cubit.dart';

class HonkDetailsPage extends StatefulWidget {
  const HonkDetailsPage({required this.activityId, super.key});
  final String activityId;

  @override
  State<HonkDetailsPage> createState() => _HonkDetailsPageState();
}

class _HonkDetailsPageState extends State<HonkDetailsPage> {
  Timer? _ticker;
  DateTime _nowUtc = DateTime.now().toUtc();

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _nowUtc = DateTime.now().toUtc());
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HonkDetailsCubit, HonkDetailsState>(
      listener: (ctx, state) {
        if (state.wasDeleted || state.wasLeft) {
          const HomeRoute().go(ctx);
          return;
        }
        if (state.actionError != null) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.actionError.toString())));
          ctx.read<HonkDetailsCubit>().clearActionError();
        }
        if (state.rotatedInviteCode != null) {
          _showNewCodeDialog(ctx, state.rotatedInviteCode!);
          ctx.read<HonkDetailsCubit>().clearRotatedInviteCode();
        }
      },
      child: BlocBuilder<HonkDetailsCubit, HonkDetailsState>(
        builder: (ctx, state) {
          if (state.isLoading && state.details == null) {
            return const _LoadingScaffold();
          }
          if (state.loadFailure != null && state.details == null) {
            return _ErrorScaffold(
              error: state.loadFailure.toString(),
              onRetry: () =>
                  ctx.read<HonkDetailsCubit>().watch(widget.activityId),
            );
          }
          final details = state.details;
          if (details == null) return const _LoadingScaffold();
          return _DetailsScaffold(
            details: details,
            state: state,
            nowUtc: _nowUtc,
            activityId: widget.activityId,
          );
        },
      ),
    );
  }

  void _showNewCodeDialog(BuildContext ctx, String code) {
    showDialog<void>(
      context: ctx,
      builder: (_) => AlertDialog(
        title: const Text('New invite code 🔄'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('The old code is now invalid. Share the new one:'),
            const SizedBox(height: AppSpacing.md),
            _CopyRow(label: 'Code', value: code),
            const SizedBox(height: AppSpacing.sm),
            _CopyRow(label: 'Link', value: 'https://honkapp.app/join/$code'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

// ── Loading / Error scaffolds ─────────────────────────────────────────────────

class _LoadingScaffold extends StatelessWidget {
  const _LoadingScaffold();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: const Center(child: CircularProgressIndicator()),
  );
}

class _ErrorScaffold extends StatelessWidget {
  const _ErrorScaffold({required this.error, required this.onRetry});
  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: AppSpacing.md),
              Text(error, textAlign: TextAlign.center),
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

// ── Details scaffold ──────────────────────────────────────────────────────────

class _DetailsScaffold extends StatelessWidget {
  const _DetailsScaffold({
    required this.details,
    required this.state,
    required this.nowUtc,
    required this.activityId,
  });

  final HonkActivityDetails details;
  final HonkDetailsState state;
  final DateTime nowUtc;
  final String activityId;

  @override
  Widget build(BuildContext context) {
    final activity = details.activity;
    final isCreator = details.isCreator;
    final me = details.currentUserParticipant;
    final cubit = context.read<HonkDetailsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(activity.activity, overflow: TextOverflow.ellipsis),
        actions: [
          if (isCreator) ...[
            IconButton(
              tooltip: 'Share invite',
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _showShareSheet(context, activity),
            ),
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: state.isUpdating
                  ? null
                  : () => _showEditSheet(context, details),
            ),
            PopupMenuButton<_Action>(
              icon: const Icon(Icons.more_vert),
              onSelected: (a) {
                if (a == _Action.rotate) cubit.rotateInvite(activityId);
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: _Action.rotate,
                  child: ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text('Rotate invite code'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: [
          _ActivityInfoCard(activity: activity),
          if (isCreator && details.pendingParticipants.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            _PendingRequestsCard(
              pendingParticipants: details.pendingParticipants,
              activityId: activityId,
              processingIds: state.processingApprovalIds,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _ParticipantsList(
            participants: details.participants,
            statusOptions: details.statusOptions,
            nowUtc: nowUtc,
          ),
        ],
      ),
      floatingActionButton: _StatusFab(
        details: details,
        state: state,
        activityId: activityId,
        currentParticipant: me,
        nowUtc: nowUtc,
      ),
      bottomNavigationBar: _BottomActions(
        activityId: activityId,
        isCreator: isCreator,
        state: state,
      ),
    );
  }

  void _showShareSheet(BuildContext context, HonkActivity activity) {
    final code = activity.inviteCode;
    final link = 'https://honkapp.app/join/$code';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Invite friends 📣',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              width: 200,
              height: 200,
              child: PrettyQrView.data(
                data: link,
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(color: AppColors.brandPurple),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _CopyRow(label: 'Code', value: code),
            const SizedBox(height: AppSpacing.sm),
            _CopyRow(label: 'Link', value: link),
          ],
        ),
      ),
    );
  }

  void _showEditSheet(BuildContext context, HonkActivityDetails details) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<HonkDetailsCubit>(),
        child: _EditHonkSheet(details: details, activityId: activityId),
      ),
    );
  }
}

enum _Action { rotate }

// ── Activity info card ────────────────────────────────────────────────────────

class _ActivityInfoCard extends StatelessWidget {
  const _ActivityInfoCard({required this.activity});
  final HonkActivity activity;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(Icons.place_outlined, activity.location),
            if (activity.details?.isNotEmpty == true) ...[
              const SizedBox(height: AppSpacing.sm),
              _InfoRow(Icons.info_outline, activity.details!),
            ],
            const SizedBox(height: AppSpacing.sm),
            _InfoRow(
              Icons.timer_outlined,
              'Status resets after ${_fmt(activity.statusResetSeconds)}',
            ),
            const Divider(height: AppSpacing.lg),
            Row(
              children: [
                Icon(Icons.key_rounded, size: 16, color: cs.onSurfaceVariant),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    activity.inviteCode,
                    style: GoogleFonts.sourceCodePro(fontSize: 13),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, size: 16),
                  tooltip: 'Copy code',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: activity.inviteCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Code copied!')),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${seconds ~/ 60}m';
    return '${seconds ~/ 3600}h';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.text);
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

// ── Pending requests card ─────────────────────────────────────────────────────

class _PendingRequestsCard extends StatelessWidget {
  const _PendingRequestsCard({
    required this.pendingParticipants,
    required this.activityId,
    required this.processingIds,
  });
  final List<HonkParticipant> pendingParticipants;
  final String activityId;
  final Set<String> processingIds;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HonkDetailsCubit>();
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.statusAmberBg,
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  child: Text(
                    '${pendingParticipants.length} pending',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.statusAmber,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Join requests',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          ...pendingParticipants.map((p) {
            final processing = processingIds.contains(p.userId);
            return ListTile(
              leading: UserAvatar(
                username: p.username,
                profileUrl: p.profileUrl,
              ),
              title: Text(p.fullName ?? p.username),
              subtitle: Text(
                '@${p.username}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: processing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ActionBtn(
                          icon: Icons.check_rounded,
                          color: AppColors.statusGreen,
                          tooltip: 'Approve',
                          onPressed: () => cubit.approveJoinRequest(p.userId),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        _ActionBtn(
                          icon: Icons.close_rounded,
                          color: AppColors.statusRed,
                          tooltip: 'Deny',
                          onPressed: () => cubit.denyJoinRequest(p.userId),
                        ),
                      ],
                    ),
            );
          }),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.xs),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
      ),
    );
  }
}

// ── Participants list ─────────────────────────────────────────────────────────

class _ParticipantsList extends StatelessWidget {
  const _ParticipantsList({
    required this.participants,
    required this.statusOptions,
    required this.nowUtc,
  });
  final List<HonkParticipant> participants;
  final List<HonkStatusOption> statusOptions;
  final DateTime nowUtc;

  @override
  Widget build(BuildContext context) {
    final labelsByKey = {for (final o in statusOptions) o.statusKey: o.label};

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: Text(
              'Members (${participants.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...participants.map((p) {
            final statusLabel =
                labelsByKey[p.effectiveStatusKey] ?? p.effectiveStatusKey;
            final expiresAt = p.statusExpiresAt;
            final isExpired = expiresAt == null || expiresAt.isBefore(nowUtc);
            final timeLeft = (expiresAt != null && !isExpired)
                ? expiresAt.difference(nowUtc)
                : null;
            final countdownText = timeLeft != null
                ? _fmtDuration(timeLeft)
                : null;

            return ListTile(
              leading: UserAvatar(
                username: p.username,
                profileUrl: p.profileUrl,
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      p.fullName ?? p.username,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (p.isCreator) ...[
                    const SizedBox(width: 4),
                    const Text('⭐', style: TextStyle(fontSize: 12)),
                  ],
                ],
              ),
              subtitle: Text(
                '@${p.username}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: HonkChip(
                label: statusLabel,
                countdown: countdownText,
                color: _chipColor(statusLabel),
                bgColor: _chipBgColor(statusLabel),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _fmtDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) return '${h}h ${m}m';
    if (m > 0) return '${m}m ${s}s';
    return '${s}s';
  }

  Color _chipColor(String label) {
    final l = label.toLowerCase();
    if (l.contains('go') || l.contains('yes')) return AppColors.statusGreen;
    if (l.contains('maybe') || l.contains('possibly')) {
      return AppColors.statusAmber;
    }
    if (l.contains('no') || l.contains('not')) return AppColors.statusRed;
    return AppColors.statusPurple;
  }

  Color _chipBgColor(String label) {
    final l = label.toLowerCase();
    if (l.contains('go') || l.contains('yes')) return AppColors.statusGreenBg;
    if (l.contains('maybe') || l.contains('possibly')) {
      return AppColors.statusAmberBg;
    }
    if (l.contains('no') || l.contains('not')) return AppColors.statusRedBg;
    return AppColors.statusPurpleBg;
  }
}

// ── Status FAB ────────────────────────────────────────────────────────────────

class _StatusFab extends StatelessWidget {
  const _StatusFab({
    required this.details,
    required this.state,
    required this.activityId,
    required this.currentParticipant,
    required this.nowUtc,
  });
  final HonkActivityDetails details;
  final HonkDetailsState state;
  final String activityId;
  final HonkParticipant? currentParticipant;
  final DateTime nowUtc;

  @override
  Widget build(BuildContext context) {
    final isSaving = state.isSavingStatus;
    final me = currentParticipant;
    final currentStatus = me?.effectiveStatusKey;
    final expiresAt = me?.statusExpiresAt;
    final hasActiveStatus =
        currentStatus != null && expiresAt != null && expiresAt.isAfter(nowUtc);
    final currentLabel = hasActiveStatus
        ? (details.statusOptions
                  .where((o) => o.statusKey == currentStatus)
                  .firstOrNull
                  ?.label ??
              currentStatus)
        : 'Honk!';

    return FloatingActionButton.extended(
      onPressed: isSaving ? null : () => _showStatusSheet(context),
      icon: isSaving
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('📣', style: TextStyle(fontSize: 20)),
      label: Text(isSaving ? 'Updating…' : currentLabel),
    );
  }

  void _showStatusSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetCtx) => BlocProvider.value(
        value: context.read<HonkDetailsCubit>(),
        child: _StatusPickerSheet(
          statusOptions: details.statusOptions,
          currentStatusKey: currentParticipant?.effectiveStatusKey,
          activityId: activityId,
        ),
      ),
    );
  }
}

// ── Status picker sheet ───────────────────────────────────────────────────────

class _StatusPickerSheet extends StatelessWidget {
  const _StatusPickerSheet({
    required this.statusOptions,
    required this.currentStatusKey,
    required this.activityId,
  });
  final List<HonkStatusOption> statusOptions;
  final String? currentStatusKey;
  final String activityId;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set your status',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Others will see your status in real time.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          ...statusOptions.map((opt) {
            final isCurrent = opt.statusKey == currentStatusKey;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: isCurrent
                      ? null
                      : FilledButton.styleFrom(
                          backgroundColor: cs.surfaceContainerHigh,
                          foregroundColor: cs.onSurface,
                        ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<HonkDetailsCubit>().setStatus(
                      activityId: activityId,
                      statusKey: opt.statusKey,
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(child: Text(opt.label)),
                      if (isCurrent)
                        const Icon(Icons.check_circle_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ── Bottom actions ────────────────────────────────────────────────────────────

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.activityId,
    required this.isCreator,
    required this.state,
  });
  final String activityId;
  final bool isCreator;
  final HonkDetailsState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HonkDetailsCubit>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: isCreator
            ? OutlinedButton.icon(
                onPressed: state.isDeleting
                    ? null
                    : () => _confirmDelete(context, cubit),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                  side: BorderSide(color: Theme.of(context).colorScheme.error),
                ),
                icon: state.isDeleting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_outline),
                label: const Text('Delete honk'),
              )
            : OutlinedButton.icon(
                onPressed: state.isLeaving
                    ? null
                    : () => _confirmLeave(context, cubit),
                icon: state.isLeaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.exit_to_app),
                label: const Text('Leave honk'),
              ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    HonkDetailsCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete honk? 🗑️'),
        content: const Text('This permanently removes the honk for everyone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) await cubit.deleteActivity(activityId);
  }

  Future<void> _confirmLeave(
    BuildContext context,
    HonkDetailsCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave honk?'),
        content: const Text('You can rejoin with an invite code later.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (confirmed == true) await cubit.leaveActivity(activityId);
  }
}

// ── Edit honk sheet ───────────────────────────────────────────────────────────

class _EditHonkSheet extends StatefulWidget {
  const _EditHonkSheet({required this.details, required this.activityId});
  final HonkActivityDetails details;
  final String activityId;

  @override
  State<_EditHonkSheet> createState() => _EditHonkSheetState();
}

class _EditHonkSheetState extends State<_EditHonkSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _actCtrl;
  late final TextEditingController _locCtrl;
  late final TextEditingController _detCtrl;
  late int _resetSecs;
  late final List<_StatusRow> _rows;
  late int _defaultIdx;

  @override
  void initState() {
    super.initState();
    final a = widget.details.activity;
    _actCtrl = TextEditingController(text: a.activity);
    _locCtrl = TextEditingController(text: a.location);
    _detCtrl = TextEditingController(text: a.details ?? '');
    _resetSecs = a.statusResetSeconds;
    final opts = widget.details.statusOptions;
    _rows = opts.map((o) => _StatusRow(o.statusKey, o.label)).toList();
    _defaultIdx = opts.indexWhere((o) => o.isDefault).clamp(0, opts.length - 1);
  }

  @override
  void dispose() {
    _actCtrl.dispose();
    _locCtrl.dispose();
    _detCtrl.dispose();
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  List<HonkStatusOption>? _buildOpts() {
    if (_rows.length < 2) return null;
    final opts = <HonkStatusOption>[];
    for (var i = 0; i < _rows.length; i++) {
      final k = _rows[i].keyCtrl.text.trim();
      final l = _rows[i].labelCtrl.text.trim();
      if (k.isEmpty || l.isEmpty) return null;
      if (!RegExp(r'^[a-z0-9_]+$').hasMatch(k)) return null;
      opts.add(
        HonkStatusOption(
          statusKey: k,
          label: l,
          sortOrder: i,
          isDefault: i == _defaultIdx,
          isActive: true,
        ),
      );
    }
    if (opts.map((o) => o.statusKey).toSet().length != opts.length) return null;
    return opts;
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) return;
    final opts = _buildOpts();
    if (opts == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Check status options.')));
      return;
    }
    Navigator.of(context).pop();
    context.read<HonkDetailsCubit>().updateActivity(
      activityId: widget.activityId,
      activity: _actCtrl.text.trim(),
      location: _locCtrl.text.trim(),
      details: _detCtrl.text.trim().isEmpty ? null : _detCtrl.text.trim(),
      statusResetSeconds: _resetSecs,
      statusOptions: opts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollCtrl) => Form(
        key: _formKey,
        child: ListView(
          controller: scrollCtrl,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.xl,
          ),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Edit Honk ✏️', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _actCtrl,
              decoration: const InputDecoration(labelText: 'Activity *'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _locCtrl,
              decoration: const InputDecoration(labelText: 'Location *'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _detCtrl,
              decoration: const InputDecoration(
                labelText: 'Details (optional)',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              initialValue: _resetSecs,
              decoration: const InputDecoration(
                labelText: 'Status resets after',
              ),
              items: const [
                DropdownMenuItem(value: 600, child: Text('10 minutes')),
                DropdownMenuItem(value: 1800, child: Text('30 minutes')),
                DropdownMenuItem(value: 3600, child: Text('1 hour')),
                DropdownMenuItem(value: 7200, child: Text('2 hours')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _resetSecs = v);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Status options',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(_rows.length, (i) {
              final row = _rows[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _defaultIdx = i),
                      icon: Icon(
                        i == _defaultIdx
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: row.keyCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Key',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextField(
                        controller: row.labelCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Label',
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _rows.length <= 2
                          ? null
                          : () {
                              setState(() {
                                _rows.removeAt(i).dispose();
                                _defaultIdx = _defaultIdx.clamp(
                                  0,
                                  _rows.length - 1,
                                );
                              });
                            },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: _rows.length >= 8
                  ? null
                  : () => setState(() {
                      _rows.add(
                        _StatusRow(
                          'status_${_rows.length + 1}',
                          'Option ${_rows.length + 1}',
                        ),
                      );
                    }),
              icon: const Icon(Icons.add),
              label: const Text('Add option'),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: _save, child: const Text('Save')),
          ],
        ),
      ),
    );
  }
}

class _StatusRow {
  _StatusRow(String key, String label)
    : keyCtrl = TextEditingController(text: key),
      labelCtrl = TextEditingController(text: label);
  final TextEditingController keyCtrl;
  final TextEditingController labelCtrl;
  void dispose() {
    keyCtrl.dispose();
    labelCtrl.dispose();
  }
}

// ── Copyable row ──────────────────────────────────────────────────────────────

class _CopyRow extends StatelessWidget {
  const _CopyRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              Text(
                value,
                style: GoogleFonts.sourceCodePro(fontSize: 13),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Copy',
          icon: const Icon(Icons.copy, size: 18),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: value));
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('$label copied!')));
          },
        ),
      ],
    );
  }
}
