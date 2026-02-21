import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../domain/entities/honk_event.dart';
import '../bloc/honk_feed_bloc.dart';
import '../cubit/action_pad_cubit.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _statusController = TextEditingController();
  final _detailsController = TextEditingController();
  int _ttlMinutes = 30;

  @override
  void dispose() {
    _locationController.dispose();
    _statusController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _openHonkDetails(BuildContext context, String honkId) {
    HonkDetailsRoute(honkId: honkId).push(context);
  }

  void _submitHonk(BuildContext context, String userId) {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    context.read<ActionPadCubit>().broadcastHonk(
      userId: userId,
      location: _locationController.text.trim(),
      status: _statusController.text.trim(),
      details: _detailsController.text.trim().isEmpty
          ? null
          : _detailsController.text.trim(),
      ttl: Duration(minutes: _ttlMinutes),
    );
  }

  void _resetCreateForm() {
    _locationController.clear();
    _statusController.clear();
    _detailsController.clear();
    setState(() {
      _ttlMinutes = 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select<AuthBloc, AppUser?>(
      (bloc) => bloc.state.whenOrNull(authenticated: (user) => user),
    );

    return BlocListener<ActionPadCubit, ActionPadState>(
      listener: (context, state) {
        state.whenOrNull(
          success: (honk) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Honk sent: ${honk.location}'),
                action: SnackBarAction(
                  label: 'VIEW',
                  onPressed: () => _openHonkDetails(context, honk.id),
                ),
              ),
            );
            _resetCreateForm();
            context.read<ActionPadCubit>().reset();
          },
          failure: (failure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(_failureText(failure))));
            context.read<ActionPadCubit>().reset();
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Honk Dashboard'),
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
            IconButton(
              tooltip: 'Sign out',
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEvent.signOut());
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a honk',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              BlocBuilder<ActionPadCubit, ActionPadState>(
                builder: (context, actionState) {
                  final isSubmitting = actionState.maybeWhen(
                    submitting: () => true,
                    orElse: () => false,
                  );
                  final userId = user?.id;

                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _locationController,
                          enabled: !isSubmitting,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            hintText: 'Where are you headed?',
                          ),
                          validator: (value) =>
                              _validateRequired(value, fieldName: 'Location'),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _statusController,
                          enabled: !isSubmitting,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            hintText: 'e.g. going, studying, workout',
                          ),
                          validator: (value) =>
                              _validateRequired(value, fieldName: 'Status'),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _detailsController,
                          enabled: !isSubmitting,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Details (optional)',
                            hintText: 'Add context for friends',
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          key: ValueKey<int>(_ttlMinutes),
                          initialValue: _ttlMinutes,
                          decoration: const InputDecoration(
                            labelText: 'Valid for',
                          ),
                          items: const [
                            DropdownMenuItem(value: 15, child: Text('15 min')),
                            DropdownMenuItem(value: 30, child: Text('30 min')),
                            DropdownMenuItem(value: 45, child: Text('45 min')),
                            DropdownMenuItem(value: 60, child: Text('1 hour')),
                            DropdownMenuItem(
                              value: 120,
                              child: Text('2 hours'),
                            ),
                          ],
                          onChanged: isSubmitting
                              ? null
                              : (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() {
                                    _ttlMinutes = value;
                                  });
                                },
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: isSubmitting || userId == null
                                ? null
                                : () => _submitHonk(context, userId),
                            icon: isSubmitting
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: const Text('Create Honk'),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Friends activity',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<HonkFeedBloc, HonkFeedState>(
                  builder: (context, state) {
                    return state.when(
                      initial: SizedBox.new,
                      loadInProgress: () =>
                          const Center(child: CircularProgressIndicator()),
                      loadFailure: (failure) =>
                          Center(child: Text(_failureText(failure))),
                      loadSuccess: (honks) {
                        if (honks.isEmpty) {
                          return const Center(
                            child: Text('No active honks from friends yet.'),
                          );
                        }

                        return ListView.separated(
                          itemCount: honks.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final honk = honks[index];
                            return ListTile(
                              onTap: () => _openHonkDetails(context, honk.id),
                              title: Text(honk.location),
                              subtitle: Text(_buildFeedSubtitle(honk)),
                              leading: const Icon(Icons.campaign_outlined),
                              trailing: const Icon(Icons.chevron_right),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _failureText(Object failure) {
    return failure.toString();
  }

  String? _validateRequired(String? value, {required String fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  String _buildFeedSubtitle(HonkEvent honk) {
    final parts = <String>[honk.status, _formatDateTime(honk.createdAt)];
    final details = honk.details?.trim();
    if (details != null && details.isNotEmpty) {
      parts.insert(1, details);
    }
    return parts.join(' • ');
  }

  String _formatDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$month-$day $hour:$minute';
  }
}
