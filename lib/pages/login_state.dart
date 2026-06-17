import 'dart:async';

import 'package:dewa_app/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import '/repositories/settings_repo.dart';
import '/repositories/auth_cubit.dart';
import '/api/deliveryware_service.dart';
import '/repositories/deliveryware_repository.dart';
import '/models/qr_code_data.dart';
import '../environment_config.dart';

abstract class LoginState<T extends StatefulWidget> extends State<T> with SingleTickerProviderStateMixin {
  late final SettingsRepository settings;

  StreamSubscription<AuthState>? authListener;
  late final AuthCubit authCubit;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';
  bool rememberLogin = true;
  bool passwordVisible = false;
  bool showScanner = false;
  String appUrl = '';

  @override
  void didChangeDependencies() {
    if (GetIt.instance.isRegistered<SettingsRepository>()) {
      settings = GetIt.instance<SettingsRepository>();
      appUrl = settings.appUrl;

      /// Show or hide stuff
      final qrCodeData = settings.qrCodeData;
      final credentials = settings.credentials;
      if (qrCodeData == null && credentials == null) {
        setState(() => showScanner = true);
      } else {
        setState(() => showScanner = false);
        _retryLogin(0);
      }
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    authListener?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    authCubit = BlocProvider.of<AuthCubit>(context);

    /// Listen for authentication changes and redirect to orders if successful
    authListener = authCubit.stream.listen((event) async {
      if (event.authenticated) {
        await _setupApi(event.client!);

        if (!mounted) return;

        /// save credentials if remember login is checked
        if (rememberLogin && event.client!.credentials.refreshToken != null) {
          settings.credentials = event.client!.credentials;
        }

        authListener?.cancel();

        Navigator.of(context).pushReplacementNamed('/orders');
      } else if (event is AuthFailure) {
        var msg = '';

        switch (event.error) {
          case AuthError.invalidCredentials:
            authCubit.logout();
            msg = 'Falsche Zugangsdaten';
            break;
          case AuthError.invalidUrl:
            authCubit.logout();
            msg = 'Falsche URL';
            break;
          case AuthError.network:
            msg = 'Keine Internetverbindung';
            _retryLogin(10);
            break;
          case AuthError.revoked:
            authCubit.logout();
            msg = 'Token wurde nicht akzeptiert';
            _retryLogin(10);
            break;
          default:
            msg = event.message;
            break;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    super.initState();
  }

  void onSubmitQrCode(capture) {
    /// Build QR code data model and cast login
    final qrCodeData = QrCodeData.fromRawValue(capture.barcodes.first.rawValue.toString());
    settings.qrCodeData = qrCodeData;
    authCubit.qrCodeLogin(qrCodeData);
  }

  Future<void> onSubmitUser() async {
    /// Build user data model and cast login
    if (formKey.currentState?.validate() ?? false) {
      final userData = UserData(
        appUrl: appUrl,
        username: username,
        password: password,
        rememberLogin: rememberLogin,
      );

      authCubit.userLogin(userData);
    }
  }

  void onTogglePasswordVisibility() {
    setState(() => passwordVisible = !passwordVisible);
  }

  Future<void> _retryLogin(final int seconds) async {
    /// Pause x seconds
    await Future.delayed(Duration(seconds: seconds));

    /// Get models from settings
    final qrCodeData = settings.qrCodeData;
    final credentials = settings.credentials;

    /// TODO: Restore credentials login
    if (qrCodeData != null) {
      /// 1st try login with QR code data
      authCubit.qrCodeLogin(qrCodeData);
      appUrl = qrCodeData.appUrl;
    } else if (credentials != null) {
      /// 2nd try login credentials
      authCubit.credentialsLogin(credentials);
    } else {
      /// Show login form and/or scanner
      setState(() => showScanner = true);
    }
  }

  Future<void> _setupApi(oauth2.Client client) async {
    if (appUrl.isEmpty) {
      /// Something went wrong, restart app
      Phoenix.rebirth(context);
      return;
    }

    /// Always remember appUrl
    settings.appUrl = appUrl;

    final chopper = ChopperClient(
      client: client,
      baseUrl: Uri.tryParse(appUrl),
      services: [
        DeliverywareService.create()
      ],
      interceptors: [
        HttpLoggingInterceptor(level: EnvironmentConfig.chopperLogLevel),
        const HeadersInterceptor({
          'Accept-Charset': 'utf-8',
          'Content-Type': 'application/json',
          'Accept': 'application/vnd.api+json',
        }),
      ],
    );

    /// Get a reference to the client-bound service instance...
    final dishesApi = chopper.getService<DeliverywareService>();

    final getIt = GetIt.instance;
    if (!getIt.isRegistered<DeliverywareRepository>()) {
      getIt.registerSingleton<DeliverywareRepository>(
          DeliverywareRepository(dishesApi));
    } else {
      await getIt.unregister(instance: getIt<DeliverywareRepository>());
      getIt.registerSingleton<DeliverywareRepository>(
          DeliverywareRepository(dishesApi));
    }
  }
}
