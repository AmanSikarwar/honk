import 'honk_event.dart';

class HonkDetails {
  const HonkDetails({required this.honk, this.senderUsername});

  final HonkEvent honk;
  final String? senderUsername;
}
