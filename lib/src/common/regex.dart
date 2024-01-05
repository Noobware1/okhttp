// ignore_for_file: unnecessary_this

class BetterRegex {
  final String source;
  final bool multiLine;
  final bool caseSensitive;
  final bool unicode;
  final bool dotAll;
  late RegExp _regex;
  String input = '';
  int _from = 0;
  late int _to = input.length;

  BetterRegex(
    this.source, {
    this.multiLine = false,
    this.caseSensitive = true,
    this.unicode = false,
    this.dotAll = false,
  }) {
    _regex = RegExp(
      source,
      multiLine: multiLine,
      caseSensitive: caseSensitive,
      unicode: unicode,
      dotAll: dotAll,
    );
  }

  factory BetterRegex.fromRegex(RegExp regex) {
    return BetterRegex(
      regex.pattern,
      caseSensitive: regex.isCaseSensitive,
      dotAll: regex.isDotAll,
      multiLine: regex.isMultiLine,
      unicode: regex.isUnicode,
    );
  }

  BetterRegex matcher(String input) {
    this.input = input;
    return this;
  }

  String get currentRegionalString => input.substring(_from, _to);

  bool matches() {
    return _regex.hasMatch(currentRegionalString);
  }

  String group(int index) {
    if (index < 0) {
      throw ArgumentError.value(index, "index", "index must be >= 0");
    }
    final match = _regex.firstMatch(currentRegionalString);
    if (index > match!.groupCount) {
      throw ArgumentError.value(index, "index", "index must be <= groupCount");
    }
    return match.group(index)!;
  }

  BetterRegex region(int start, int end) {
    if ((start < 0) || (start > input.length)) {
      throw IndexError.withLength(start, input.length, indexable: input);
    }
    if ((end < 0) || (end > input.length)) {
      throw IndexError.withLength(end, input.length, indexable: input);
    }
    if (start > end) {
      throw ArgumentError.value(start, "start", "start must be <= end");
    }
    _from = start;
    _to = end;
    return this;
  }

  BetterRegex usePattern(RegExp regex) {
    _regex = regex;
    return this;
  }
}
