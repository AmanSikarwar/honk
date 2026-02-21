import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/honk_feed_bloc.dart';
import '../cubit/action_pad_cubit.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key, this.initialOpenedHonkId});

  final String? initialOpenedHonkId;

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  bool _hasHandledInitialOpenedHonk = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handleInitialOpenedHonk();
  }

  @override
  void didUpdateWidget(covariant HomeDashboardPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialOpenedHonkId != widget.initialOpenedHonkId) {
      _hasHandledInitialOpenedHonk = false;
      _handleInitialOpenedHonk();
    }
  }

  void _handleInitialOpenedHonk() {
    if (_hasHandledInitialOpenedHonk) {
      return;
    }

    final honkId = widget.initialOpenedHonkId;
    if (honkId == null || honkId.isEmpty) {
      return;
    }

    _hasHandledInitialOpenedHonk = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Opened honk: $honkId')));
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
              SnackBar(content: Text('Honk sent: ${honk.location}')),
            );
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
                'Broadcast a honk',
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

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton(
                        onPressed: isSubmitting || userId == null
                            ? null
                            : () =>
                                  context.read<ActionPadCubit>().broadcastHonk(
                                    userId: userId,
                                    location: 'Mess D1',
                                    status: 'going',
                                  ),
                        child: const Text('Going to Mess'),
                      ),
                      FilledButton.tonal(
                        onPressed: isSubmitting || userId == null
                            ? null
                            : () =>
                                  context.read<ActionPadCubit>().broadcastHonk(
                                    userId: userId,
                                    location: 'Library',
                                    status: 'studying',
                                  ),
                        child: const Text('At Library'),
                      ),
                      FilledButton.tonal(
                        onPressed: isSubmitting || userId == null
                            ? null
                            : () =>
                                  context.read<ActionPadCubit>().broadcastHonk(
                                    userId: userId,
                                    location: 'Gym',
                                    status: 'workout',
                                  ),
                        child: const Text('At Gym'),
                      ),
                    ],
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
                              title: Text(honk.location),
                              subtitle: Text(
                                '${honk.status} • ${honk.createdAt.toLocal()}',
                              ),
                              leading: const Icon(Icons.campaign_outlined),
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
}
