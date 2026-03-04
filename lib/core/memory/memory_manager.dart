import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:forumcopilot_flutter/core/logging/app_logger.dart';

/// Centralized memory management service
class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final Map<String, VoidCallback> _cleanupCallbacks = {};
  final Map<String, Timer> _cleanupTimers = {};
  Timer? _memoryMonitorTimer;

  // Memory thresholds
  static const int _warningThresholdMB = 100;
  static const int _criticalThresholdMB = 200;

  bool _isMonitoring = false;

  /// Start memory monitoring
  void startMonitoring({Duration interval = const Duration(minutes: 2)}) {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _memoryMonitorTimer = Timer.periodic(interval, (_) {
      _checkMemoryUsage();
    });

    AppLogger.info('Memory monitoring started');
  }

  /// Stop memory monitoring
  void stopMonitoring() {
    _memoryMonitorTimer?.cancel();
    _memoryMonitorTimer = null;
    _isMonitoring = false;

    AppLogger.info('Memory monitoring stopped');
  }

  /// Register cleanup callback for a component
  void registerCleanup(String componentName, VoidCallback cleanupCallback) {
    _cleanupCallbacks[componentName] = cleanupCallback;
    AppLogger.debug('Registered cleanup for: $componentName');
  }

  /// Unregister cleanup callback
  void unregisterCleanup(String componentName) {
    _cleanupCallbacks.remove(componentName);
    AppLogger.debug('Unregistered cleanup for: $componentName');
  }

  /// Schedule periodic cleanup for a component
  void scheduleCleanup(String componentName, VoidCallback cleanupCallback, Duration interval) {
    _cleanupTimers[componentName] = Timer.periodic(interval, (_) {
      try {
        cleanupCallback();
        AppLogger.debug('Performed scheduled cleanup for: $componentName');
      } catch (e) {
        AppLogger.warning('Cleanup failed for $componentName: $e');
      }
    });

    AppLogger.debug('Scheduled cleanup for: $componentName (${interval.inMinutes}m)');
  }

  /// Cancel scheduled cleanup
  void cancelScheduledCleanup(String componentName) {
    _cleanupTimers[componentName]?.cancel();
    _cleanupTimers.remove(componentName);
    AppLogger.debug('Cancelled scheduled cleanup for: $componentName');
  }

  /// Force cleanup of all registered components
  void forceCleanup() {
    AppLogger.info('Performing force cleanup of all components');

    for (final entry in _cleanupCallbacks.entries) {
      try {
        entry.value();
        AppLogger.debug('Force cleaned: ${entry.key}');
      } catch (e) {
        AppLogger.warning('Force cleanup failed for ${entry.key}: $e');
      }
    }
  }

  /// Check memory usage and trigger cleanup if needed
  void _checkMemoryUsage() {
    if (!kDebugMode) return; // Only monitor in debug mode

    try {
      // Get memory usage (this is a simplified check)
      final memoryUsage = _getMemoryUsage();

      if (memoryUsage > _criticalThresholdMB) {
        AppLogger.warning('Critical memory usage detected: ${memoryUsage}MB');
        _triggerEmergencyCleanup();
      } else if (memoryUsage > _warningThresholdMB) {
        AppLogger.warning('High memory usage detected: ${memoryUsage}MB');
        _triggerPreventiveCleanup();
      }
    } catch (e) {
      AppLogger.warning('Memory check failed: $e');
    }
  }

  /// Get current memory usage (simplified implementation)
  int _getMemoryUsage() {
    // This is a simplified implementation
    // In a real app, you'd use platform-specific APIs
    return 50; // Placeholder
  }

  /// Trigger emergency cleanup
  void _triggerEmergencyCleanup() {
    AppLogger.warning('Triggering emergency cleanup');
    forceCleanup();

    // Force garbage collection if available
    if (kDebugMode) {
      developer.log('Emergency cleanup completed');
    }
  }

  /// Trigger preventive cleanup
  void _triggerPreventiveCleanup() {
    AppLogger.info('Triggering preventive cleanup');

    // Clean up least recently used caches
    for (final entry in _cleanupCallbacks.entries) {
      if (entry.key.contains('cache')) {
        try {
          entry.value();
          AppLogger.debug('Preventive cleaned: ${entry.key}');
        } catch (e) {
          AppLogger.warning('Preventive cleanup failed for ${entry.key}: $e');
        }
      }
    }
  }

  /// Get memory statistics
  Map<String, dynamic> getMemoryStats() {
    return {
      'isMonitoring': _isMonitoring,
      'registeredCleanups': _cleanupCallbacks.length,
      'scheduledCleanups': _cleanupTimers.length,
      'warningThresholdMB': _warningThresholdMB,
      'criticalThresholdMB': _criticalThresholdMB,
    };
  }

  /// Dispose all resources
  void dispose() {
    stopMonitoring();

    // Cancel all scheduled cleanups
    for (final timer in _cleanupTimers.values) {
      timer.cancel();
    }
    _cleanupTimers.clear();

    // Clear all callbacks
    _cleanupCallbacks.clear();

    AppLogger.info('MemoryManager disposed');
  }
}
