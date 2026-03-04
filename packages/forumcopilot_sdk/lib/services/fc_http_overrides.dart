import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'cloudflare_interceptor/cloudflare_interceptor.dart';

class FCDioClient {
  String userAgent;
  late Dio dio;
  CookieJar? cookieJar;
  bool _initialized = false;
  BuildContext? _context;
  bool _cloudflareAdded = false;
  VoidCallback? onCloudflareStart;
  VoidCallback? onCloudflareEnd;

  FCDioClient._internal({required this.userAgent}) : dio = Dio(BaseOptions(followRedirects: true));

  static final FCDioClient _instance = FCDioClient._internal(userAgent: 'DefaultUserAgent/1.0');

  factory FCDioClient({String? userAgent}) {
    if (userAgent != null) {
      _instance.userAgent = userAgent;
    }
    return _instance;
  }

  static FCDioClient get instance => _instance;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final cookieDir = await _resolveCookieStorageDirectory();
      cookieJar = PersistCookieJar(storage: FileStorage(cookieDir.path));
      debugPrint('🍪 [COOKIE] Persistent cookie storage initialized at: ${cookieDir.path}');
    } catch (e) {
      debugPrint('Error initializing persistent cookie jar: $e');
      cookieJar = CookieJar(); // Fallback to in-memory
    }

    // Configure Dio interceptors
    dio.interceptors.clear();
    if (cookieJar != null) {
      dio.interceptors.add(CookieManager(cookieJar!));
    }
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers.putIfAbsent('User-Agent', () => userAgent + ' ForumCopilot/1.0');
          options.headers.putIfAbsent('X-Forum-Copilot', () => '1');
          return handler.next(options);
        },
      ),
    );
    _maybeAttachCloudflare();

    _initialized = true;
  }

  Future<void> setContext(BuildContext? context) async {
    _context = context;
    await initialize();
    _maybeAttachCloudflare();
  }

  Future<void> clearAllCookies() async {
    await initialize();
    debugPrint('🍪 [COOKIE] Clearing all cookies');
    await cookieJar?.deleteAll();
  }

  Future<void> clearCookiesForDomain(Uri uri, {String reason = 'unspecified'}) async {
    await initialize();
    final before = await cookieCountForUrl(uri);
    if (uri.path.isNotEmpty && uri.path != '/') {
      debugPrint(
        '⚠️ [COOKIE] Host-wide cookie clear requested for host=${uri.host} from path=${uri.path}. '
        'This may impact multiple forums on the same host.',
      );
    }
    debugPrint('🍪 [COOKIE] Clearing cookies for host=${uri.host} path=${uri.path.isEmpty ? '/' : uri.path} reason=$reason before=$before');
    await cookieJar?.delete(uri);
    final after = await cookieCountForUrl(uri);
    debugPrint('🍪 [COOKIE] Cleared cookies for host=${uri.host} reason=$reason after=$after');
  }

  /// Check if cookies exist for a specific URL
  Future<bool> hasCookiesForUrl(Uri url) async {
    await initialize();
    final cookies = await cookieJar?.loadForRequest(url) ?? [];
    return cookies.isNotEmpty;
  }

  /// Count cookies available for a URL
  Future<int> cookieCountForUrl(Uri url) async {
    await initialize();
    final cookies = await cookieJar?.loadForRequest(url) ?? [];
    return cookies.length;
  }

  /// Get cookies for a specific URL as a Cookie header string
  Future<String> getCookiesForUrl(Uri url) async {
    await initialize();
    final cookies = await cookieJar?.loadForRequest(url) ?? [];

    if (cookies.isEmpty) return '';

    final seenKeys = <String>{};
    final cookieStrings = <String>[];

    for (var cookie in cookies) {
      if (cookie.name.isEmpty) {
        debugPrint('⚠️ [COOKIE] Skipping cookie with empty name when building Cookie header');
        continue;
      }

      final identityKey = '${cookie.domain ?? ''}|${cookie.path ?? '/'}|${cookie.name}';
      if (seenKeys.contains(identityKey)) {
        continue;
      }

      seenKeys.add(identityKey);
      cookieStrings.add('${cookie.name}=${cookie.value}');
    }

    return cookieStrings.join('; ');
  }

  Future<Response<T>> request<T>(
    String method,
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
    Options? options,
    ResponseType? responseType,
  }) async {
    await initialize();
    final mergedOptions = (options ?? Options()).copyWith(
      method: method,
      headers: {
        ...?options?.headers?.map((key, value) => MapEntry(key, value)),
        ...?headers,
      },
      responseType: responseType ?? options?.responseType,
    );

    return dio.request<T>(
      url,
      data: data,
      queryParameters: queryParameters,
      options: mergedOptions,
    );
  }

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    ResponseType? responseType,
    Options? options,
  }) {
    return request<T>(
      'GET',
      url,
      queryParameters: queryParameters,
      headers: headers,
      options: options,
      responseType: responseType,
    );
  }

  Future<Response<T>> post<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, String>? headers,
    ResponseType? responseType,
    Options? options,
  }) {
    return request<T>(
      'POST',
      url,
      queryParameters: queryParameters,
      data: data,
      headers: headers,
      options: options,
      responseType: responseType,
    );
  }

  void _maybeAttachCloudflare() {
    if (_cloudflareAdded) return;
    if (_context == null) return;
    if (cookieJar == null) return;
    dio.interceptors.add(
      CloudflareInterceptor(
        dio: dio,
        cookieJar: cookieJar!,
        context: _context!,
        onChallengeStart: onCloudflareStart,
        onChallengeEnd: onCloudflareEnd,
      ),
    );
    _cloudflareAdded = true;
  }

  Future<Directory> _resolveCookieStorageDirectory() async {
    final supportDir = await getApplicationSupportDirectory();
    final supportCookieDir = Directory('${supportDir.path}/cookies');
    final cacheDir = await getApplicationCacheDirectory();
    final cacheCookieDir = Directory('${cacheDir.path}/cookies');

    if (!await supportCookieDir.exists()) {
      if (await cacheCookieDir.exists()) {
        debugPrint('🍪 [COOKIE] Migrating cookie storage from cache to support directory');
        await _copyDirectory(cacheCookieDir, supportCookieDir);
      } else {
        await supportCookieDir.create(recursive: true);
      }
    }

    return supportCookieDir;
  }

  Future<void> _copyDirectory(Directory source, Directory destination) async {
    await destination.create(recursive: true);

    await for (final entity in source.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        final relativePath = entity.path.substring(source.path.length + 1);
        final targetFile = File('${destination.path}/$relativePath');
        await targetFile.parent.create(recursive: true);
        await entity.copy(targetFile.path);
      } else if (entity is Directory) {
        final relativePath = entity.path.substring(source.path.length + 1);
        await Directory('${destination.path}/$relativePath').create(recursive: true);
      }
    }
  }
}
