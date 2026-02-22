import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../domain/entities/honk_status_option.dart';
import '../cubit/create_honk_cubit.dart';

class CreateHonkPage extends StatefulWidget {
  const CreateHonkPage({super.key});

  @override
  State<CreateHonkPage> createState() => _CreateHonkPageState();
}

class _CreateHonkPageState extends State<CreateHonkPage> {
  final _formKey = GlobalKey<FormState>();
  final _activityController = TextEditingController();
  final _locationController = TextEditingController();
  final _detailsController = TextEditingController();

  // Timezone-aware start time: pick in local, store as UTC.
  late DateTime _startsAtUtc;
  String _recurrenceType = 'none';
  final Set<int> _weeklyDays = {};
  int _statusResetSeconds = 1800;

  final List<_StatusOptionRow> _statusRows = [
    _StatusOptionRow(statusKey: 'going', label: 'Going'),
    _StatusOptionRow(statusKey: 'maybe', label: 'Maybe'),
    _StatusOptionRow(statusKey: 'not_going', label: 'Not Going'),
  ];
  int _defaultStatusIndex = 0;

  final Set<String> _selectedParticipantIds = {};

  @override
  void initState() {
    super.initState();
    _startsAtUtc = DateTime.now().toUtc().add(const Duration(minutes: 15));
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

  String get _deviceTimezone => DateTime.now().timeZoneName;

  Future<void> _pickStartsAt() async {
    final now = DateTime.now();
    final currentLocal = _startsAtUtc.toLocal();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentLocal,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(currentLocal),
    );
    if (pickedTime == null || !mounted) return;

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

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;

    final statusOptions = _buildStatusOptions();
    if (statusOptions == null) return;

    final recurrenceRrule = _buildRecurrenceRrule();

    context.read<CreateHonkCubit>().createActivity(
      activity: _activityController.text.trim(),
      location: _locationController.text.trim(),
      details: _detailsController.text.trim().isEmpty
          ? null
          : _detailsController.text.trim(),
      startsAt: _startsAtUtc,
      recurrenceRrule: recurrenceRrule,
      recurrenceTimezone: _deviceTimezone,
      statusResetSeconds: _statusResetSeconds,
      statusOptions: statusOptions,
      participantIds: _selectedParticipantIds.toList(growable: false),
    );
  }

  List<HonkStatusOption>? _buildStatusOptions() {
    if (_statusRows.length < 2) {
      _showMessage('At least two status options are required.');
      return null;
    }

    final options = <HonkStatusOption>[];
    for (int i = 0; i < _statusRows.length; i++) {
      final key = _statusRows[i].statusKeyController.text.trim();
      final label = _statusRows[i].labelController.text.trim();

      if (key.isEmpty || label.isEmpty) {
        _showMessage('Status key and label cannot be empty.');
        return null;
      }
      if (!RegExp(r'^[a-z0-9_]+$').hasMatch(key)) {
        _showMessage('Invalid status key "$key". Use lowercase snake_case.');
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

    if (options.map((o) => o.statusKey).toSet().length != options.length) {
      _showMessage('Status keys must be unique.');
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
    final local = utc.toLocal();
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$m-$d $h:$min ($_deviceTimezone)';
  }

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String? _validateRequired(String? v, {required String fieldName}) {
    if (v == null || v.trim().isEmpty) return '$fieldName is required.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateHonkCubit, CreateHonkState>(
      listener: (context, state) {
        if (state.createdActivity != null) {
          final activity = state.createdActivity!;
          context.read<CreateHonkCubit>().resetSubmission();
          // Navigate to the new honk's details page.
          HonkDetailsRoute(activityId: activity.id).go(context);
        }
        if (state.submissionFailure != null) {
          _showMessage(state.submissionFailure.toString());
          context.read<CreateHonkCubit>().resetSubmission();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('New Honk')),
        body: BlocBuilder<CreateHonkCubit, CreateHonkState>(
          builder: (context, state) {
            final isSubmitting = state.isSubmitting;
            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // ── Activity & Location ──────────────────────────────────
                  TextFormField(
                    controller: _activityController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Activity *',
                      hintText: 'e.g. Morning run',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        _validateRequired(v, fieldName: 'Activity'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _locationController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Location *',
                      hintText: 'e.g. Central Park',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        _validateRequired(v, fieldName: 'Location'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _detailsController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Details (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  // ── Start time ───────────────────────────────────────────
                  _SectionTitle('Start time'),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.schedule_outlined),
                    title: Text(_formatDateTime(_startsAtUtc)),
                    trailing: TextButton(
                      onPressed: isSubmitting ? null : _pickStartsAt,
                      child: const Text('Change'),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Recurrence ───────────────────────────────────────────
                  _SectionTitle('Recurrence'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _recurrenceType,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'none', child: Text('One-time')),
                      DropdownMenuItem(value: 'daily', child: Text('Daily')),
                      DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    ],
                    onChanged: isSubmitting
                        ? null
                        : (v) {
                            if (v == null) return;
                            setState(() => _recurrenceType = v);
                          },
                  ),
                  if (_recurrenceType == 'weekly') ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: List.generate(7, (i) {
                        final weekday = i + 1;
                        return FilterChip(
                          label: Text(
                            _weekdayCode(weekday),
                            style: const TextStyle(fontSize: 12),
                          ),
                          selected: _weeklyDays.contains(weekday),
                          onSelected: isSubmitting
                              ? null
                              : (selected) {
                                  setState(() {
                                    if (selected) {
                                      _weeklyDays.add(weekday);
                                    } else {
                                      _weeklyDays.remove(weekday);
                                    }
                                  });
                                },
                        );
                      }),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // ── Status reset ─────────────────────────────────────────
                  _SectionTitle('Status resets after'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    initialValue: _statusResetSeconds,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 600, child: Text('10 minutes')),
                      DropdownMenuItem(value: 1800, child: Text('30 minutes')),
                      DropdownMenuItem(value: 3600, child: Text('1 hour')),
                      DropdownMenuItem(value: 7200, child: Text('2 hours')),
                    ],
                    onChanged: isSubmitting
                        ? null
                        : (v) {
                            if (v == null) return;
                            setState(() => _statusResetSeconds = v);
                          },
                  ),
                  const SizedBox(height: 16),

                  // ── Status options ───────────────────────────────────────
                  _buildStatusEditor(isSubmitting: isSubmitting),
                  const SizedBox(height: 16),

                  // ── Participants ─────────────────────────────────────────
                  _buildParticipantPicker(
                    state: state,
                    isSubmitting: isSubmitting,
                  ),
                  const SizedBox(height: 24),

                  // ── Submit ───────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: isSubmitting ? null : _submit,
                      icon: isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.campaign_rounded),
                      label: const Text('Create Honk'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusEditor({required bool isSubmitting}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionTitle('Status options'),
            TextButton.icon(
              onPressed: isSubmitting || _statusRows.length >= 8
                  ? null
                  : () {
                      setState(() {
                        _statusRows.add(
                          _StatusOptionRow(
                            statusKey: 'status_${_statusRows.length + 1}',
                            label: 'Status ${_statusRows.length + 1}',
                          ),
                        );
                      });
                    },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Tap the circle to set the default status.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 8),
        ...List.generate(_statusRows.length, (i) {
          final row = _statusRows[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: i == _defaultStatusIndex
                      ? 'Default'
                      : 'Set as default',
                  onPressed: isSubmitting
                      ? null
                      : () => setState(() => _defaultStatusIndex = i),
                  icon: Icon(
                    i == _defaultStatusIndex
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: row.statusKeyController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Key',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: row.labelController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(
                      labelText: 'Label',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Remove',
                  onPressed: isSubmitting || _statusRows.length <= 2
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
    );
  }

  Widget _buildParticipantPicker({
    required CreateHonkState state,
    required bool isSubmitting,
  }) {
    if (state.isLoadingParticipants) {
      return const Row(
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Loading friends…'),
        ],
      );
    }

    final candidates = state.eligibleParticipants;
    if (candidates.isEmpty) {
      return const Text(
        'No accepted friends to pre-invite. Share the invite code after creating.',
        style: TextStyle(fontSize: 12),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Invite friends (optional)'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: candidates.map((c) {
            final selected = _selectedParticipantIds.contains(c.id);
            return FilterChip(
              label: Text(c.username),
              selected: selected,
              onSelected: isSubmitting
                  ? null
                  : (v) {
                      setState(() {
                        if (v) {
                          _selectedParticipantIds.add(c.id);
                        } else {
                          _selectedParticipantIds.remove(c.id);
                        }
                      });
                    },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
    );
  }
}

class _StatusOptionRow {
  _StatusOptionRow({required String statusKey, required String label})
    : statusKeyController = TextEditingController(text: statusKey),
      labelController = TextEditingController(text: label);

  final TextEditingController statusKeyController;
  final TextEditingController labelController;

  void dispose() {
    statusKeyController.dispose();
    labelController.dispose();
  }
}
