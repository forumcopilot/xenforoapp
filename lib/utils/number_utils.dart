import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats a number using the device's locale
/// Returns '-' if the value is null
String formatNumber(BuildContext context, int? value) {
  if (value == null) return '-';
  final locale = Localizations.localeOf(context).toString();
  return NumberFormat.decimalPattern(locale).format(value);
}

/// Formats a number using the device's locale
/// Returns '-' if the value is null
String formatNumberFromString(BuildContext context, String? value) {
  if (value == null || value.isEmpty) return '-';
  final number = int.tryParse(value);
  if (number == null) return '-';
  return formatNumber(context, number);
}
