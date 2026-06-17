import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

String formatPrice(num price) {
  if (price is int) {
    return '${(price / 100.0).toStringAsFixed(2).replaceAll('.', ',')}€';
  } else if (price is double) {
    return '${price.toStringAsFixed(2).replaceAll('.', ',')}€';
  }

  return '${price.toString()}€';
}

String cleanupWhitespace(String value) {
  final whitespaceRegex = RegExp(r'\s+');
  return value.replaceAll(whitespaceRegex, ' ');
}

Future<T?> showAnimatedDialog<T extends Object>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  Color barrierColor = const Color(0x80000000),
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierColor: barrierColor,
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
        Container(),
    transitionDuration: const Duration(milliseconds: 250),
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget widget,
        ) {
      final curvedValue = Curves.easeInOutSine.transform(animation.value) - 1.0;

      return Transform(
        transform: Matrix4.translationValues(0.0, curvedValue * 512.0, 0.0),
        child: Opacity(
          opacity: animation.value,
          child: Builder(builder: builder),
        ),
      );
    },
  );
}

extension ComparableDateTime on DateTime {
  bool get isWorkDay => weekday < 6;

  DateTime get nextMonday => add(Duration(days: 7 - weekday + 1));

  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMinute(DateTime other) {
    return isSameDay(other) && hour == other.hour && minute == other.minute;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }
}

extension FormattableDateTime on DateTime {
  String get dateFormat =>
      DateFormat('dd.MM.yyyy', window.locale.languageCode).format(this);

  String get dayOfWeekFormat =>
      DateFormat('EEEE', window.locale.languageCode).format(this);

  String get longDateFormat =>
      DateFormat('EEEE, dd.MM.yyyy', window.locale.languageCode).format(this);

  String get monthFormat =>
      DateFormat('MMMM', window.locale.languageCode).format(this);

  String get shortDateFormat =>
      DateFormat('dd.MM', window.locale.languageCode).format(this);

  String get timeFormat =>
      DateFormat('Hm', window.locale.languageCode).format(this);
}
