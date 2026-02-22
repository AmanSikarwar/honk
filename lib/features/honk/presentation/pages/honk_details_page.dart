import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

import '../../../../core/router/app_router.dart';
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
      listener: (context, state) {
        if (state.wasDeleted || state.wasLeft) {
          const HomeRoute().go(context);
          return;
        }
        if (state.actionError != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.actionError.toString())));
          context.read<HonkDetailsCubit>().clearActionError();
        }
        if (state.rotatedInviteCode != null) {
          _showInviteCodeDialog(
            context,
            code: state.rotatedInviteCode!,
            details: state.details,
          );
          context.read<HonkDetailsCubit>().clearRotatedInviteCode();
        }
      },
      child: BlocBuilder<HonkDetailsCubit, HonkDetailsState>(
        builder: (context, state) {
          if (state.isLoading && state.details == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Loading…')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state.loadFailure != null && state.details == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.loadFailure.toString()),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => context.read<HonkDetailsCubit>().watch(
                          widget.activityId,
                        ),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final details = state.details;
          if (details == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Honk')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

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

  void _showInviteCodeDialog(
    BuildContext context, {
    required String code,
    required HonkActivityDetails? details,
  }) {
    final deepLink = 'https://honkapp.app/join/$code';
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Invite Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Share this code or link with friends:'),
            const SizedBox(height: 12),
            _CopyableRow(label: 'Code', value: code),
            const SizedBox(height: 8),
            _CopyableRow(label: 'Link', value: deepLink),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ── Main scaffold ─────────────────────────────────────────────────────────────

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
              tooltip: 'Edit honk',
              icon: const Icon(Icons.edit_outlined),
              onPressed: state.isUpdating
                  ? null
                  : () => _showEditDialog(context, details),
            ),
            IconButton(
              tooltip: 'Rotate invite',
              icon: const Icon(Icons.refresh),
              onPressed: state.isRotatingInvite
                  ? null
                  : () => cubit.rotateInvite(activityId),
            ),
          ],
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ActivityInfoCard(activity: activity),
          const SizedBox(height: 16),
          _ParticipantsList(
            participants: details.participants,
            statusOptions: details.statusOptions,
            nowUtc: nowUtc,
            statusResetSeconds: activity.statusResetSeconds,
          ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: _HonkFab(
        details: details,
        state: state,
        activityId: activityId,
        isCreator: isCreator,
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
    final deepLink = 'https://honkapp.app/join/$code';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Invite friends',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 200,
              child: PrettyQrView.data(
                data: deepLink,
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(),
                  quietZone: PrettyQrQuietZone.standard,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _CopyableRow(label: 'Code', value: code),
            const SizedBox(height: 8),
            _CopyableRow(label: 'Link', value: deepLink),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, HonkActivityDetails details) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<HonkDetailsCubit>(),
        child: _EditHonkDialog(details: details, activityId: activityId),
      ),
    );
  }
}

// ── Activity info card ────────────────────────────────────────────────────────

class _ActivityInfoCard extends StatelessWidget {
  const _ActivityInfoCard({required this.activity});

  final HonkActivity activity;

  @override
  Widget build(BuildContext context) {
    final schedule = activity.recurrenceRrule != null
        ? '${_parseRecurrence(activity.recurrenceRrule!)} starting ${_fmtLocal(activity.startsAt)}'
        : 'One-time on ${_fmtLocal(activity.startsAt)}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(icon: Icons.place_outlined, text: activity.location),
            const SizedBox(height: 8),
            _InfoRow(icon: Icons.schedule, text: schedule),
            if (activity.details != null && activity.details!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _InfoRow(icon: Icons.info_outline, text: activity.details!),
            ],
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.timer_outlined,
              text:
                  'Status resets after ${_formatReset(activity.statusResetSeconds)}',
            ),
          ],
        ),
      ),
    );
  }

  String _fmtLocal(DateTime utc) {
    final l = utc.toLocal();
    final m = l.month.toString().padLeft(2, '0');
    final d = l.day.toString().padLeft(2, '0');
    final h = l.hour.toString().padLeft(2, '0');
    final min = l.minute.toString().padLeft(2, '0');
    return '${l.year}-$m-$d $h:$min';
  }

  String _parseRecurrence(String rrule) {
    if (rrule.startsWith('FREQ=DAILY')) return 'Daily';
    if (rrule.startsWith('FREQ=WEEKLY')) return 'Weekly';
    return rrule;
  }

  String _formatReset(int seconds) {
    if (seconds < 60) return '${seconds}s';
    if (seconds < 3600) return '${seconds ~/ 60}m';
    return '${seconds ~/ 3600}h';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

// ── Participants list ─────────────────────────────────────────────────────────

class _ParticipantsList extends StatelessWidget {
  const _ParticipantsList({
    required this.participants,
    required this.statusOptions,
    required this.nowUtc,
    required this.statusResetSeconds,
  });

  final List<HonkParticipant> participants;
  final List<HonkStatusOption> statusOptions;
  final DateTime nowUtc;
  final int statusResetSeconds;

  @override
  Widget build(BuildContext context) {
    final labelsByKey = {for (final o in statusOptions) o.statusKey: o.label};

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Members',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...participants.map((p) {
            final statusLabel =
                labelsByKey[p.effectiveStatusKey] ?? p.effectiveStatusKey;
            final expiresAt = p.statusExpiresAt;
            final isExpired = expiresAt == null || expiresAt.isBefore(nowUtc);
            final timeLeft = expiresAt != null && !isExpired
                ? expiresAt.difference(nowUtc)
                : null;
            final displayName = p.fullName ?? p.username;
            final initials = displayName.isNotEmpty
                ? displayName[0].toUpperCase()
                : '?';

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHigh,
                backgroundImage: p.profileUrl != null
                    ? NetworkImage(p.profileUrl!)
                    : null,
                onBackgroundImageError: p.profileUrl != null ? (_, _) {} : null,
                child: p.profileUrl == null
                    ? Text(
                        initials,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              title: Row(
                children: [
                  Expanded(
                    child: Text(displayName, overflow: TextOverflow.ellipsis),
                  ),
                  if (p.isCreator)
                    const Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Icon(Icons.star_rounded, size: 16),
                    ),
                ],
              ),
              subtitle: Text(statusLabel),
              trailing: timeLeft != null
                  ? _Countdown(remaining: timeLeft)
                  : null,
            );
          }),
        ],
      ),
    );
  }
}

class _Countdown extends StatelessWidget {
  const _Countdown({required this.remaining});

  final Duration remaining;

  @override
  Widget build(BuildContext context) {
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    final text = hours > 0
        ? '${hours}h ${minutes}m'
        : minutes > 0
        ? '${minutes}m ${seconds}s'
        : '${seconds}s';

    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

// ── Honk FAB ─────────────────────────────────────────────────────────────────

class _HonkFab extends StatelessWidget {
  const _HonkFab({
    required this.details,
    required this.state,
    required this.activityId,
    required this.isCreator,
    required this.currentParticipant,
    required this.nowUtc,
  });

  final HonkActivityDetails details;
  final HonkDetailsState state;
  final String activityId;
  final bool isCreator;
  final HonkParticipant? currentParticipant;
  final DateTime nowUtc;

  @override
  Widget build(BuildContext context) {
    final isSaving = state.isSavingStatus;
    return FloatingActionButton.extended(
      onPressed: isSaving ? null : () => _showStatusSheet(context),
      icon: isSaving
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.campaign_rounded),
      label: Text(
        isSaving
            ? 'Updating…'
            : currentParticipant != null
            ? 'Honk!'
            : 'Honk!',
      ),
    );
  }

  void _showStatusSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<HonkDetailsCubit>(),
        child: _StatusPickerSheet(
          statusOptions: details.statusOptions,
          currentStatusKey: currentParticipant?.effectiveStatusKey,
          occurrenceStart: details.occurrenceStart,
          activityId: activityId,
        ),
      ),
    );
  }
}

class _StatusPickerSheet extends StatelessWidget {
  const _StatusPickerSheet({
    required this.statusOptions,
    required this.currentStatusKey,
    required this.occurrenceStart,
    required this.activityId,
  });

  final List<HonkStatusOption> statusOptions;
  final String? currentStatusKey;
  final DateTime occurrenceStart;
  final String activityId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set your status',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Others will be notified when you honk.'),
          const SizedBox(height: 16),
          ...statusOptions.map((option) {
            final isCurrent = option.statusKey == currentStatusKey;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: isCurrent
                      ? null
                      : FilledButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHigh,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface,
                        ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<HonkDetailsCubit>().setStatus(
                      activityId: activityId,
                      occurrenceStart: occurrenceStart,
                      statusKey: option.statusKey,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(option.label, style: const TextStyle(fontSize: 16)),
                      if (isCurrent)
                        const Icon(Icons.check_circle_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Bottom action bar ─────────────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            if (isCreator) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: state.isDeleting
                      ? null
                      : () => _confirmDelete(context, cubit),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  icon: state.isDeleting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
              ),
            ] else ...[
              Expanded(
                child: OutlinedButton.icon(
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
                  label: const Text('Leave'),
                ),
              ),
            ],
          ],
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
        title: const Text('Delete honk?'),
        content: const Text(
          'This permanently removes the honk for all members.',
        ),
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
    if (confirmed == true) {
      await cubit.deleteActivity(activityId);
    }
  }

  Future<void> _confirmLeave(
    BuildContext context,
    HonkDetailsCubit cubit,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Leave honk?'),
        content: const Text('You can rejoin later using an invite code.'),
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
    if (confirmed == true) {
      await cubit.leaveActivity(activityId);
    }
  }
}

// ── Edit honk dialog ──────────────────────────────────────────────────────────

class _EditHonkDialog extends StatefulWidget {
  const _EditHonkDialog({required this.details, required this.activityId});

  final HonkActivityDetails details;
  final String activityId;

  @override
  State<_EditHonkDialog> createState() => _EditHonkDialogState();
}

class _EditHonkDialogState extends State<_EditHonkDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _activityCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _detailsCtrl;

  late DateTime _startsAtUtc;
  late String _recurrenceType;
  final Set<int> _weeklyDays = {};
  late int _statusResetSeconds;
  late final List<_EditStatusRow> _statusRows;
  late int _defaultStatusIndex;

  @override
  void initState() {
    super.initState();
    final a = widget.details.activity;
    _activityCtrl = TextEditingController(text: a.activity);
    _locationCtrl = TextEditingController(text: a.location);
    _detailsCtrl = TextEditingController(text: a.details ?? '');
    _startsAtUtc = a.startsAt;
    _statusResetSeconds = a.statusResetSeconds;

    // Parse recurrence rrule.
    final rrule = a.recurrenceRrule;
    if (rrule == null || rrule.isEmpty) {
      _recurrenceType = 'none';
    } else if (rrule.startsWith('FREQ=DAILY')) {
      _recurrenceType = 'daily';
    } else if (rrule.startsWith('FREQ=WEEKLY')) {
      _recurrenceType = 'weekly';
      final byDayMatch = RegExp(r'BYDAY=([^;]+)').firstMatch(rrule);
      if (byDayMatch != null) {
        for (final code in byDayMatch.group(1)!.split(',')) {
          const dayMap = {
            'MO': DateTime.monday,
            'TU': DateTime.tuesday,
            'WE': DateTime.wednesday,
            'TH': DateTime.thursday,
            'FR': DateTime.friday,
            'SA': DateTime.saturday,
            'SU': DateTime.sunday,
          };
          final day = dayMap[code.trim()];
          if (day != null) _weeklyDays.add(day);
        }
      }
    } else {
      _recurrenceType = 'none';
    }

    // Status options
    final options = widget.details.statusOptions;
    _statusRows = options
        .map((o) => _EditStatusRow(statusKey: o.statusKey, label: o.label))
        .toList();
    _defaultStatusIndex = options.indexWhere((o) => o.isDefault);
    if (_defaultStatusIndex < 0) _defaultStatusIndex = 0;
  }

  @override
  void dispose() {
    _activityCtrl.dispose();
    _locationCtrl.dispose();
    _detailsCtrl.dispose();
    for (final r in _statusRows) {
      r.dispose();
    }
    super.dispose();
  }

  String _weekdayCode(int day) {
    const codes = {
      DateTime.monday: 'MO',
      DateTime.tuesday: 'TU',
      DateTime.wednesday: 'WE',
      DateTime.thursday: 'TH',
      DateTime.friday: 'FR',
      DateTime.saturday: 'SA',
      DateTime.sunday: 'SU',
    };
    return codes[day] ?? 'MO';
  }

  String _formatDateTime(DateTime utc) {
    final l = utc.toLocal();
    final m = l.month.toString().padLeft(2, '0');
    final d = l.day.toString().padLeft(2, '0');
    final h = l.hour.toString().padLeft(2, '0');
    final min = l.minute.toString().padLeft(2, '0');
    return '${l.year}-$m-$d $h:$min';
  }

  Future<void> _pickStartsAt() async {
    final now = DateTime.now();
    final local = _startsAtUtc.toLocal();
    final date = await showDatePicker(
      context: context,
      initialDate: local,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(local),
    );
    if (time == null || !mounted) return;
    setState(() {
      _startsAtUtc = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ).toUtc();
    });
  }

  List<HonkStatusOption>? _buildStatusOptions() {
    if (_statusRows.length < 2) return null;
    final options = <HonkStatusOption>[];
    for (int i = 0; i < _statusRows.length; i++) {
      final key = _statusRows[i].statusKeyCtrl.text.trim();
      final label = _statusRows[i].labelCtrl.text.trim();
      if (key.isEmpty || label.isEmpty) return null;
      if (!RegExp(r'^[a-z0-9_]+$').hasMatch(key)) return null;
      options.add(
        HonkStatusOption(
          statusKey: key,
          label: label,
          sortOrder: i,
          isDefault: i == _defaultStatusIndex,
          isActive: true,
        ),
      );
    }
    if (options.map((o) => o.statusKey).toSet().length != options.length) {
      return null;
    }
    return options;
  }

  String? _buildRecurrenceRrule() {
    switch (_recurrenceType) {
      case 'daily':
        return 'FREQ=DAILY';
      case 'weekly':
        final days = _weeklyDays.isEmpty
            ? {_startsAtUtc.toLocal().weekday}
            : _weeklyDays;
        final byDay = days.map(_weekdayCode).join(',');
        return 'FREQ=WEEKLY;BYDAY=$byDay';
      default:
        return null;
    }
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) return;
    final opts = _buildStatusOptions();
    if (opts == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Check status options.')));
      return;
    }
    Navigator.of(context).pop();
    context.read<HonkDetailsCubit>().updateActivity(
      activityId: widget.activityId,
      activity: _activityCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      details: _detailsCtrl.text.trim().isEmpty
          ? null
          : _detailsCtrl.text.trim(),
      startsAt: _startsAtUtc,
      recurrenceRrule: _buildRecurrenceRrule(),
      recurrenceTimezone: widget.details.activity.recurrenceTimezone,
      statusResetSeconds: _statusResetSeconds,
      statusOptions: opts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Honk'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _activityCtrl,
              decoration: const InputDecoration(labelText: 'Activity *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _locationCtrl,
              decoration: const InputDecoration(labelText: 'Location *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            TextFormField(
              controller: _detailsCtrl,
              decoration: const InputDecoration(
                labelText: 'Details (optional)',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Starts at'),
              subtitle: Text(_formatDateTime(_startsAtUtc)),
              trailing: TextButton(
                onPressed: _pickStartsAt,
                child: const Text('Change'),
              ),
            ),
            DropdownButtonFormField<String>(
              initialValue: _recurrenceType,
              decoration: const InputDecoration(labelText: 'Recurrence'),
              items: const [
                DropdownMenuItem(value: 'none', child: Text('One-time')),
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
              ],
              onChanged: (v) {
                if (v != null) setState(() => _recurrenceType = v);
              },
            ),
            if (_recurrenceType == 'weekly') ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: List.generate(7, (i) {
                  final wd = i + 1;
                  return FilterChip(
                    label: Text(_weekdayCode(wd)),
                    selected: _weeklyDays.contains(wd),
                    onSelected: (s) => setState(() {
                      if (s) {
                        _weeklyDays.add(wd);
                      } else {
                        _weeklyDays.remove(wd);
                      }
                    }),
                  );
                }),
              ),
            ],
            DropdownButtonFormField<int>(
              initialValue: _statusResetSeconds,
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
                if (v != null) setState(() => _statusResetSeconds = v);
              },
            ),
            const SizedBox(height: 12),
            ...List.generate(_statusRows.length, (i) {
              final row = _statusRows[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _defaultStatusIndex = i),
                      icon: Icon(
                        i == _defaultStatusIndex
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: row.statusKeyCtrl,
                        decoration: const InputDecoration(labelText: 'Key'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: row.labelCtrl,
                        decoration: const InputDecoration(labelText: 'Label'),
                      ),
                    ),
                    IconButton(
                      onPressed: _statusRows.length <= 2
                          ? null
                          : () {
                              setState(() {
                                _statusRows.removeAt(i).dispose();
                                if (_defaultStatusIndex >= _statusRows.length) {
                                  _defaultStatusIndex = _statusRows.length - 1;
                                }
                              });
                            },
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _save, child: const Text('Save')),
      ],
    );
  }
}

class _EditStatusRow {
  _EditStatusRow({required String statusKey, required String label})
    : statusKeyCtrl = TextEditingController(text: statusKey),
      labelCtrl = TextEditingController(text: label);

  final TextEditingController statusKeyCtrl;
  final TextEditingController labelCtrl;

  void dispose() {
    statusKeyCtrl.dispose();
    labelCtrl.dispose();
  }
}

// ── Copyable row ──────────────────────────────────────────────────────────────

class _CopyableRow extends StatelessWidget {
  const _CopyableRow({required this.label, required this.value});

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
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
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
