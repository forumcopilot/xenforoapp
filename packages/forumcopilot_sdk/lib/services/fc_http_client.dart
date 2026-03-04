import 'package:dio/dio.dart';
import 'fc_http_overrides.dart';

/// Global HTTP client that automatically injects cookies for all requests
/// This provides a drop-in replacement for the http package with cookie support
class FCHttpClient {
  /// Make an HTTP GET request with automatic cookie injection
  static Future<Response<T>> get<T>(Uri url, {Map<String, String>? headers, ResponseType? responseType, Map<String, dynamic>? queryParameters}) async {
    return FCDioClient.instance.get<T>(
      url.toString(),
      headers: headers,
      responseType: responseType,
      queryParameters: queryParameters,
    );
  }

  /// Make an HTTP HEAD request with automatic cookie injection
  static Future<Response<T>> head<T>(Uri url, {Map<String, String>? headers, Map<String, dynamic>? queryParameters}) async {
    return FCDioClient.instance.request<T>(
      'HEAD',
      url.toString(),
      headers: headers,
      queryParameters: queryParameters,
      responseType: ResponseType.plain,
    );
  }

  /// Make an HTTP POST request with automatic cookie injection
  static Future<Response<T>> post<T>(Uri url, {Map<String, String>? headers, Object? body, Map<String, dynamic>? queryParameters, ResponseType? responseType}) async {
    return FCDioClient.instance.post<T>(
      url.toString(),
      headers: headers,
      data: body,
      queryParameters: queryParameters,
      responseType: responseType,
    );
  }

  /// Make an HTTP PUT request with automatic cookie injection
  static Future<Response<T>> put<T>(Uri url, {Map<String, String>? headers, Object? body, Map<String, dynamic>? queryParameters, ResponseType? responseType}) async {
    return FCDioClient.instance.request<T>(
      'PUT',
      url.toString(),
      headers: headers,
      data: body,
      queryParameters: queryParameters,
      responseType: responseType,
    );
  }

  /// Make an HTTP DELETE request with automatic cookie injection
  static Future<Response<T>> delete<T>(Uri url, {Map<String, String>? headers, Object? body, Map<String, dynamic>? queryParameters, ResponseType? responseType}) async {
    return FCDioClient.instance.request<T>(
      'DELETE',
      url.toString(),
      headers: headers,
      data: body,
      queryParameters: queryParameters,
      responseType: responseType,
    );
  }

  /// Make an HTTP PATCH request with automatic cookie injection
  static Future<Response<T>> patch<T>(Uri url, {Map<String, String>? headers, Object? body, Map<String, dynamic>? queryParameters, ResponseType? responseType}) async {
    return FCDioClient.instance.request<T>(
      'PATCH',
      url.toString(),
      headers: headers,
      data: body,
      queryParameters: queryParameters,
      responseType: responseType,
    );
  }

  /// Make a generic HTTP request with automatic cookie injection
  static Future<Response<T>> request<T>(String method, Uri url, {Map<String, String>? headers, Object? body, Map<String, dynamic>? queryParameters, ResponseType? responseType}) async {
    return FCDioClient.instance.request<T>(
      method,
      url.toString(),
      headers: headers,
      data: body,
      queryParameters: queryParameters,
      responseType: responseType,
    );
  }

  /// Get cookies for a specific URL as a Cookie header string
  static Future<String> getCookiesForUrl(Uri url) async {
    return await FCDioClient.instance.getCookiesForUrl(url);
  }
}
