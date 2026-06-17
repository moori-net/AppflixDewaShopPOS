import 'package:chopper/chopper.dart';

class EnvironmentConfig {
  static const bool debug = false;
  static const Level chopperLogLevel = debug ? Level.body : Level.none;
  static const int logLevel = 0;
  static const int heartbeatTimer = 60;
  static const int refreshTimer = 30;
  static const String liveVersion = '0fa91ce3e96a4bc2be4bd9ce752c3425';
  static const String currency = 'b7d2554b0ce847cd82f3ac9bd1c0dfca';
  static const String storageDateTimeFormat = 'Y-m-d H:i:s.v';
}
