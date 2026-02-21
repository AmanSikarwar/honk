import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../cubit/notification_sync_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<NotificationSyncCubit, NotificationSyncState>(
          builder: (context, state) {
            final syncing = state.maybeWhen(
              syncInProgress: () => true,
              orElse: () => false,
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Push notifications',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sync your current FCM token to Supabase profiles table.',
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: syncing
                      ? null
                      : context.read<NotificationSyncCubit>().syncToken,
                  icon: syncing
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.notifications_active),
                  label: const Text('Sync token'),
                ),
                const SizedBox(height: 12),
                state.whenOrNull(
                      syncSuccess: () =>
                          const Text('Token synced successfully.'),
                      syncFailure: (failure) => Text(
                        failure.toString(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ) ??
                    const SizedBox.shrink(),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEvent.signOut());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign out'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
