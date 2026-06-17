import 'dart:async';

import 'package:dewa_app/models/user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:get_it/get_it.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

import '/repositories/settings_repo.dart';
import '/widgets/scanner_error_widget.dart';
import '/repositories/auth_cubit.dart';
import '/api/deliveryware_service.dart';
import '/repositories/deliveryware_repository.dart';
import '/models/qr_code_data.dart';
import '../environment_config.dart';

@Deprecated('Login and QR Pages are split now')
class LoginPageQr extends StatefulWidget {
  const LoginPageQr({Key? key}) : super(key: key);

  @override
  State<LoginPageQr> createState() => _LoginPageQrState();
}

class _LoginPageQrState extends State<LoginPageQr> with SingleTickerProviderStateMixin {
  /// will be set in didChangeDependencies()
  late final SettingsRepository _settings;

  /// will be set in initState()
  StreamSubscription<AuthState>? authListener;
  late final AuthCubit authCubit;

  /// Login form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _rememberLogin = true;
  bool _passwordVisible = false;

  /// Just show form and scanner if completely logged out
  bool _showScanner = false;

  /// Can be set by qr code data or user data
  String _appUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
            icon: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          )
        ],
      ),
      body: !_showScanner
          ? const Center(child: CircularProgressIndicator())
          : Builder(
              builder: (context) {
                return Stack(
                  children: [
                    MobileScanner(
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, child) {
                        return ScannerErrorWidget(error: error);
                      },
                      onDetect: _onSubmitQrCode,
                    ),
                    ListView(
                      padding: const EdgeInsets.all(24.0),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                          child: Text(
                            'Login',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Column(children: [
                            TextFormField(
                              initialValue: _appUrl,
                              onChanged: (value) => _appUrl = value,
                              decoration: const InputDecoration(
                                labelText: 'App URL',
                              ),
                              validator: (String? value) => value?.isNotEmpty ?? false
                                  ? null
                                  : 'https://dewashop.de',
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              initialValue: _username,
                              onChanged: (value) => _username = value,
                              decoration: const InputDecoration(
                                labelText: 'Benutzername',
                              ),
                              validator: (String? value) => value?.isNotEmpty ?? false
                                  ? null
                                  : 'Bitte geben Sie einen Benutzernamen ein',
                            ),
                            const SizedBox(height: 16.0),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                TextFormField(
                                  initialValue: _password,
                                  onChanged: (value) => _password = value,
                                  obscureText: !_passwordVisible,
                                  decoration:
                                  const InputDecoration(labelText: 'Passwort'),
                                  validator: (String? value) =>
                                  value?.isNotEmpty ?? false
                                      ? null
                                      : 'Bitte geben Sie ein Passwort ein',
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: InkWell(
                                      onTap: _onTogglePasswordVisibility,
                                      borderRadius: BorderRadius.circular(24.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          _passwordVisible
                                              ? Icons.remove_red_eye_rounded
                                              : Icons.remove_red_eye_outlined,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          size: 24.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),
                        const SizedBox(height: 16.0),
                        CheckboxListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          visualDensity: VisualDensity.compact,
                          value: _rememberLogin,
                          onChanged: (value) =>
                              setState(() => _rememberLogin = value ?? false),
                          title: const Text('Login merken'),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: _onSubmitUser,
                              child: const Text('Anmelden'),
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 16.0
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
    );
  }

  @override
  void didChangeDependencies() {
    if (GetIt.instance.isRegistered<SettingsRepository>()) {
      _settings = GetIt.instance<SettingsRepository>();
      _appUrl = _settings.appUrl;

      /// Show or hide stuff
      final qrCodeData = _settings.qrCodeData;
      final credentials = _settings.credentials;
      if (qrCodeData == null && credentials == null) {
        setState(() => _showScanner = true);
      } else {
        setState(() => _showScanner = false);
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
        if (_rememberLogin && event.client!.credentials.refreshToken != null) {
          _settings.credentials = event.client!.credentials;
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

  void _onSubmitQrCode(capture) {
    /// Build QR code data model and cast login
    final qrCodeData = QrCodeData.fromRawValue(capture.barcodes.first.rawValue.toString());
    _settings.qrCodeData = qrCodeData;
    authCubit.qrCodeLogin(qrCodeData);
  }

  Future<void> _onSubmitUser() async {
    /// Build user data model and cast login
    if (formKey.currentState?.validate() ?? false) {
      final userData = UserData(
        appUrl: _appUrl,
        username: _username,
        password: _password,
        rememberLogin: _rememberLogin,
      );

      authCubit.userLogin(userData);
    }
  }

  void _onTogglePasswordVisibility() {
    setState(() => _passwordVisible = !_passwordVisible);
  }

  Future<void> _retryLogin(final int seconds) async {
    /// Pause x seconds
    await Future.delayed(Duration(seconds: seconds));

    /// Get models from settings
    final qrCodeData = _settings.qrCodeData;
    final credentials = _settings.credentials;

    /// TODO: Restore credentials login
    if (qrCodeData != null) {
      /// 1st try login with QR code data
      authCubit.qrCodeLogin(qrCodeData);
      _appUrl = qrCodeData.appUrl;
    } else if (credentials != null) {
      /// 2nd try login credentials
      authCubit.credentialsLogin(credentials);
    } else {
      /// Show login form and/or scanner
      setState(() => _showScanner = true);
    }
  }

  Future<void> _setupApi(oauth2.Client client) async {
    if (_appUrl.isEmpty) {
      /// Something went wrong, restart app
      Phoenix.rebirth(context);
      return;
    }

    /// Always remember appUrl
    _settings.appUrl = _appUrl;

    final chopper = ChopperClient(
      client: client,
      baseUrl: Uri.tryParse(_appUrl),
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
