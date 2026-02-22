class HonkRecurrenceService {
  const HonkRecurrenceService();

  DateTime resolveOccurrence({
    required DateTime startsAt,
    required String? recurrenceRrule,
    required DateTime nowUtc,
  }) {
    final normalizedStartsAt = startsAt.toUtc();
    final rule = recurrenceRrule?.trim();
    if (rule == null || rule.isEmpty) {
      return normalizedStartsAt;
    }

    final parts = _parseRrule(rule);
    final freq = parts['FREQ'];
    if (freq == null) {
      return normalizedStartsAt;
    }

    if (freq == 'DAILY') {
      return _resolveDaily(normalizedStartsAt, nowUtc);
    }

    if (freq == 'WEEKLY') {
      return _resolveWeekly(
        normalizedStartsAt: normalizedStartsAt,
        nowUtc: nowUtc,
        byDay: parts['BYDAY'],
      );
    }

    return normalizedStartsAt;
  }

  Map<String, String> _parseRrule(String rrule) {
    final map = <String, String>{};
    for (final segment in rrule.split(';')) {
      final idx = segment.indexOf('=');
      if (idx <= 0 || idx == segment.length - 1) {
        continue;
      }
      final key = segment.substring(0, idx).trim().toUpperCase();
      final value = segment.substring(idx + 1).trim().toUpperCase();
      if (key.isNotEmpty && value.isNotEmpty) {
        map[key] = value;
      }
    }
    return map;
  }

  DateTime _resolveDaily(DateTime startsAt, DateTime nowUtc) {
    final deltaDays = nowUtc.difference(startsAt).inDays;
    if (deltaDays < 0) {
      return startsAt;
    }

    final candidate = DateTime.utc(
      startsAt.year,
      startsAt.month,
      startsAt.day + deltaDays,
      startsAt.hour,
      startsAt.minute,
      startsAt.second,
      startsAt.millisecond,
      startsAt.microsecond,
    );

    if (candidate.isAfter(nowUtc)) {
      return candidate.subtract(const Duration(days: 1));
    }

    return candidate;
  }

  DateTime _resolveWeekly({
    required DateTime normalizedStartsAt,
    required DateTime nowUtc,
    required String? byDay,
  }) {
    final allowedWeekdays = _resolveWeekdays(byDay, normalizedStartsAt.weekday);
    DateTime bestPast = normalizedStartsAt;
    DateTime? bestFuture;

    for (int offset = -21; offset <= 21; offset++) {
      final candidateDate = DateTime.utc(
        nowUtc.year,
        nowUtc.month,
        nowUtc.day + offset,
        normalizedStartsAt.hour,
        normalizedStartsAt.minute,
        normalizedStartsAt.second,
        normalizedStartsAt.millisecond,
        normalizedStartsAt.microsecond,
      );

      if (candidateDate.isBefore(normalizedStartsAt)) {
        continue;
      }

      if (!allowedWeekdays.contains(candidateDate.weekday)) {
        continue;
      }

      if (candidateDate.isAfter(nowUtc)) {
        bestFuture ??= candidateDate;
        continue;
      }

      if (candidateDate.isAfter(bestPast)) {
        bestPast = candidateDate;
      }
    }

    if (bestPast.isAfter(nowUtc)) {
      return bestFuture ?? normalizedStartsAt;
    }

    return bestPast;
  }

  Set<int> _resolveWeekdays(String? byDay, int fallbackWeekday) {
    if (byDay == null || byDay.isEmpty) {
      return {fallbackWeekday};
    }

    final values = <int>{};
    for (final code in byDay.split(',')) {
      switch (code.trim().toUpperCase()) {
        case 'MO':
          values.add(DateTime.monday);
          break;
        case 'TU':
          values.add(DateTime.tuesday);
          break;
        case 'WE':
          values.add(DateTime.wednesday);
          break;
        case 'TH':
          values.add(DateTime.thursday);
          break;
        case 'FR':
          values.add(DateTime.friday);
          break;
        case 'SA':
          values.add(DateTime.saturday);
          break;
        case 'SU':
          values.add(DateTime.sunday);
          break;
      }
    }

    if (values.isEmpty) {
      return {fallbackWeekday};
    }
    return values;
  }
}
