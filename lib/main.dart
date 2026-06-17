import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'environment_config.dart';
import 'repositories/auth_cubit.dart';
import 'repositories/settings_repo.dart';
import 'routes.dart';
import 'theme.dart';

void main() async {
  Intl.defaultLocale = 'de_DE';

  if (EnvironmentConfig.debug) {
    runApp(Phoenix(child: DewaApp()));
    startLog();
  } else {
    await SentryFlutter.init(
      (options) {
        options.dsn = 'https://f229b2d8fff9448385c21dbaa8ada8bc@o956017.ingest.sentry.io/4504292876288000';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = .1;
      },
      appRunner: () => runApp(Phoenix(child: DewaApp())),
    );
  }
}

void startLog() async {
  Logger.root.level = Level.FINE; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    final line =
        '${record.loggerName} - ${record.level.name}: ${record.time.toString().split('.').first}: ${record.message}';
    debugPrint(line);
  });
}

class DewaApp extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  DewaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<GlobalKey<NavigatorState>>()) {
      getIt.registerSingleton<GlobalKey<NavigatorState>>(_navigatorKey);
    }

    // Make app fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(),
      lazy: false,
      child: FutureBuilder(
        future: SettingsRepository.getInstance(),
        builder:
            (BuildContext context, AsyncSnapshot<SettingsRepository> snapshot) {
          if (!snapshot.hasData) {
            return Container(color: Colors.white);
          }

          BlocProvider.of<AuthCubit>(context);

          // register freshly loaded settings into a singleton
          if (!getIt.isRegistered<SettingsRepository>() && snapshot.hasData) {
            getIt.registerSingleton<SettingsRepository>(snapshot.data!);
          }

          return MaterialApp(
            title: 'DeliveryWare App',
            debugShowCheckedModeBanner: EnvironmentConfig.debug,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('de', ''),
              Locale('en', ''),
            ],
            navigatorObservers: [SentryNavigatorObserver()],
            navigatorKey: _navigatorKey,
            theme: lightTheme,
            // Same definition for the light theme, but using FlexThemeData.dark().
            darkTheme: darkTheme,
            // Use the above dark or light theme based on active themeMode.
            themeMode: snapshot.data?.themeMode ?? ThemeMode.system,
            routes: routes,
            initialRoute: '/login',
          );
        },
      ),
    );
  }
}
