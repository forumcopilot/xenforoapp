import 'package:timeago/timeago.dart';

class CustomTimeAgoMessages implements LookupMessages {
  @override
  String prefixAgo() => '';

  @override
  String prefixFromNow() => '';

  @override
  String suffixAgo() => '';

  @override
  String suffixFromNow() => '';

  @override
  String lessThanOneMinute(int seconds) {
    if (seconds < 5) {
      return 'now';
    }
    return '${seconds}s';
  }

  @override
  String aboutAMinute(int minutes) => '1m';

  @override
  String minutes(int minutes) => '${minutes}m';

  @override
  String aboutAnHour(int minutes) => '1h';

  @override
  String hours(int hours) => '${hours}h';

  @override
  String aDay(int hours) => '1d';

  @override
  String days(int days) => '${days}d';

  @override
  String aboutAMonth(int days) => '1M';

  @override
  String months(int months) => '${months}M';

  @override
  String aboutAYear(int year) => '1Y';

  @override
  String years(int years) => '${years}Y';

  @override
  String wordSeparator() => '';
} 