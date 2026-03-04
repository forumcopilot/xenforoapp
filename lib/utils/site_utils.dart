import 'package:flutter/material.dart';

/// Utility class for common Site-related operations
class SiteUtils {
  /// Maps icon code points to constant IconData values
  /// This is used when deserializing Site objects from JSON storage
  static IconData getIconFromCode(int codePoint) {
    // Map common Material Icons codepoints to their constant values
    switch (codePoint) {
      case 0xe7fd: // Icons.support_agent_rounded
        return Icons.support_agent_rounded;
      case 0xe8b0: // Icons.watch_rounded
        return Icons.watch_rounded;
      case 0xe1ca: // Icons.directions_car_rounded
        return Icons.directions_car_rounded;
      case 0xe5d5: // Icons.military_tech_rounded
        return Icons.military_tech_rounded;
      case 0xe564: // Icons.terrain_rounded
        return Icons.terrain_rounded;
      case 0xe868: // Icons.bug_report_rounded
        return Icons.bug_report_rounded;
      case 0xe0b8: // Icons.abc
        return Icons.abc;
      case 0xe1c3: // Icons.directions_bike_rounded
        return Icons.directions_bike_rounded;
      case 0xe324: // Icons.phone_android_rounded
        return Icons.phone_android_rounded;
      case 0xe8b4: // Icons.kitesurfing_rounded
        return Icons.kitesurfing_rounded;
      default:
        // Return a default icon for unknown codes
        return Icons.forum_rounded;
    }
  }
}
