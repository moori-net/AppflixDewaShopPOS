import 'dart:io';
import 'dart:typed_data';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import '/repositories/settings_repo.dart';

///Test printing
abstract class PrintJob {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final SettingsRepository settings = GetIt.I.get<SettingsRepository>();

  Future<bool> print();

  Future<void> connectPrinter(Function(bool?) callback) async {
    final bluetoothOn = (await bluetooth.isOn) ?? false;
    final bluetoothAvailable = (await bluetooth.isAvailable) ?? false;
    if (!bluetoothOn || !bluetoothAvailable) {
      callback(false);
      return;
    }

    // get device from settings and connect
    if (!(await bluetooth.isConnected ?? false)) {
      await bluetooth.connect(settings.printer);
    }

    await bluetooth.isConnected.then(callback);

    return;
  }

  Future<Uint8List?> imageBytes() async {
    ///image from File path
    final baseDir = await getApplicationDocumentsDirectory();
    final imageDir =
        await Directory('${baseDir.path}/title_image').create(recursive: true);
    final imageFiles = imageDir.listSync();

    Uint8List? imageBytesMagic;
    if (imageFiles.isNotEmpty) {
      final imageFile = File(imageFiles.first.uri.toFilePath());
      final imageBytes = imageFile.readAsBytesSync();

      imageBytesMagic = imageBytes.buffer
          .asUint8List(imageBytes.offsetInBytes, imageBytes.lengthInBytes);
    }

    return imageBytesMagic;
  }
}
