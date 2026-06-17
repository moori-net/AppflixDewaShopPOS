import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '/widgets/scanner_error_widget.dart';
import 'login_state.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({Key? key}) : super(key: key);

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends LoginState<QrScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        title: const Text('QR Code Scanner'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            fit: BoxFit.cover,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            onDetect: onSubmitQrCode,
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: const Text('Zum Login zurückkehren'),
            ),
          ),
        ],
      ),
    );
  }
}
