class DateFromat {
  final String format;
  const DateFromat(this.format);
}

class DateFormatter {
  final DateTime date;

  DateFormatter(this.date);

  String format(DateFromat dateFromat) {
    var format = dateFromat.format.toUpperCase();
    final weekday = parseWeekDay(format);

    final day = date.day;
    final month = parseMonth(format);

    final year = parseYear(format);
    final time = parseDuration(format);

    final timeZone = parseTimeZone(format);

    final buffer = StringBuffer();
    if (weekday != null) {
      buffer.write(weekday);
      buffer.write(', ');
    }
    buffer.write(day);
    buffer.write(' ');
    buffer.write(month);
    buffer.write(' ');
    buffer.write(year);
    buffer.write(' ');
    buffer.write(time);
    if (timeZone != null) {
      buffer.write(' ');
      buffer.write(timeZone);
    }

    return buffer.toString();
  }

  // String? parseTimeZone(String format) {
  //   return
  // }

  String? parseWeekDay(String format) {
    final regex = RegExp('(E+),');
    if (regex.hasMatch(format)) {
      final match = regex.firstMatch(format)!.group(1)!;
      if (match.length > 3) {
        return _weekdayNames[date.weekday]!;
      }
      return _weekdayNames[date.weekday]!.substring(0, 3);
    }
    return null;
  }

  String? parseMonth(String format) {
    final regex = RegExp('(M+)');
    if (regex.hasMatch(format)) {
      final match = regex.firstMatch(format)!.group(1)!;
      if (match.length > 3) {
        return _months[date.month]!;
      }
      return _months[date.month]!.substring(0, 3);
    }
    return null;
  }

  String? parseYear(String format) {
    final regex = RegExp('(Y+)');
    if (regex.hasMatch(format)) {
      final match = regex.firstMatch(format)!.group(1)!;
      return date.year.toString().padLeft(match.length, '0');
    }
    return null;
  }

  String? parseDuration(String format) {
    final regex = RegExp('(H+)?:(M+)?:(S+)?(\\sA)?');
    if (!regex.hasMatch(format)) {
      return null;
    }

    final match = regex.firstMatch(format)!;
    final hour = date.hour.toString().padLeft(match.group(1)!.length, '0');
    final minute = date.minute.toString().padLeft(match.group(2)!.length, '0');
    final second = date.second.toString().padLeft(match.group(3)!.length, '0');
    final amPm =
        match.group(4) == null ? '' : ' ${date.hour > 12 ? 'PM' : 'AM'}';
    return '$hour:$minute:$second$amPm';
  }

  String? parseTimeZone(String format) {
    final regex1 = RegExp("'(.*?)'\$");
    final regex2 = RegExp('(Z+)');
    if (regex1.hasMatch(format)) {
      return regex1.firstMatch(format)!.group(1)!;
    }
    if (regex2.hasMatch(format)) {
      return date.timeZoneOffset
          .toString()
          .padLeft(regex2.firstMatch(format)!.group(1)!.length, '0');
    }
    return null;
  }

  final Map<int, String> _weekdayNames = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
  };

  final Map<int, String> _months = {
    1: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'September',
    10: 'October',
    11: 'November',
    12: 'December',
  };
}

