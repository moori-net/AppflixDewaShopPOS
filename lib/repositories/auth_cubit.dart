import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dewa_app/models/user_data.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import '/api/oauth_api.dart';
import '/models/qr_code_data.dart';
import '/repositories/settings_repo.dart';

class AuthCubit extends Cubit<AuthState> {
  final Logger _log = Logger('AuthCubit');

  AuthCubit() : super(AuthInitial()) {
    _log.fine('AuthCubit created');
  }

  Future<void> qrCodeLogin(QrCodeData qrCodeData) async {
    try {
      emit(AuthLoading());

      final client = await createClientCredentials(
        qrCodeData.appUrl,
        qrCodeData.accessKey,
        qrCodeData.secretAccessKey,
      );

      emit(AuthSuccess(client));
    } on FormatException catch (e, stackTrace) {
      handleFormatException(e, stackTrace);
    } catch (e, stackTrace) {
      handleException(e, stackTrace);
    }
  }

  Future<void> userLogin(UserData userData) async {
    try {
      emit(AuthLoading());

      final client = await createResourceOwnerPassword(
        userData.appUrl,
        userData.username,
        userData.password,
      );

      emit(AuthSuccess(client));
    } on FormatException catch (e, stackTrace) {
      handleFormatException(e, stackTrace);
    } catch (e, stackTrace) {
      handleException(e, stackTrace);
    }
  }

  Future<void> credentialsLogin(oauth2.Credentials credentials) async {
    try {
      emit(AuthLoading());

      final client = await getClientFromCredentials(credentials);

      emit(AuthSuccess(client));
    } on FormatException catch (e, stackTrace) {
      handleFormatException(e, stackTrace);
    } catch (e, stackTrace) {
      handleException(e, stackTrace);
    }
  }

  Future<void> logout() async {
    _log.fine('logout called');

    await GetIt.I.get<SettingsRepository>().clearCredentials();
    await GetIt.I.get<SettingsRepository>().clearQrCodeData();

    emit(AuthInitial());
  }

  void handleFormatException(
      FormatException e, [
        StackTrace? stackTrace,
      ]) {
    final parsedMessage = _extractReadableOauthError(e.message);
    final authError = _mapFormatExceptionToAuthError(e.message, parsedMessage);

    _log.severe(
      'Login format error: ${parsedMessage.replaceAll('\n', ' ')}',
      e,
      stackTrace,
    );

    emit(
      AuthFailure(
        parsedMessage,
        error: authError,
      ),
    );
  }

  void handleException(
      Object e, [
        StackTrace? stackTrace,
      ]) {
    final message = e.toString();
    final cleanedMessage = message.replaceAll('\n', ' ');

    _log.severe(
      'Login failed: $cleanedMessage',
      e,
      stackTrace,
    );

    emit(
      AuthFailure(
        message,
        error: _mapExceptionToAuthError(message),
      ),
    );
  }

  String _extractReadableOauthError(String message) {
    final jsonPart = _extractJsonObject(message);

    if (jsonPart != null) {
      try {
        final decoded = jsonDecode(jsonPart);

        if (decoded is Map<String, dynamic>) {
          // Dein Serverformat:
          // {
          //   "errors": [
          //     {
          //       "code": "4",
          //       "status": "401",
          //       "title": "Client authentication failed",
          //       "detail": null
          //     }
          //   ]
          // }
          final errors = decoded['errors'];

          if (errors is List && errors.isNotEmpty) {
            return errors.map((error) {
              if (error is Map<String, dynamic>) {
                final status = error['status'];
                final code = error['code'];
                final title = error['title'];
                final detail = error['detail'];

                final parts = <String>[
                  if (title != null) title.toString(),
                  if (detail != null) detail.toString(),
                  if (status != null) 'Status: $status',
                  if (code != null) 'Code: $code',
                ];

                return parts.join(' | ');
              }

              return error.toString();
            }).join('\n');
          }

          // Standard OAuth-Format:
          // {
          //   "error": "invalid_client",
          //   "error_description": "Client authentication failed"
          // }
          final oauthError = decoded['error'];
          final oauthDescription = decoded['error_description'];

          if (oauthError != null || oauthDescription != null) {
            return [
              if (oauthDescription != null) oauthDescription.toString(),
              if (oauthError != null) 'OAuth error: $oauthError',
            ].join(' | ');
          }
        }
      } catch (_) {
        // Wenn JSON doch nicht parsebar ist, unten normale Message nutzen.
      }
    }

    return message;
  }

  String? _extractJsonObject(String message) {
    final startIndex = message.indexOf('{');
    final endIndex = message.lastIndexOf('}');

    if (startIndex == -1 || endIndex == -1 || endIndex <= startIndex) {
      return null;
    }

    return message.substring(startIndex, endIndex + 1);
  }

  AuthError _mapFormatExceptionToAuthError(
      String originalMessage,
      String parsedMessage,
      ) {
    final combined = '$originalMessage $parsedMessage'.toLowerCase();

    if (combined.contains('credentials were incorrect') ||
        combined.contains('invalid_client') ||
        combined.contains('invalid_grant') ||
        combined.contains('client authentication failed') ||
        combined.contains('401')) {
      return AuthError.invalidCredentials;
    }

    if (combined.contains('revoked')) {
      return AuthError.revoked;
    }

    if (combined.contains('404 not found')) {
      return AuthError.invalidUrl;
    }

    if (combined.contains('host lookup') ||
        combined.contains('connection closed') ||
        combined.contains('connection refused') ||
        combined.contains('network') ||
        combined.contains('socketexception')) {
      return AuthError.network;
    }

    return AuthError.unknown;
  }

  AuthError _mapExceptionToAuthError(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('host lookup') ||
        lowerMessage.contains('connection closed') ||
        lowerMessage.contains('connection refused') ||
        lowerMessage.contains('socketexception')) {
      return AuthError.network;
    }

    if (lowerMessage.contains('401') ||
        lowerMessage.contains('invalid_client') ||
        lowerMessage.contains('invalid_grant') ||
        lowerMessage.contains('client authentication failed') ||
        lowerMessage.contains('credentials were incorrect')) {
      return AuthError.invalidCredentials;
    }

    if (lowerMessage.contains('404 not found')) {
      return AuthError.invalidUrl;
    }

    if (lowerMessage.contains('revoked')) {
      return AuthError.revoked;
    }

    return AuthError.unknown;
  }
}

enum AuthError {
  invalidCredentials,
  invalidUrl,
  network,
  unknown,
  revoked,
}

class AuthFailure extends AuthState {
  final String message;
  final AuthError error;

  AuthFailure(
      this.message, {
        this.error = AuthError.unknown,
      }) : super(authenticated: false);
}

class AuthInitial extends AuthState {
  AuthInitial() : super(authenticated: false);
}

class AuthLoading extends AuthState {
  AuthLoading() : super(authenticated: false, loading: true);
}

abstract class AuthState {
  final oauth2.Client? client;
  final bool authenticated;
  final bool loading;

  AuthState({
    this.client,
    this.authenticated = false,
    this.loading = false,
  });

  Map<String, dynamic> toJson() => {
    'client': client,
    'authenticated': authenticated,
    'loading': loading,
  };

  @override
  String toString() {
    return 'AuthState(${toJson()})';
  }
}

class AuthSuccess extends AuthState {
  AuthSuccess(oauth2.Client client)
      : super(
    authenticated: true,
    client: client,
  );
}
