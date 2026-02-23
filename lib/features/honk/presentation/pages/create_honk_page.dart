import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/widgets/user_avatar.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/honk_status_option.dart';
import '../cubit/create_honk_cubit.dart';

class CreateHonkPage extends StatefulWidget {
  const CreateHonkPage({super.key});

  @override
  State<CreateHonkPage> createState() => _CreateHonkPageState();
}

class _CreateHonkPageState extends State<CreateHonkPage> {
  final _formKey = GlobalKey<FormState>();
  final _actCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  final _detCtrl = TextEditingController();

  int _resetSecs = 3600;
  final List<_StatusRowData> _rows = [
    _StatusRowData('going', 'Going'),
    _StatusRowData('maybe', 'Maybe'),
    _StatusRowData('not_going', 'Not going'),
  ];
  int _defaultIdx = 0;

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

  List<HonkStatusOption> _buildOptions() => [
    for (var i = 0; i < _rows.length; i++)
      HonkStatusOption(
        statusKey: _rows[i].keyCtrl.text.trim(),
        label: _rows[i].labelCtrl.text.trim(),
        sortOrder: i,
        isDefault: i == _defaultIdx,
        isActive: true,
      ),
  ];

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;
    final opts = _buildOptions();
    final keysValid = opts.every(
      (o) =>
          o.statusKey.isNotEmpty &&
          o.label.isNotEmpty &&
          RegExp(r'^[a-z0-9_]+$').hasMatch(o.statusKey),
    );
    if (!keysValid ||
        opts.map((o) => o.statusKey).toSet().length != opts.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Status keys must be unique lowercase letters/numbers.',
          ),
        ),
      );
      return;
    }
    context.read<CreateHonkCubit>().createActivity(
      activity: _actCtrl.text.trim(),
      location: _locCtrl.text.trim(),
      details: _detCtrl.text.trim().isEmpty ? null : _detCtrl.text.trim(),
      statusResetSeconds: _resetSecs,
      statusOptions: opts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateHonkCubit, CreateHonkState>(
      listener: (ctx, state) {
        if (state.submissionFailure != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(state.submissionFailure.toString())),
          );
          ctx.read<CreateHonkCubit>().resetSubmission();
        }
        if (state.createdActivity != null) {
          HonkDetailsRoute(activityId: state.createdActivity!.id).go(ctx);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('New honk 📣')),
        body: BlocBuilder<CreateHonkCubit, CreateHonkState>(
          builder: (ctx, state) => Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                AppSpacing.xxl,
              ),
              children: [
                // ── Plan details ───────────────────────────────────────
                const SectionHeader('Plan details'),
                const SizedBox(height: AppSpacing.sm),
                TextFormField(
                  controller: _actCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'What\'s the plan? *',
                    hintText: 'e.g. Ping pong at the rec centre',
                    prefixIcon: Icon(Icons.event_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required.' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _locCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Where? *',
                    hintText: 'e.g. 4th floor lounge',
                    prefixIcon: Icon(Icons.place_outlined),
                  ),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required.' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _detCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Extra details (optional)',
                    hintText: 'e.g. Bring rackets',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(bottom: 28),
                      child: Icon(Icons.info_outline),
                    ),
                    alignLabelWithHint: true,
                  ),
                ),

                // ── Status reset ───────────────────────────────────────
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader('Status expiry'),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Statuses reset to default after this period.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                _ExpiryPicker(
                  value: _resetSecs,
                  onChanged: (v) => setState(() => _resetSecs = v),
                ),

                // ── Status options ─────────────────────────────────────
                const SizedBox(height: AppSpacing.lg),
                const SectionHeader('Response options'),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Tap ⭕ to set the default response.',
                  style: Theme.of(context).textTheme.bodySmall,
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
                          tooltip: 'Set as default',
                        ),
                        Expanded(
                          child: TextField(
                            controller: row.keyCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Key',
                              hintText: 'e.g. going',
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
                              hintText: 'e.g. Going',
                              isDense: true,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _rows.length <= 2
                              ? null
                              : () => setState(() {
                                  _rows.removeAt(i).dispose();
                                  _defaultIdx = _defaultIdx.clamp(
                                    0,
                                    _rows.length - 1,
                                  );
                                }),
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
                            _StatusRowData(
                              'status_${_rows.length + 1}',
                              'Option ${_rows.length + 1}',
                            ),
                          );
                        }),
                  icon: const Icon(Icons.add),
                  label: const Text('Add option'),
                ),

                // ── Submit ─────────────────────────────────────────────
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: state.isSubmitting ? null : _submit,
                  child: state.isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create honk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Expiry picker ─────────────────────────────────────────────────────────────

class _ExpiryPicker extends StatelessWidget {
  const _ExpiryPicker({required this.value, required this.onChanged});
  final int value;
  final ValueChanged<int> onChanged;

  static const _options = [
    (600, '10 min'),
    (1800, '30 min'),
    (3600, '1 hour'),
    (7200, '2 hours'),
    (86400, '1 day'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      children: _options.map((opt) {
        final (secs, label) = opt;
        final selected = secs == value;
        return ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => onChanged(secs),
          selectedColor: AppColors.brandPurple.withValues(alpha: 0.15),
          labelStyle: TextStyle(
            color: selected
                ? AppColors.brandPurple
                : Theme.of(context).colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }
}

// ── Internal helpers ──────────────────────────────────────────────────────────

class _StatusRowData {
  _StatusRowData(String key, String label)
    : keyCtrl = TextEditingController(text: key),
      labelCtrl = TextEditingController(text: label);
  final TextEditingController keyCtrl;
  final TextEditingController labelCtrl;
  void dispose() {
    keyCtrl.dispose();
    labelCtrl.dispose();
  }
}
