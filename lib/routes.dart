import 'package:flutter/widgets.dart';

import 'pages/history_page/history_page.dart';
import 'pages/login_page.dart';
import 'pages/qr_scanner_page.dart';
import 'pages/orders_page/orders_page.dart';
import 'pages/printer_settings/printer_settings_page.dart';
import 'pages/settings_page.dart';

final Map<String, Widget Function(BuildContext)> routes = {
  '/login': (BuildContext context) => const LoginPage(),
  '/qr-scanner': (BuildContext context) => const QrScannerPage(),
  '/orders': (BuildContext context) => const OrdersPage(),
  '/settings': (BuildContext context) => const SettingsPage(),
  '/printer-settings': (BuildContext context) => const PrinterSettingsPage(),
  '/history': (BuildContext context) => const HistoryPage(),
};
