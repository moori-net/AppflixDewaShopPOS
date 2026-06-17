import 'dart:convert';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:logging/logging.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

import '/models/printer_settings.dart';
import '/models/qr_code_data.dart';
import '/models/user_data.dart';

class SettingsRepository {
  final Logger _log = Logger('SettingsRepository');
  SharedPreferences? _preferences;

  SettingsRepository([SharedPreferences? preferences]) {
    if (preferences != null) {
      _preferences = preferences;
    } else {
      SharedPreferences.getInstance().then((value) => _preferences = value);
    }
  }

  String get appUrl => _preferences?.getString('app_url') ?? '';

  set appUrl(String appUrl) {
    _log.info('setting app_url to: $appUrl');
    _preferences?.setString('app_url', appUrl);
  }

  QrCodeData? get qrCodeData =>
      _preferences!.containsKey('qr_code_data')
          ? QrCodeData.fromJson(
          json.decode(_preferences!.getString('qr_code_data')!))
          : null;

  set qrCodeData(QrCodeData? qrCodeData) {
    if (qrCodeData == null) {
      _log.info('setting qr_code_data to null');
      _preferences?.remove('qr_code_data');
      _preferences?.remove('shop_id');
    } else {
      _log.info('setting qr_code_data to: ${qrCodeData.toJson()}');
      _preferences?.setString('qr_code_data', json.encode(qrCodeData.toJson()));
      _preferences?.setString('shop_id', qrCodeData.shopId);
      _preferences?.setString('app_url', qrCodeData.appUrl);
      /// Clear user_data because qr_code_data is set
      clearUserData();
      clearCredentials();
    }
  }

  UserData? get userData =>
      _preferences!.containsKey('user_data')
          ? UserData.fromJson(json.decode(_preferences!.getString('user_data')!))
          : null;

  set userData(UserData? userData) {
    if (userData == null) {
      _log.info('setting user_data to null');
      _preferences?.remove('user_data');
      _preferences?.remove('shop_id');
    } else {
      _log.info('setting user_data to: ${userData.toJson()}');
      _preferences?.setString('user_data', json.encode(userData.toJson()));
      _preferences?.setString('app_url', userData.appUrl);
      /// Clear qr_code_data because user_data is set
      clearQrCodeData();
    }
  }

  oauth2.Credentials? get credentials =>
      _preferences!.containsKey('credentials')
          ? oauth2.Credentials.fromJson(_preferences!.getString('credentials')!)
          : null;

  set credentials(oauth2.Credentials? credentials) {
    if (credentials == null) {
      _log.info('setting credentials to null');
      _preferences?.remove('credentials');
    } else {
      _log.info('setting credentials to: ${credentials.toJson()}');
      _preferences?.setString('credentials', credentials.toJson());
      /// Clear qr_code_data because credentials is set
      clearQrCodeData();
      clearUserData();
    }
  }

  BluetoothDevice get printer => BluetoothDevice(
        _preferences?.getString('printer_name'),
        _preferences?.getString('printer_address'),
      );

  set printer(BluetoothDevice printer) {
    _log.info('setting printer to: $printer');
    _preferences?.setString('printer_name', printer.name!);
    _preferences?.setString('printer_address', printer.address!);
  }

  PrinterSettings? get printerSettings =>
      _preferences!.containsKey('printer_settings')
          ? PrinterSettings.fromJson(
              json.decode(_preferences!.getString('printer_settings')!))
          : null;

  set printerSettings(PrinterSettings? settings) {
    _log.info('setting printer_settings to: $settings');
    _preferences?.setString(
        'printer_settings', json.encode(settings!.toJson()));
  }

  String? get shopId => _preferences?.getString('shop_id');

  set shopId(String? value) {
    _log.info('setting shop_id to: $value');
    if (value == null) {
      _preferences?.remove('shop_id');
    } else {
      _preferences?.setString('shop_id', value);
    }
  }

  bool get showOnboarding => _preferences?.getBool('show_onboarding') ?? true;

  set showOnboarding(bool value) {
    _log.info('setting show_onboarding to: $value');
    _preferences?.setBool('show_onboarding', value);
  }

  ThemeMode get themeMode =>
      ThemeMode.values[_preferences?.getInt('theme_mode') ?? 0];

  set themeMode(ThemeMode themeMode) {
    _log.info('setting theme mode: $themeMode');
    _preferences?.setInt('theme_mode', themeMode.index);
  }

  Future<void> clear() async {
    _log.info('clearing all preferences');
    await _preferences?.clear();
  }

  Future<void> clearCredentials() async {
    _log.info('clearing credentials');
    await _preferences?.remove('credentials');
  }

  Future<void> clearQrCodeData() async {
    _log.info('clearing qr_code_data');
    await _preferences?.remove('qr_code_data');
  }

  Future<void> clearUserData() async {
    _log.info('clearing user_data');
    await _preferences?.remove('user_data');
  }

  static Future<SettingsRepository> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SettingsRepository(prefs);
  }
}
