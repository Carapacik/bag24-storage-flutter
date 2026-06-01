import 'dart:async';

import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class const StorageTimeWidget({final int? depositedDays, final DateTime? depositedAt, super.key})
    extends StatefulWidget {
  @override
  State<StorageTimeWidget> createState() => _StorageTimeWidgetState();
}

class _StorageTimeWidgetState() extends State<StorageTimeWidget> {
  late int? _depositedDays;
  Timer? _timer;
  String _timeLeft = '';
  double _progressValue = 0;

  @override
  void initState() {
    super.initState();
    _depositedDays = _calculateDaysLeft();
    _updateTimeLeftUntilMidnight();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimeLeftUntilMidnight());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimeLeftUntilMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final Duration difference = midnight.difference(now);

    String timeLeftFormat;
    if (_depositedDays != null && _depositedDays! > 0) {
      timeLeftFormat =
          '$_depositedDays д ${DateFormat('HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(difference.inMilliseconds).subtract(DateTime.now().timeZoneOffset))}';
    } else {
      timeLeftFormat = DateFormat(
        'HH:mm:ss',
      ).format(DateTime.fromMillisecondsSinceEpoch(difference.inMilliseconds).subtract(DateTime.now().timeZoneOffset));
    }

    if (mounted) {
      setState(() {
        _timeLeft = timeLeftFormat;
        _progressValue = 1 - (difference.inHours / 24);
      });
    }
  }

  int? _calculateDaysLeft() {
    if (widget.depositedAt == null || widget.depositedDays == null) {
      return null;
    }

    // Узнаем аболютный день сдачи багажа
    final DateTime depositedDateTime = widget.depositedAt!;
    final depositedDay = DateTime(depositedDateTime.year, depositedDateTime.month, depositedDateTime.day);

    // Вычисляем дату следующей полночь
    final currentDay = DateTime.now();
    final midnight = DateTime(currentDay.year, currentDay.month, currentDay.day + 1);

    // Вычисляем разницу между датой полночью и датой депозита
    final int daysSinceDeposited = midnight.difference(depositedDay).inDays;

    // Возвращаем количество дней, оставшихся до истечения срока
    return widget.depositedDays! - daysSinceDeposited;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: _progressValue,
          minHeight: 4,
          backgroundColor: context.colors.buttonBgTertiary,
          valueColor: AlwaysStoppedAnimation(context.colors.progressBar),
        ),
        const SizedBox(height: 4),
        Text(
          '${context.l10n.timeLeft} $_timeLeft',
          style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textTertiary),
        ),
      ],
    );
  }
}
