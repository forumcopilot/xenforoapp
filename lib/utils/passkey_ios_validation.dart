import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:forumcopilot_sdk/services/fc_http_overrides.dart';
import 'package:forumcopilot_flutter/utils/passkey_validation_result.dart';

class PasskeyIosValidationService {
  static const MethodChannel _channel = MethodChannel('forumcopilot/passkeys');

  static Future<PasskeyValidationResult> validateForDomain(
      String domain) async {
    final normalizedDomain = domain.trim().toLowerCase();
    if (normalizedDomain.isEmpty) {
      return const PasskeyValidationResult.enabled();
    }

    final entitlementDomains = await _getAssociatedDomains();
    if (!_entitlementIncludesDomain(entitlementDomains, normalizedDomain)) {
      return const PasskeyValidationResult.disabled(3);
    }

    final aasaStatus = await _checkAasaStatus(normalizedDomain);
    if (aasaStatus == _AasaStatus.missing) {
      return const PasskeyValidationResult.disabled(1);
    }
    if (aasaStatus == _AasaStatus.invalidContentType) {
      return const PasskeyValidationResult.disabled(2);
    }

    return const PasskeyValidationResult.enabled();
  }

  static Future<List<String>> _getAssociatedDomains() async {
    try {
      final result =
          await _channel.invokeMethod<List<dynamic>>('getAssociatedDomains');
      if (result == null) return const [];
      return result.map((value) => value.toString()).toList();
    } catch (_) {
      return const [];
    }
  }

  static bool _entitlementIncludesDomain(
      List<String> entitlements, String domain) {
    if (entitlements.isEmpty) return false;

    for (final entitlement in entitlements) {
      final value = entitlement.toLowerCase();
      if (!value.startsWith('webcredentials:')) continue;

      final entry = value.substring('webcredentials:'.length).trim();
      if (entry.isEmpty) continue;

      if (_domainMatches(domain, entry)) {
        return true;
      }
    }

    return false;
  }

  static bool _domainMatches(String domain, String entitlementDomain) {
    if (entitlementDomain == domain) return true;
    if (entitlementDomain.startsWith('*.')) {
      final suffix = entitlementDomain.substring(1);
      return domain.endsWith(suffix);
    }
    return false;
  }

  static Future<_AasaStatus> _checkAasaStatus(String domain) async {
    final url = 'https://$domain/.well-known/apple-app-site-association';

    try {
      final response = await FCDioClient.instance.request<List<int>>(
        'GET',
        url,
        responseType: ResponseType.bytes,
        options: Options(
          followRedirects: true,
          validateStatus: (status) =>
              status != null && status >= 200 && status < 500,
        ),
      );

      if (response.statusCode != 200) {
        return _AasaStatus.missing;
      }

      final contentType = response.headers.value('content-type')?.toLowerCase();
      if (contentType == null || !contentType.contains('application/json')) {
        return _AasaStatus.invalidContentType;
      }

      return _AasaStatus.ok;
    } catch (_) {
      return _AasaStatus.unknown;
    }
  }
}

enum _AasaStatus {
  ok,
  missing,
  invalidContentType,
  unknown,
}
