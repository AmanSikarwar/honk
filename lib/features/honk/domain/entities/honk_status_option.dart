class HonkStatusOption {
  const HonkStatusOption({
    required this.statusKey,
    required this.label,
    required this.sortOrder,
    required this.isDefault,
    required this.isActive,
  });

  final String statusKey;
  final String label;
  final int sortOrder;
  final bool isDefault;
  final bool isActive;
}
