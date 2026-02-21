import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../cubit/friend_management_cubit.dart';

class FriendManagementPage extends StatelessWidget {
  const FriendManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Management'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => const SettingsRoute().go(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<FriendManagementCubit, FriendManagementState>(
          builder: (context, state) {
            final friendIds = state.friends.map((friend) => friend.id).toSet();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: context.read<FriendManagementCubit>().searchUsers,
                  decoration: const InputDecoration(
                    labelText: 'Search users by username',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                if (state.searchResults.isNotEmpty)
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      itemCount: state.searchResults.length,
                      itemBuilder: (context, index) {
                        final profile = state.searchResults[index];
                        final alreadyFriend = friendIds.contains(profile.id);
                        return ListTile(
                          dense: true,
                          title: Text(profile.username),
                          subtitle: Text(profile.id),
                          trailing: ElevatedButton(
                            onPressed: alreadyFriend
                                ? null
                                : () => context
                                      .read<FriendManagementCubit>()
                                      .addFriend(profile.id),
                            child: Text(alreadyFriend ? 'Added' : 'Add'),
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your friends',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(
                      tooltip: 'Refresh',
                      onPressed: state.isLoading
                          ? null
                          : context.read<FriendManagementCubit>().loadFriends,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
                if (state.failure != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      state.failure.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.friends.isEmpty
                      ? const Center(child: Text('No friends added yet.'))
                      : ListView.separated(
                          itemCount: state.friends.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final friend = state.friends[index];
                            return ListTile(
                              title: Text(friend.username),
                              subtitle: Text(friend.id),
                              leading: const Icon(Icons.person_outline),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
