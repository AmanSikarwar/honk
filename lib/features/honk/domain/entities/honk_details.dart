import 'honk_event.dart';

class HonkDetails {
  const HonkDetails({
    required this.honk,
    this.senderUsername,
    required this.isOwnedByCurrentUser,
  });

  final HonkEvent honk;
  final String? senderUsername;
  final bool isOwnedByCurrentUser;
}
