import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/app_router.dart';
import '../cubit/join_honk_cubit.dart';

class InviteJoinPage extends StatefulWidget {
  const InviteJoinPage({required this.inviteCode, super.key});

  final String inviteCode;

  @override
  State<InviteJoinPage> createState() => _InviteJoinPageState();
}

class _InviteJoinPageState extends State<InviteJoinPage> {
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    context.read<JoinHonkCubit>().joinByCode(widget.inviteCode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinHonkCubit, JoinHonkState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (s) {
            if (_didNavigate) return;
            _didNavigate = true;
            HonkDetailsRoute(activityId: s.activityId).go(context);
          },
          pendingApproval: (s) {
            // Stay on this page showing the pending UI.
            // When approved (state becomes success) we navigate.
          },
        );
      },
      child: BlocBuilder<JoinHonkCubit, JoinHonkState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Joining Honk')),
            body: state.map(
              idle: (_) =>
                  const _CenteredMessage(text: 'Preparing…', showLoader: true),
              loading: (_) => const _CenteredMessage(
                text: 'Joining activity…',
                showLoader: true,
              ),
              pendingApproval: (_) => const _CenteredMessage(
                text:
                    'Request sent! Waiting for the creator to approve your join request.',
                showLoader: true,
              ),
              success: (_) => const _CenteredMessage(
                text: 'Redirecting…',
                showLoader: true,
              ),
              failure: (f) => _JoinFailureView(
                message: f.failure.toString(),
                onRetry: () {
                  _didNavigate = false;
                  context.read<JoinHonkCubit>().joinByCode(widget.inviteCode);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Internal widgets ──────────────────────────────────────────────────────────

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.text, this.showLoader = false});

  final String text;
  final bool showLoader;

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
              const SizedBox(height: 16),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => const HomeRoute().go(context),
              child: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}
