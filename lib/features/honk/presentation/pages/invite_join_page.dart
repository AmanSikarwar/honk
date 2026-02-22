import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either;

import '../../../../core/domain/main_failure.dart';
import '../../../../core/router/app_router.dart';
import '../../domain/repositories/i_honk_repository.dart';

class InviteJoinPage extends StatefulWidget {
  const InviteJoinPage({
    required this.inviteCode,
    required this.honkRepository,
    super.key,
  });

  final String inviteCode;
  final IHonkRepository honkRepository;

  @override
  State<InviteJoinPage> createState() => _InviteJoinPageState();
}

class _InviteJoinPageState extends State<InviteJoinPage> {
  late Future<Either<MainFailure, String>> _joinFuture;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    _joinFuture = _joinByInviteCode();
  }

  Future<Either<MainFailure, String>> _joinByInviteCode() {
    return widget.honkRepository
        .joinByInviteCode(inviteCode: widget.inviteCode)
        .run();
  }

  void _retry() {
    setState(() {
      _didNavigate = false;
      _joinFuture = _joinByInviteCode();
    });
  }

  void _navigateToActivity(String activityId) {
    if (_didNavigate || !mounted) {
      return;
    }
    _didNavigate = true;
    HonkDetailsRoute(activityId: activityId).go(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Joining Activity')),
      body: FutureBuilder<Either<MainFailure, String>>(
        future: _joinFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _CenteredMessage(
              text: 'Joining activity...',
              showLoader: true,
            );
          }

          final result = snapshot.data;
          if (result == null) {
            return _JoinFailureView(
              message: 'Unable to join this activity right now.',
              onRetry: _retry,
            );
          }

          return result.match(
            (failure) =>
                _JoinFailureView(message: failure.toString(), onRetry: _retry),
            (activityId) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _navigateToActivity(activityId);
              });

              return const _CenteredMessage(
                text: 'Activity joined. Redirecting...',
                showLoader: true,
              );
            },
          );
        },
      ),
    );
  }
}

class _JoinFailureView extends StatelessWidget {
  const _JoinFailureView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _CenteredMessage(
      text: message,
      actions: [
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry Join'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => const HomeRoute().go(context),
          child: const Text('Back to Dashboard'),
        ),
      ],
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({
    required this.text,
    this.showLoader = false,
    this.actions = const <Widget>[],
  });

  final String text;
  final bool showLoader;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLoader) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
            ],
            Text(text, textAlign: TextAlign.center),
            if (actions.isNotEmpty) ...[const SizedBox(height: 16), ...actions],
          ],
        ),
      ),
    );
  }
}
