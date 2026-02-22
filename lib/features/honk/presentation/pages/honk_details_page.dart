import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart' show Either;

import '../../../../core/deep_link/deep_link_handler.dart';
import '../../../../core/domain/main_failure.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/honk_activity.dart';
import '../../domain/entities/honk_activity_details.dart';
import '../../domain/entities/honk_status_option.dart';
import '../../domain/repositories/i_honk_repository.dart';

class HonkDetailsPage extends StatefulWidget {
  const HonkDetailsPage({
    required this.activityId,
    required this.honkRepository,
    super.key,
  });

  final String activityId;
  final IHonkRepository honkRepository;

  @override
  State<HonkDetailsPage> createState() => _HonkDetailsPageState();
}

class _HonkDetailsPageState extends State<HonkDetailsPage> {
  late Stream<Either<MainFailure, HonkActivityDetails>> _detailsStream;
  Timer? _ticker;
  DateTime _nowUtc = DateTime.now().toUtc();
  String? _statusSubmittingKey;
  bool _isDeleting = false;
  bool _isLeaving = false;
  bool _isRotatingInvite = false;
  bool _isUpdatingActivity = false;

  @override
  void initState() {
    super.initState();
    _detailsStream = widget.honkRepository.watchActivityDetails(
      activityId: widget.activityId,
    );
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _nowUtc = DateTime.now().toUtc();
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _detailsStream = widget.honkRepository.watchActivityDetails(
        activityId: widget.activityId,
      );
    });
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return result == true;
  }

  Future<void> _deleteActivity(String activityId) async {
    final shouldDelete = await _confirm(
      title: 'Delete Activity?',
      message: 'This removes the activity for all participants.',
      confirmLabel: 'Delete',
    );
    if (!shouldDelete || !mounted) {
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    final result = await widget.honkRepository
        .deleteActivity(activityId: activityId)
        .run();
    if (!mounted) {
      return;
    }

    setState(() {
      _isDeleting = false;
    });

    result.match((failure) => _showMessage(failure.toString()), (_) {
      _showMessage('Activity deleted.');
      const HomeRoute().go(context);
    });
  }

  Future<void> _leaveActivity(String activityId) async {
    final shouldLeave = await _confirm(
      title: 'Leave Activity?',
      message: 'You can rejoin later using the invite code.',
      confirmLabel: 'Leave',
    );
    if (!shouldLeave || !mounted) {
      return;
    }

    setState(() {
      _isLeaving = true;
    });

    final result = await widget.honkRepository
        .leaveActivity(activityId: activityId)
        .run();
    if (!mounted) {
      return;
    }

    setState(() {
      _isLeaving = false;
    });

    result.match((failure) => _showMessage(failure.toString()), (_) {
      _showMessage('You left the activity.');
      const HomeRoute().go(context);
    });
  }

  Future<void> _rotateInvite(String activityId) async {
    setState(() {
      _isRotatingInvite = true;
    });

    final result = await widget.honkRepository
        .rotateInvite(activityId: activityId)
        .run();
    if (!mounted) {
      return;
    }

    setState(() {
      _isRotatingInvite = false;
    });

    result.match((failure) => _showMessage(failure.toString()), (inviteCode) {
      _showMessage('Invite rotated. New code: $inviteCode');
    });
  }

  Future<void> _setStatus({
    required String activityId,
    required DateTime occurrenceStart,
    required String statusKey,
  }) async {
    setState(() {
      _statusSubmittingKey = statusKey;
    });

    final result = await widget.honkRepository
        .setParticipantStatus(
          activityId: activityId,
          occurrenceStart: occurrenceStart,
          statusKey: statusKey,
        )
        .run();
    if (!mounted) {
      return;
    }

    setState(() {
      _statusSubmittingKey = null;
    });

    result.match(
      (failure) => _showMessage(failure.toString()),
      (_) => _showMessage('Status updated.'),
    );
  }

  Future<void> _editActivity(HonkActivityDetails details) async {
    final input = await showDialog<_EditActivityInput>(
      context: context,
      builder: (dialogContext) => _EditActivityDialog(
        activity: details.activity,
        statusOptions: details.statusOptions,
      ),
    );
    if (input == null || !mounted) {
      return;
    }

    setState(() {
      _isUpdatingActivity = true;
    });

    final result = await widget.honkRepository
        .updateActivity(
          activityId: details.activity.id,
          activity: input.activity,
          location: input.location,
          details: input.details,
          startsAt: input.startsAtUtc,
          recurrenceRrule: input.recurrenceRrule,
          recurrenceTimezone: details.activity.recurrenceTimezone,
          statusResetSeconds: input.statusResetSeconds,
          statusOptions: input.statusOptions,
        )
        .run();

    if (!mounted) {
      return;
    }

    setState(() {
      _isUpdatingActivity = false;
    });

    result.match(
      (failure) => _showMessage(failure.toString()),
      (_) => _showMessage('Activity updated.'),
    );
  }

  Future<void> _shareInvite(HonkActivity activity) async {
    final inviteCode = activity.inviteCode.trim();
    final inviteLink = '${DeepLinkConfig.scheme}://join?code=$inviteCode';

    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share Invite',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SelectableText('Code: $inviteCode'),
                const SizedBox(height: 4),
                SelectableText('Link: $inviteLink'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: inviteCode),
                        );
                        if (sheetContext.mounted) {
                          Navigator.of(sheetContext).pop();
                        }
                        _showMessage('Invite code copied.');
                      },
                      icon: const Icon(Icons.key_outlined),
                      label: const Text('Copy Code'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: inviteLink),
                        );
                        if (sheetContext.mounted) {
                          Navigator.of(sheetContext).pop();
                        }
                        _showMessage('Invite link copied.');
                      },
                      icon: const Icon(Icons.link),
                      label: const Text('Copy Link'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity Details')),
      body: StreamBuilder<Either<MainFailure, HonkActivityDetails>>(
        stream: _detailsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = snapshot.data;
          if (result == null) {
            return _ErrorView(
              message: 'Unable to load this activity right now.',
              onRetry: _retry,
            );
          }

          return result.match(
            (failure) =>
                _ErrorView(message: failure.toString(), onRetry: _retry),
            (details) => _ActivityDetailsView(
              details: details,
              nowUtc: _nowUtc,
              statusSubmittingKey: _statusSubmittingKey,
              isDeleting: _isDeleting,
              isLeaving: _isLeaving,
              isRotatingInvite: _isRotatingInvite,
              isUpdatingActivity: _isUpdatingActivity,
              onRefresh: _retry,
              onShareInvite: () => _shareInvite(details.activity),
              onRotateInvite: details.isCreator
                  ? () => _rotateInvite(details.activity.id)
                  : null,
              onEditActivity: details.isCreator
                  ? () => _editActivity(details)
                  : null,
              onDeleteActivity: details.isCreator
                  ? () => _deleteActivity(details.activity.id)
                  : null,
              onLeaveActivity: details.isCreator
                  ? null
                  : () => _leaveActivity(details.activity.id),
              onSetStatus: (statusKey) => _setStatus(
                activityId: details.activity.id,
                occurrenceStart: details.occurrenceStart,
                statusKey: statusKey,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ActivityDetailsView extends StatelessWidget {
  const _ActivityDetailsView({
    required this.details,
    required this.nowUtc,
    required this.statusSubmittingKey,
    required this.isDeleting,
    required this.isLeaving,
    required this.isRotatingInvite,
    required this.isUpdatingActivity,
    required this.onRefresh,
    required this.onShareInvite,
    required this.onRotateInvite,
    required this.onEditActivity,
    required this.onDeleteActivity,
    required this.onLeaveActivity,
    required this.onSetStatus,
  });

  final HonkActivityDetails details;
  final DateTime nowUtc;
  final String? statusSubmittingKey;
  final bool isDeleting;
  final bool isLeaving;
  final bool isRotatingInvite;
  final bool isUpdatingActivity;
  final VoidCallback onRefresh;
  final VoidCallback onShareInvite;
  final VoidCallback? onRotateInvite;
  final VoidCallback? onEditActivity;
  final VoidCallback? onDeleteActivity;
  final VoidCallback? onLeaveActivity;
  final ValueChanged<String> onSetStatus;

  @override
  Widget build(BuildContext context) {
    final activity = details.activity;
    final statusOptions = details.statusOptions.isNotEmpty
        ? details.statusOptions
        : const [
            HonkStatusOption(
              statusKey: 'default',
              label: 'Default',
              sortOrder: 0,
              isDefault: true,
              isActive: true,
            ),
          ];
    final defaultStatus = statusOptions.firstWhere(
      (option) => option.isDefault,
      orElse: () => statusOptions.first,
    );
    final statusLabelByKey = <String, String>{
      for (final option in statusOptions) option.statusKey: option.label,
    };

    final sortedParticipants = [...details.participants]
      ..sort((a, b) {
        if (a.isCreator && !b.isCreator) {
          return -1;
        }
        if (!a.isCreator && b.isCreator) {
          return 1;
        }
        return a.username.compareTo(b.username);
      });

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.activity,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    activity.location,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    label: 'Starts',
                    value: _formatDateTime(activity.startsAt),
                  ),
                  _DetailRow(
                    label: 'Occurrence',
                    value: _formatDateTime(details.occurrenceStart),
                  ),
                  _DetailRow(
                    label: 'Recurrence',
                    value: _formatRecurrence(activity.recurrenceRrule),
                  ),
                  _DetailRow(
                    label: 'Reset TTL',
                    value: _formatDurationLabel(activity.statusResetSeconds),
                  ),
                  _DetailRow(label: 'Invite', value: activity.inviteCode),
                  if (activity.details != null && activity.details!.isNotEmpty)
                    _DetailRow(label: 'Details', value: activity.details!),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: onShareInvite,
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share Invite'),
              ),
              if (onEditActivity != null)
                FilledButton.tonalIcon(
                  onPressed: isUpdatingActivity ? null : onEditActivity,
                  icon: isUpdatingActivity
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.edit_outlined),
                  label: const Text('Edit'),
                ),
              if (onRotateInvite != null)
                FilledButton.tonalIcon(
                  onPressed: isRotatingInvite ? null : onRotateInvite,
                  icon: isRotatingInvite
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  label: const Text('Rotate Invite'),
                ),
              if (onLeaveActivity != null)
                OutlinedButton.icon(
                  onPressed: isLeaving ? null : onLeaveActivity,
                  icon: isLeaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.exit_to_app),
                  label: const Text('Leave'),
                ),
              if (onDeleteActivity != null)
                OutlinedButton.icon(
                  onPressed: isDeleting ? null : onDeleteActivity,
                  icon: isDeleting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Your Status', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: statusOptions
                .where((option) => option.isActive)
                .map((option) {
                  final currentStatus =
                      details.currentUserParticipant?.effectiveStatusKey;
                  final isSelected = currentStatus == option.statusKey;
                  final isLoading = statusSubmittingKey == option.statusKey;
                  return ChoiceChip(
                    selected: isSelected,
                    onSelected: isLoading
                        ? null
                        : (_) => onSetStatus(option.statusKey),
                    label: isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(option.label),
                            ],
                          )
                        : Text(option.label),
                  );
                })
                .toList(growable: false),
          ),
          const SizedBox(height: 16),
          Text(
            'Participants (${sortedParticipants.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          ...sortedParticipants.map((participant) {
            final isDefault =
                participant.effectiveStatusKey == defaultStatus.statusKey;
            final statusLabel =
                statusLabelByKey[participant.effectiveStatusKey] ??
                participant.effectiveStatusKey;
            final expiry = participant.statusExpiresAt;
            final showCountdown =
                !isDefault && expiry != null && expiry.isAfter(nowUtc);
            final subtitleText = showCountdown
                ? '$statusLabel • resets in ${_formatCountdown(expiry, nowUtc)}'
                : statusLabel;

            return Card(
              child: ListTile(
                leading: Icon(
                  participant.isCreator
                      ? Icons.admin_panel_settings_outlined
                      : Icons.person_outline,
                ),
                title: Text(
                  participant.userId == details.currentUserId
                      ? '${participant.username} (You)'
                      : participant.username,
                ),
                subtitle: Text(subtitleText),
                trailing: participant.isCreator
                    ? const Text(
                        'Creator',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$month-$day $hour:$minute';
  }

  String _formatRecurrence(String? recurrenceRrule) {
    final rule = recurrenceRrule?.trim();
    if (rule == null || rule.isEmpty) {
      return 'One-time';
    }
    return rule;
  }

  String _formatCountdown(DateTime expiresAtUtc, DateTime nowUtc) {
    final remaining = expiresAtUtc.difference(nowUtc);
    if (remaining.isNegative) {
      return 'now';
    }

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  String _formatDurationLabel(int seconds) {
    if (seconds < 60) {
      return '${seconds}s';
    }
    if (seconds < 3600) {
      return '${seconds ~/ 60}m';
    }
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (minutes == 0) {
      return '${hours}h';
    }
    return '${hours}h ${minutes}m';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 88,
            child: Text(
              '$label:',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
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
            const SizedBox(height: 12),
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

class _EditActivityInput {
  const _EditActivityInput({
    required this.activity,
    required this.location,
    required this.details,
    required this.startsAtUtc,
    required this.recurrenceRrule,
    required this.statusResetSeconds,
    required this.statusOptions,
  });

  final String activity;
  final String location;
  final String? details;
  final DateTime startsAtUtc;
  final String? recurrenceRrule;
  final int statusResetSeconds;
  final List<HonkStatusOption> statusOptions;
}

class _StatusOptionEditorRow {
  _StatusOptionEditorRow({required String statusKey, required String label})
    : statusKeyController = TextEditingController(text: statusKey),
      labelController = TextEditingController(text: label);

  final TextEditingController statusKeyController;
  final TextEditingController labelController;

  void dispose() {
    statusKeyController.dispose();
    labelController.dispose();
  }
}

class _EditActivityDialog extends StatefulWidget {
  const _EditActivityDialog({
    required this.activity,
    required this.statusOptions,
  });

  final HonkActivity activity;
  final List<HonkStatusOption> statusOptions;

  @override
  State<_EditActivityDialog> createState() => _EditActivityDialogState();
}

class _EditActivityDialogState extends State<_EditActivityDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _activityController;
  late final TextEditingController _locationController;
  late final TextEditingController _detailsController;

  late DateTime _startsAtUtc;
  late String _recurrenceType;
  late Set<int> _weeklyDays;
  late int _statusResetSeconds;
  late List<_StatusOptionEditorRow> _statusRows;
  late int _defaultStatusIndex;

  @override
  void initState() {
    super.initState();
    _activityController = TextEditingController(text: widget.activity.activity);
    _locationController = TextEditingController(text: widget.activity.location);
    _detailsController = TextEditingController(
      text: widget.activity.details ?? '',
    );
    _startsAtUtc = widget.activity.startsAt;
    _statusResetSeconds = widget.activity.statusResetSeconds;

    final recurrence = widget.activity.recurrenceRrule?.toUpperCase() ?? '';
    if (recurrence.contains('FREQ=DAILY')) {
      _recurrenceType = 'daily';
    } else if (recurrence.contains('FREQ=WEEKLY')) {
      _recurrenceType = 'weekly';
    } else {
      _recurrenceType = 'none';
    }
    _weeklyDays = _parseWeeklyDays(widget.activity.recurrenceRrule);

    _statusRows = widget.statusOptions
        .where((option) => option.isActive)
        .map(
          (option) => _StatusOptionEditorRow(
            statusKey: option.statusKey,
            label: option.label,
          ),
        )
        .toList(growable: true);
    if (_statusRows.isEmpty) {
      _statusRows = [
        _StatusOptionEditorRow(statusKey: 'going', label: 'Going'),
        _StatusOptionEditorRow(statusKey: 'maybe', label: 'Maybe'),
      ];
    }
    _defaultStatusIndex = widget.statusOptions.indexWhere((o) => o.isDefault);
    if (_defaultStatusIndex < 0 || _defaultStatusIndex >= _statusRows.length) {
      _defaultStatusIndex = 0;
    }
  }

  @override
  void dispose() {
    _activityController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    for (final row in _statusRows) {
      row.dispose();
    }
    super.dispose();
  }

  Set<int> _parseWeeklyDays(String? rrule) {
    final normalized = rrule?.toUpperCase() ?? '';
    final byDayIndex = normalized.indexOf('BYDAY=');
    if (byDayIndex < 0) {
      return <int>{};
    }

    final rawByDay = normalized.substring(byDayIndex + 6);
    final stopIndex = rawByDay.indexOf(';');
    final byDayPart = stopIndex >= 0
        ? rawByDay.substring(0, stopIndex)
        : rawByDay;
    final days = <int>{};
    for (final code in byDayPart.split(',')) {
      switch (code.trim()) {
        case 'MO':
          days.add(DateTime.monday);
          break;
        case 'TU':
          days.add(DateTime.tuesday);
          break;
        case 'WE':
          days.add(DateTime.wednesday);
          break;
        case 'TH':
          days.add(DateTime.thursday);
          break;
        case 'FR':
          days.add(DateTime.friday);
          break;
        case 'SA':
          days.add(DateTime.saturday);
          break;
        case 'SU':
          days.add(DateTime.sunday);
          break;
      }
    }
    return days;
  }

  Future<void> _pickStartsAt() async {
    final now = DateTime.now();
    final currentLocal = _startsAtUtc.toLocal();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentLocal,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 730)),
    );
    if (pickedDate == null || !mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentLocal),
    );
    if (pickedTime == null || !mounted) {
      return;
    }

    setState(() {
      _startsAtUtc = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      ).toUtc();
    });
  }

  String _weekdayCode(int day) {
    switch (day) {
      case DateTime.monday:
        return 'MO';
      case DateTime.tuesday:
        return 'TU';
      case DateTime.wednesday:
        return 'WE';
      case DateTime.thursday:
        return 'TH';
      case DateTime.friday:
        return 'FR';
      case DateTime.saturday:
        return 'SA';
      case DateTime.sunday:
        return 'SU';
      default:
        return 'MO';
    }
  }

  String? _buildRecurrenceRrule() {
    if (_recurrenceType == 'none') {
      return null;
    }
    if (_recurrenceType == 'daily') {
      return 'FREQ=DAILY';
    }
    final days = _weeklyDays.isEmpty
        ? <int>{_startsAtUtc.toLocal().weekday}
        : _weeklyDays;
    final byDay = days.map(_weekdayCode).join(',');
    return 'FREQ=WEEKLY;BYDAY=$byDay';
  }

  List<HonkStatusOption>? _buildStatusOptions() {
    if (_statusRows.length < 2 || _statusRows.length > 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Status options must be between 2 and 8 entries.'),
        ),
      );
      return null;
    }

    final options = <HonkStatusOption>[];
    for (int i = 0; i < _statusRows.length; i++) {
      final key = _statusRows[i].statusKeyController.text.trim();
      final label = _statusRows[i].labelController.text.trim();
      if (key.isEmpty || label.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Status key and label are required for each option.'),
          ),
        );
        return null;
      }
      if (!RegExp(r'^[a-z0-9_]+$').hasMatch(key)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid status key "$key". Use snake_case.')),
        );
        return null;
      }

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

    final uniqueKeys = options.map((option) => option.statusKey).toSet();
    if (uniqueKeys.length != options.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status keys must be unique.')),
      );
      return null;
    }
    return options;
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final statusOptions = _buildStatusOptions();
    if (statusOptions == null) {
      return;
    }

    Navigator.of(context).pop(
      _EditActivityInput(
        activity: _activityController.text.trim(),
        location: _locationController.text.trim(),
        details: _detailsController.text.trim().isEmpty
            ? null
            : _detailsController.text.trim(),
        startsAtUtc: _startsAtUtc,
        recurrenceRrule: _buildRecurrenceRrule(),
        statusResetSeconds: _statusResetSeconds,
        statusOptions: statusOptions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Activity'),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _activityController,
                  decoration: const InputDecoration(labelText: 'Activity'),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _detailsController,
                  decoration: const InputDecoration(labelText: 'Details'),
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
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _recurrenceType,
                  decoration: const InputDecoration(labelText: 'Recurrence'),
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('One-time')),
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _recurrenceType = value;
                    });
                  },
                ),
                if (_recurrenceType == 'weekly') ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: List.generate(7, (index) {
                      final day = index + 1;
                      final selected = _weeklyDays.contains(day);
                      return FilterChip(
                        selected: selected,
                        label: Text(_weekdayCode(day)),
                        onSelected: (value) {
                          setState(() {
                            if (value) {
                              _weeklyDays.add(day);
                            } else {
                              _weeklyDays.remove(day);
                            }
                          });
                        },
                      );
                    }),
                  ),
                ],
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: _statusResetSeconds,
                  decoration: const InputDecoration(
                    labelText: 'Status reset window',
                  ),
                  items: const [
                    DropdownMenuItem(value: 600, child: Text('10 minutes')),
                    DropdownMenuItem(value: 1800, child: Text('30 minutes')),
                    DropdownMenuItem(value: 3600, child: Text('1 hour')),
                    DropdownMenuItem(value: 7200, child: Text('2 hours')),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _statusResetSeconds = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Text(
                  'Status Options',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                ...List.generate(_statusRows.length, (index) {
                  final row = _statusRows[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: 'Set default',
                          onPressed: () {
                            setState(() {
                              _defaultStatusIndex = index;
                            });
                          },
                          icon: Icon(
                            index == _defaultStatusIndex
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: row.statusKeyController,
                            decoration: const InputDecoration(labelText: 'Key'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: row.labelController,
                            decoration: const InputDecoration(
                              labelText: 'Label',
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _statusRows.length <= 2
                              ? null
                              : () {
                                  setState(() {
                                    _statusRows.removeAt(index).dispose();
                                    if (_defaultStatusIndex >=
                                        _statusRows.length) {
                                      _defaultStatusIndex =
                                          _statusRows.length - 1;
                                    }
                                  });
                                },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: _statusRows.length >= 8
                      ? null
                      : () {
                          setState(() {
                            final suffix = _statusRows.length + 1;
                            _statusRows.add(
                              _StatusOptionEditorRow(
                                statusKey: 'status_$suffix',
                                label: 'Status $suffix',
                              ),
                            );
                          });
                        },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Status Option'),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Save')),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$month-$day $hour:$minute';
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required.';
    }
    return null;
  }
}
