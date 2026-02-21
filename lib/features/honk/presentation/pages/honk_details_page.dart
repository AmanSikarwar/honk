import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Either;

import '../../../../core/domain/main_failure.dart';
import '../../domain/entities/honk_details.dart';
import '../../domain/repositories/i_honk_repository.dart';

class HonkDetailsPage extends StatefulWidget {
  const HonkDetailsPage({
    required this.honkId,
    required this.honkRepository,
    super.key,
  });

  final String honkId;
  final IHonkRepository honkRepository;

  @override
  State<HonkDetailsPage> createState() => _HonkDetailsPageState();
}

class _HonkDetailsPageState extends State<HonkDetailsPage> {
  late Future<Either<MainFailure, HonkDetails?>> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = widget.honkRepository
        .fetchHonkDetails(honkId: widget.honkId)
        .run();
  }

  void _retry() {
    setState(() {
      _detailsFuture = widget.honkRepository
          .fetchHonkDetails(honkId: widget.honkId)
          .run();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Honk Details')),
      body: FutureBuilder<Either<MainFailure, HonkDetails?>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = snapshot.data;
          if (result == null) {
            return _ErrorView(
              message: 'Unable to load this honk right now.',
              onRetry: _retry,
            );
          }

          return result.match(
            (failure) =>
                _ErrorView(message: failure.toString(), onRetry: _retry),
            (details) {
              if (details == null) {
                return _ErrorView(
                  message: 'This honk is not available anymore.',
                  onRetry: _retry,
                );
              }

              return _HonkDetailsView(details: details);
            },
          );
        },
      ),
    );
  }
}

class _HonkDetailsView extends StatelessWidget {
  const _HonkDetailsView({required this.details});

  final HonkDetails details;

  @override
  Widget build(BuildContext context) {
    final createdAt = _formatDateTime(details.honk.createdAt);
    final expiresAt = _formatDateTime(details.honk.expiresAt);
    final expiresIn = _formatRemaining(details.honk.expiresAt);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.honk.location,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  details.honk.status,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _DetailRow(
                  label: 'From',
                  value:
                      details.senderUsername ??
                      details.honk.userId.substring(0, 8),
                ),
                _DetailRow(label: 'Created', value: createdAt),
                _DetailRow(label: 'Expires', value: expiresAt),
                _DetailRow(label: 'Time left', value: expiresIn),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Honk ID: ${details.honk.id}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
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

  String _formatRemaining(DateTime expiresAt) {
    final remaining = expiresAt.toUtc().difference(DateTime.now().toUtc());
    if (remaining.isNegative) {
      return 'Expired';
    }

    if (remaining.inMinutes < 1) {
      return 'Less than 1 min';
    }

    if (remaining.inHours < 1) {
      return '${remaining.inMinutes} min';
    }

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
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
        children: [
          SizedBox(
            width: 80,
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
