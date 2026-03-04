import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:forumcopilot_flutter/config/app_forum_config.dart';
import 'package:forumcopilot_flutter/utils/passkey_validation_result.dart';
import 'package:forumcopilot_sdk/services/fc_http_overrides.dart';

class PasskeyAndroidValidationService {
  static const String _expectedNamespace = 'android_app';
  static const String _expectedRelation =
      'delegate_permission/common.get_login_creds';
  static String get _expectedPackageName =>
      AppForumConfig.androidPackageName.trim();
  static String get _expectedFingerprint =>
      AppForumConfig.androidSha256CertFingerprint.trim();

  static Future<PasskeyValidationResult> validateForDomain(
      String domain) async {
    final normalizedDomain = domain.trim().toLowerCase();
    if (normalizedDomain.isEmpty) {
      return const PasskeyValidationResult.enabled();
    }
    if (_expectedPackageName.isEmpty || _expectedFingerprint.isEmpty) {
      return const PasskeyValidationResult.enabled();
    }

    final status = await _checkAssetLinksStatus(normalizedDomain);
    if (status == _AssetLinksStatus.missing) {
      return const PasskeyValidationResult.disabled(1);
    }
    if (status == _AssetLinksStatus.invalid) {
      return const PasskeyValidationResult.disabled(2);
    }

    return const PasskeyValidationResult.enabled();
  }

  static Future<_AssetLinksStatus> _checkAssetLinksStatus(String domain) async {
    final url = 'https://$domain/.well-known/assetlinks.json';

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
        return _AssetLinksStatus.missing;
      }

      final contentType = response.headers.value('content-type')?.toLowerCase();
      if (contentType == null || !contentType.contains('application/json')) {
        return _AssetLinksStatus.invalid;
      }

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return _AssetLinksStatus.invalid;
      }

      final decoded = jsonDecode(utf8.decode(bytes));
      if (decoded is! List) {
        return _AssetLinksStatus.invalid;
      }

      final hasExpectedEntry = decoded.any((entry) {
        if (entry is! Map) {
          return false;
        }

        final relation = entry['relation'];
        if (relation is! List ||
            !relation.any((value) => value?.toString() == _expectedRelation)) {
          return false;
        }

        final target = entry['target'];
        if (target is! Map) {
          return false;
        }

        final namespace = target['namespace']?.toString();
        if (namespace != _expectedNamespace) {
          return false;
        }

        final packageName = target['package_name']?.toString();
        if (packageName != _expectedPackageName) {
          return false;
        }

        final fingerprints = target['sha256_cert_fingerprints'];
        if (fingerprints is! List) {
          return false;
        }

        return fingerprints.any(
          (value) =>
              _normalizeFingerprint(value?.toString()) ==
              _normalizeFingerprint(_expectedFingerprint),
        );
      });

      return hasExpectedEntry
          ? _AssetLinksStatus.ok
          : _AssetLinksStatus.invalid;
    } catch (_) {
      // Don't hard-block passkey when readiness cannot be determined due to transient network issues.
      return _AssetLinksStatus.unknown;
    }
  }

  static String _normalizeFingerprint(String? input) {
    return (input ?? '').trim().toUpperCase();
  }
}

enum _AssetLinksStatus {
  ok,
  missing,
  invalid,
  unknown,
}
