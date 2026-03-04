import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Service for retrieving user location based on IP address
class LocationService {
  static final Dio _dio = Dio();

  /// Get city and state from IP address
  /// Returns formatted string like "Los Angeles, CA" or null if unavailable
  static Future<String?> getLocationFromIP() async {
    try {
      // Using ipapi.co - free tier allows 1000 requests/day
      final response = await _dio.get(
        'https://ipapi.co/json/',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final city = data['city'] as String?;
        final region = data['region_code'] as String?; // State/Province code (e.g., "CA")
        
        if (city != null && city.isNotEmpty) {
          if (region != null && region.isNotEmpty) {
            return '$city, $region';
          }
          // If no region code, try region name
          final regionName = data['region'] as String?;
          if (regionName != null && regionName.isNotEmpty) {
            return '$city, $regionName';
          }
          // Just return city if no state available
          return city;
        }
      }
    } catch (e) {
      debugPrint('[LocationService] Error getting location from IP: $e');
      // Try fallback service if primary fails
      return await _getLocationFromIPFallback();
    }
    return null;
  }

  /// Fallback service using ip-api.com
  static Future<String?> _getLocationFromIPFallback() async {
    try {
      final response = await _dio.get(
        'http://ip-api.com/json/',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['status'] == 'success') {
          final city = data['city'] as String?;
          final regionCode = data['regionCode'] as String?;
          
          if (city != null && city.isNotEmpty) {
            if (regionCode != null && regionCode.isNotEmpty) {
              return '$city, $regionCode';
            }
            // If no region code, try region name
            final regionName = data['regionName'] as String?;
            if (regionName != null && regionName.isNotEmpty) {
              return '$city, $regionName';
            }
            return city;
          }
        }
      }
    } catch (e) {
      debugPrint('[LocationService] Fallback service also failed: $e');
    }
    return null;
  }
}


