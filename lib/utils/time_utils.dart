import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

void initializeTimeAgo() {
  // Initialize all supported locales
  // timeago package has built-in support for: en, es, fr, de, it, ru, ja, zh
  // For locales not available, we'll use English as fallback
  timeago.setLocaleMessages('en', timeago.EnMessages());
  timeago.setLocaleMessages('es', timeago.EsMessages());
  timeago.setLocaleMessages('fr', timeago.FrMessages());
  timeago.setLocaleMessages('de', timeago.DeMessages());
  timeago.setLocaleMessages('it', timeago.ItMessages());
  timeago.setLocaleMessages('ru', timeago.RuMessages());
  timeago.setLocaleMessages('ja', timeago.JaMessages());
  timeago.setLocaleMessages('zh', timeago.ZhMessages());
  
  // Portuguese and Korean not available in timeago, use English as fallback
  timeago.setLocaleMessages('pt', timeago.EnMessages());
  timeago.setLocaleMessages('ko', timeago.EnMessages());
}

/// Get the timeago locale code from Flutter locale
/// Maps our supported locales to timeago locale codes
String _getTimeAgoLocale(Locale locale) {
  final languageCode = locale.languageCode;
  // timeago uses the same language codes for most languages
  // Map our locales to timeago locales
  switch (languageCode) {
    case 'en':
      return 'en';
    case 'es':
      return 'es';
    case 'fr':
      return 'fr';
    case 'de':
      return 'de';
    case 'it':
      return 'it';
    case 'pt':
      return 'pt';
    case 'ru':
      return 'ru';
    case 'ja':
      return 'ja';
    case 'ko':
      return 'ko';
    case 'zh':
      return 'zh';
    default:
      return 'en'; // Fallback to English
  }
}

/// Internal helper that works with already localized DateTime
String _formatUserDateTimeInternal(DateTime localDateTime, BuildContext context) {
  try {
    final locale = Localizations.localeOf(context);
    final use24Hour = MediaQuery.of(context).alwaysUse24HourFormat;

    final dateFormat = DateFormat.yMMMd(locale.toString());
    final timeFormat = use24Hour ? DateFormat.Hm(locale.toString()) : DateFormat.jm(locale.toString());

    return '${dateFormat.format(localDateTime)}, ${timeFormat.format(localDateTime)}';
  } catch (e) {
    // Fallback if error occurs
    return DateFormat.yMMMd().add_jm().format(localDateTime);
  }
}

/// Internal helper that works with already localized DateTime
String _formatUserDateInternal(DateTime localDateTime, BuildContext context) {
  try {
    final locale = Localizations.localeOf(context);
    return DateFormat.yMMMd(locale.toString()).format(localDateTime);
  } catch (e) {
    return DateFormat.yMMMd().format(localDateTime);
  }
}

/// Internal helper that works with already localized DateTime
String _formatUserTimeInternal(DateTime localDateTime, BuildContext context) {
  try {
    final locale = Localizations.localeOf(context);
    final use24Hour = MediaQuery.of(context).alwaysUse24HourFormat;

    final timeFormat = use24Hour ? DateFormat.Hm(locale.toString()) : DateFormat.jm(locale.toString());

    return timeFormat.format(localDateTime);
  } catch (e) {
    return DateFormat.jm().format(localDateTime);
  }
}

/// Format a DateTime using timeago with the locale from context
String formatTimeAgo(DateTime dateTime, BuildContext context) {
  final locale = Localizations.localeOf(context);
  final timeAgoLocale = _getTimeAgoLocale(locale);
  final now = DateTime.now();
  return timeago.format(dateTime, clock: now, locale: timeAgoLocale);
}

String formatSmartTimestamp(int timestamp, BuildContext context) {
  final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  return formatSmartDateTime(dateTime, context);
}

/// Parses a timestamp string that could be in ISO8601 format or Unix timestamp (milliseconds)
/// Returns null if parsing fails
DateTime? parseTimestampString(String? timestampString) {
  if (timestampString == null || timestampString.isEmpty) {
    return null;
  }

  // Try parsing as ISO8601 string first
  final iso8601DateTime = DateTime.tryParse(timestampString);
  if (iso8601DateTime != null) {
    return iso8601DateTime;
  }

  // Try parsing as Unix timestamp (milliseconds)
  final timestampInt = int.tryParse(timestampString);
  if (timestampInt != null) {
    // Check if it's in seconds (less than year 2001 in milliseconds) or milliseconds
    if (timestampInt < 10000000000) {
      // Likely seconds, convert to milliseconds
      return DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000, isUtc: true);
    } else {
      // Likely milliseconds
      return DateTime.fromMillisecondsSinceEpoch(timestampInt, isUtc: true);
    }
  }

  return null;
}

/// Hybrid approach: Uses timeago for recent dates, formatted date/time for older ones
String formatSmartDateTime(DateTime dateTime, BuildContext context) {
  final localDateTime = dateTime.toLocal();
  final now = DateTime.now();
  final difference = now.difference(localDateTime);
  final locale = Localizations.localeOf(context);
  final timeAgoLocale = _getTimeAgoLocale(locale);

  // Use timeago for very recent dates (less than 24 hours)
  if (difference.inHours < 24) {
    return timeago.format(localDateTime, clock: now, locale: timeAgoLocale);
  }

  // For this week (last 7 days) use timeago with the time
  if (difference.inDays < 7) {
    return '${timeago.format(localDateTime, clock: now, locale: timeAgoLocale)} ${_formatUserTimeInternal(localDateTime, context)}';
  }

  // For this year, show date without year + time
  if (localDateTime.year == now.year) {
    try {
      final locale = Localizations.localeOf(context);
      final dateFormat = DateFormat.MMMd(locale.toString());
      return '${dateFormat.format(localDateTime)}, ${_formatUserTimeInternal(localDateTime, context)}';
    } catch (e) {
      return _formatUserDateTimeInternal(localDateTime, context);
    }
  }

  // For older dates, full date + time
  return _formatUserDateTimeInternal(localDateTime, context);
}
