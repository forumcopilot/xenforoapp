import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

extension RequestOptionsExtension on RequestOptions {
  WebUri get webUri => WebUri.uri(uri);

  Map<String, String> get headersStringMap {
    Map<String, String> headers = {};

    for (final header in headers.entries) {
      headers[header.key] = header.value.toString();
    }

    if (contentType != null) {
      headers[Headers.contentTypeHeader] = contentType.toString();
    }

    return headers;
  }

  Future<Uint8List?> toBytes() async {
    if (data is FormData) {
      return Uint8List.fromList(await (data as FormData).finalize().fold<List<int>>([], (a, b) => a + b));
    } else if (data is String) {
      return utf8.encode(data);
    } else if (Transformer.isJsonMimeType(contentType)) {
      return utf8.encode(jsonEncode(data));
    } else if (data is Map<String, dynamic>) {
      return utf8.encode(Transformer.urlEncodeMap(data));
    }

    return null;
  }

  InAppWebViewSettings getWebViewSettings() {
    return InAppWebViewSettings(
      userAgent: headers['user-agent'] as String?,
      clearCache: true,
      clearSessionCache: true,
      transparentBackground: true,
      useShouldOverrideUrlLoading: true,
      useOnLoadResource: false,
    );
  }

  Future<URLRequest> getURLRequest() async {
    return URLRequest(
      url: webUri,
      mainDocumentURL: webUri,
      method: method,
      headers: headersStringMap,
      body: await toBytes(),
    );
  }
}
