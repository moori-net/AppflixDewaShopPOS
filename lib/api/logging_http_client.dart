import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../environment_config.dart';

class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Logger _log = Logger('HTTP');

  static int _nextRequestId = 1;

  bool get _debug => EnvironmentConfig.debug == true;

  LoggingHttpClient([http.Client? inner]) : _inner = inner ?? http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final requestId = _nextRequestId++;
    final stopwatch = Stopwatch()..start();

    final bodyBytes = request is http.Request ? request.bodyBytes : null;
    final requestBody = bodyBytes == null
        ? null
        : utf8.decode(bodyBytes, allowMalformed: true);

    final copiedRequest = _copyRequest(request, bodyBytes);

    if (_debug) {
      _log.info('[$requestId] --> ${request.method} ${request.url}');
      _log.info(
        '[$requestId] Request headers: ${_sanitizeHeaders(request.headers)}',
      );

      if (requestBody != null && requestBody.isNotEmpty) {
        _log.info('[$requestId] Request body: ${_sanitizeBody(requestBody)}');
      }
    }

    try {
      final streamedResponse = await _inner.send(copiedRequest);

      if (!_debug) {
        stopwatch.stop();

        return streamedResponse;
      }

      final response = await http.Response.fromStream(streamedResponse);

      stopwatch.stop();

      _log.info(
        '[$requestId] <-- ${response.statusCode} ${request.method} ${request.url} '
            '(${stopwatch.elapsedMilliseconds} ms)',
      );
      _log.info('[$requestId] Response headers: ${response.headers}');
      _log.info('[$requestId] Response body: ${_sanitizeBody(response.body)}');

      return http.StreamedResponse(
        Stream.value(response.bodyBytes),
        response.statusCode,
        contentLength: response.contentLength,
        request: copiedRequest,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );
    } catch (e, stackTrace) {
      stopwatch.stop();

      if (_debug) {
        _log.severe(
          '[$requestId] <-- ERROR ${request.method} ${request.url} '
              '(${stopwatch.elapsedMilliseconds} ms): $e',
          e,
          stackTrace,
        );
      }

      rethrow;
    }
  }

  Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
    final sanitized = Map<String, String>.from(headers);

    for (final key in sanitized.keys.toList()) {
      if (key.toLowerCase() == 'authorization') {
        sanitized[key] = '***';
      }
    }

    return sanitized;
  }

  String _sanitizeBody(String body) {
    var sanitized = body;

    sanitized = sanitized.replaceAll(
      RegExp(r'password=[^&]+'),
      'password=***',
    );

    sanitized = sanitized.replaceAll(
      RegExp(r'client_secret=[^&]+'),
      'client_secret=***',
    );

    sanitized = sanitized.replaceAll(
      RegExp(r'"access_token"\s*:\s*"[^"]+"'),
      '"access_token":"***"',
    );

    sanitized = sanitized.replaceAll(
      RegExp(r'"refresh_token"\s*:\s*"[^"]+"'),
      '"refresh_token":"***"',
    );

    return sanitized;
  }

  http.BaseRequest _copyRequest(
      http.BaseRequest request,
      List<int>? bodyBytes,
      ) {
    if (request is http.Request) {
      final copy = http.Request(request.method, request.url)
        ..headers.addAll(request.headers)
        ..encoding = request.encoding
        ..followRedirects = request.followRedirects
        ..maxRedirects = request.maxRedirects
        ..persistentConnection = request.persistentConnection;

      if (bodyBytes != null) {
        copy.bodyBytes = bodyBytes;
      }

      return copy;
    }

    return request;
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}
