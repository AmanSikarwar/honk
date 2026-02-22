import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/entities/honk_activity_summary.dart';
import '../../domain/entities/honk_participant_candidate.dart';
import '../../domain/entities/honk_status_option.dart';
import '../../domain/repositories/i_honk_repository.dart';
import '../bloc/honk_feed_bloc.dart';
import '../cubit/action_pad_cubit.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final _formKey = GlobalKey<FormState>();
  final _activityController = TextEditingController();
  final _locationController = TextEditingController();
  final _detailsController = TextEditingController();
  final _joinCodeController = TextEditingController();

  DateTime _startsAtUtc = DateTime.now().toUtc().add(
    const Duration(minutes: 15),
  );
  String _recurrenceType = 'none';
  final Set<int> _weeklyDays = {};
  int _statusResetSeconds = 1800;

  final List<_StatusOptionFormRow> _statusRows = [
    _StatusOptionFormRow(statusKey: 'going', label: 'Going'),
    _StatusOptionFormRow(statusKey: 'maybe', label: 'Maybe'),
    _StatusOptionFormRow(statusKey: 'not_going', label: 'Not Going'),
  ];
  int _defaultStatusIndex = 0;

  bool _loadingParticipants = false;
  List<HonkParticipantCandidate> _eligibleParticipants =
      const <HonkParticipantCandidate>[];
  final Set<String> _selectedParticipantIds = <String>{};

  IHonkRepository get _honkRepository => getIt<IHonkRepository>();

  @override
  void initState() {
    super.initState();
    _loadEligibleParticipants();
  }

  @override
  void dispose() {
    _activityController.dispose();
    _locationController.dispose();
    _detailsController.dispose();
    _joinCodeController.dispose();
    for (final row in _statusRows) {
      row.dispose();
    }
    super.dispose();
  }

  Future<void> _loadEligibleParticipants() async {
    setState(() {
      _loadingParticipants = true;
    });

    final result = await _honkRepository.fetchEligibleParticipants().run();
    if (!mounted) {
      return;
    }

    result.match(
      (failure) {
        setState(() {
          _loadingParticipants = false;
          _eligibleParticipants = const <HonkParticipantCandidate>[];
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.toString())));
      },
      (candidates) {
        setState(() {
          _loadingParticipants = false;
          _eligibleParticipants = candidates;
          _selectedParticipantIds.removeWhere(
            (id) => !candidates.any((candidate) => candidate.id == id),
          );
        });
      },
    );
  }

  Future<void> _pickStartsAt() async {
    final now = DateTime.now();
    final currentLocal = _startsAtUtc.toLocal();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentLocal,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
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

  Future<void> _joinByCode() async {
    final inviteCode = _joinCodeController.text.trim();
    if (inviteCode.isEmpty) {
      return;
    }

    final result = await _honkRepository
        .joinByInviteCode(inviteCode: inviteCode)
        .run();
    if (!mounted) {
      return;
    }

    result.match(
      (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(failure.toString())));
      },
      (activityId) {
        _joinCodeController.clear();
        HonkDetailsRoute(activityId: activityId).push(context);
      },
    );
  }

  void _submitCreate() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final statusOptions = _buildStatusOptions();
    if (statusOptions == null) {
      return;
    }

    final recurrenceRrule = _buildRecurrenceRrule();
    context.read<ActionPadCubit>().createActivity(
      activity: _activityController.text.trim(),
      location: _locationController.text.trim(),
      details: _detailsController.text.trim().isEmpty
          ? null
          : _detailsController.text.trim(),
      startsAt: _startsAtUtc,
      recurrenceTimezone: 'UTC',
      recurrenceRrule: recurrenceRrule,
      statusResetSeconds: _statusResetSeconds,
      statusOptions: statusOptions,
      participantIds: _selectedParticipantIds.toList(growable: false),
    );
  }

  List<HonkStatusOption>? _buildStatusOptions() {
    if (_statusRows.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least two status options are required.'),
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
            content: Text('Status key and label cannot be empty.'),
          ),
        );
        return null;
      }

      if (!RegExp(r'^[a-z0-9_]+$').hasMatch(key)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Invalid status key "$key". Use lowercase snake_case.',
            ),
          ),
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

  String? _buildRecurrenceRrule() {
    switch (_recurrenceType) {
      case 'daily':
        return 'FREQ=DAILY';
      case 'weekly':
        final days = _weeklyDays.isEmpty
            ? <int>{_startsAtUtc.toLocal().weekday}
            : _weeklyDays;
        final byDay = days.map(_weekdayCode).join(',');
        return 'FREQ=WEEKLY;BYDAY=$byDay';
      default:
        return null;
    }
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

  void _resetForm() {
    _activityController.clear();
    _locationController.clear();
    _detailsController.clear();
    _joinCodeController.clear();
    _selectedParticipantIds.clear();
    _recurrenceType = 'none';
    _weeklyDays.clear();
    _statusResetSeconds = 1800;
    _defaultStatusIndex = 0;
    _startsAtUtc = DateTime.now().toUtc().add(const Duration(minutes: 15));
    _statusRows
      ..clear()
      ..addAll([
        _StatusOptionFormRow(statusKey: 'going', label: 'Going'),
        _StatusOptionFormRow(statusKey: 'maybe', label: 'Maybe'),
        _StatusOptionFormRow(statusKey: 'not_going', label: 'Not Going'),
      ]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionPadCubit, ActionPadState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (activity) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Activity created: ${activity.activity}'),
                action: SnackBarAction(
                  label: 'VIEW',
                  onPressed: () =>
                      HonkDetailsRoute(activityId: activity.id).push(context),
                ),
              ),
            );
            _resetForm();
            context.read<ActionPadCubit>().reset();
          },
          failure: (failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(failure.toString())));
            context.read<ActionPadCubit>().reset();
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Honk Activity Groups'),
          actions: [
            IconButton(
              tooltip: 'Friends',
              onPressed: () => const FriendManagementRoute().go(context),
              icon: const Icon(Icons.group),
            ),
            IconButton(
              tooltip: 'Settings',
              onPressed: () => const SettingsRoute().go(context),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _loadEligibleParticipants,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildCreateSection(),
              const SizedBox(height: 16),
              _buildJoinSection(),
              const SizedBox(height: 16),
              _buildFeedSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateSection() {
    final actionState = context.watch<ActionPadCubit>().state;
    final isSubmitting = actionState.maybeWhen(
      submitting: () => true,
      orElse: () => false,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _activityController,
                enabled: !isSubmitting,
                decoration: const InputDecoration(labelText: 'Activity'),
                validator: (value) =>
                    _validateRequired(value, fieldName: 'Activity'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                enabled: !isSubmitting,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) =>
                    _validateRequired(value, fieldName: 'Location'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _detailsController,
                enabled: !isSubmitting,
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
                  onPressed: isSubmitting ? null : _pickStartsAt,
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
                onChanged: isSubmitting
                    ? null
                    : (value) {
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
                    final weekday = index + 1;
                    final selected = _weeklyDays.contains(weekday);
                    return FilterChip(
                      label: Text(_weekdayCode(weekday)),
                      selected: selected,
                      onSelected: isSubmitting
                          ? null
                          : (value) {
                              setState(() {
                                if (value) {
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
                onChanged: isSubmitting
                    ? null
                    : (value) {
                        if (value == null) {
                          return;
                        }
                        setState(() {
                          _statusResetSeconds = value;
                        });
                      },
              ),
              const SizedBox(height: 12),
              _buildStatusEditor(isSubmitting: isSubmitting),
              const SizedBox(height: 12),
              _buildParticipantsPicker(isSubmitting: isSubmitting),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: isSubmitting ? null : _submitCreate,
                  icon: isSubmitting
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add),
                  label: const Text('Create Activity'),
                ),
              ),
            ],
          ),
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
            Text(
              'Status Options',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: isSubmitting
                  ? null
                  : () {
                      setState(() {
                        _statusRows.add(
                          _StatusOptionFormRow(
                            statusKey: 'status_${_statusRows.length + 1}',
                            label: 'Status ${_statusRows.length + 1}',
                          ),
                        );
                      });
                    },
              icon: const Icon(Icons.add),
              label: const Text('Add'),
            ),
          ],
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
                  onPressed: isSubmitting
                      ? null
                      : () {
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
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(labelText: 'Key'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: row.labelController,
                    enabled: !isSubmitting,
                    decoration: const InputDecoration(labelText: 'Label'),
                  ),
                ),
                IconButton(
                  tooltip: 'Remove',
                  onPressed: isSubmitting || _statusRows.length <= 2
                      ? null
                      : () {
                          setState(() {
                            _statusRows.removeAt(index).dispose();
                            if (_defaultStatusIndex >= _statusRows.length) {
                              _defaultStatusIndex = _statusRows.length - 1;
                            }
                          });
                        },
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          );
        }),
        const Text('Select the default status using the circle toggle.'),
      ],
    );
  }

  Widget _buildParticipantsPicker({required bool isSubmitting}) {
    if (_loadingParticipants) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_eligibleParticipants.isEmpty) {
      return const Text('No accepted friends available for pre-invite.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Initial Participants (optional)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _eligibleParticipants
              .map((participant) {
                final selected = _selectedParticipantIds.contains(
                  participant.id,
                );
                return FilterChip(
                  label: Text(participant.username),
                  selected: selected,
                  onSelected: isSubmitting
                      ? null
                      : (value) {
                          setState(() {
                            if (value) {
                              _selectedParticipantIds.add(participant.id);
                            } else {
                              _selectedParticipantIds.remove(participant.id);
                            }
                          });
                        },
                );
              })
              .toList(growable: false),
        ),
      ],
    );
  }

  Widget _buildJoinSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join by Invite Code',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _joinCodeController,
              decoration: const InputDecoration(
                labelText: 'Invite code',
                hintText: 'Paste invite code',
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _joinByCode,
              icon: const Icon(Icons.login),
              label: const Text('Join Activity'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Activities',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            BlocBuilder<HonkFeedBloc, HonkFeedState>(
              builder: (context, state) {
                return state.when(
                  initial: SizedBox.new,
                  loadInProgress: () =>
                      const Center(child: CircularProgressIndicator()),
                  loadFailure: (failure) => Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(failure.toString()),
                  ),
                  loadSuccess: (activities) {
                    if (activities.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('No activity groups yet.'),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activities.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final activity = activities[index];
                        return ListTile(
                          title: Text(activity.activity),
                          subtitle: Text(
                            '${activity.location} • ${_formatSchedule(activity)}',
                          ),
                          trailing: Icon(
                            activity.isCreator
                                ? Icons.admin_panel_settings_outlined
                                : Icons.chevron_right,
                          ),
                          onTap: () => HonkDetailsRoute(
                            activityId: activity.id,
                          ).push(context),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatSchedule(HonkActivitySummary activity) {
    final startsAt = activity.startsAt;
    final recurrenceRrule = activity.recurrenceRrule;
    final startsAtText = _formatDateTime(startsAt);
    if (recurrenceRrule == null || recurrenceRrule.trim().isEmpty) {
      return 'One-time • $startsAtText';
    }
    return '$recurrenceRrule • $startsAtText';
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$month-$day $hour:$minute';
  }

  String? _validateRequired(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }
}

class _StatusOptionFormRow {
  _StatusOptionFormRow({required String statusKey, required String label})
    : statusKeyController = TextEditingController(text: statusKey),
      labelController = TextEditingController(text: label);

  final TextEditingController statusKeyController;
  final TextEditingController labelController;

  void dispose() {
    statusKeyController.dispose();
    labelController.dispose();
  }
}
