import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:open_settings/open_settings.dart';
import 'package:path_provider/path_provider.dart';

import '/models/printer_settings.dart';
import '/print_job/test_print.dart';
import '/repositories/settings_repo.dart';

class PrinterSettingsPage extends StatefulWidget {
  const PrinterSettingsPage({super.key});

  @override
  State<PrinterSettingsPage> createState() => _PrinterSettingsPageState();
}

class _PrinterSettingsPageState extends State<PrinterSettingsPage> {
  final SettingsRepository _settings = GetIt.I.get<SettingsRepository>();
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  late PrinterSettings _printerSettings;

  bool _hasNewTitleImage = false;

  Widget get _imageButton => FutureBuilder(
        future: _hasTitleImage(),
        builder: (context, AsyncSnapshot<String?> snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? snapshot.data == null
                    ? const Text('Datei auswählen')
                    : Text(snapshot.data!,
                        maxLines: 1, overflow: TextOverflow.ellipsis)
                : const Text('Datei auswählen'),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Druckereinstellungen'),
      ),
      body: ListView(
        children: [
          ListTile(
              title: Text(
            'Rechnung',
            style: Theme.of(context).textTheme.titleLarge,
          )),
          ListTile(
            title: const Text('Titelbild'),
            trailing: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 196.0),
              child: TextButton(
                  onPressed: _onSelectTitleImage,
                  child: _hasNewTitleImage ? _imageButton : _imageButton),
            ),
          ),
          CheckboxListTile(
            title: const Text('Restaurantdetails drucken'),
            value: _printerSettings.printRestaurantDetails,
            onChanged: _onPrintRestaurantDetailsChanged,
          ),
          CheckboxListTile(
            title: const Text('Kundendetails drucken'),
            value: _printerSettings.printCustomerDetails,
            onChanged: _onPrintCustomerDetailsChanged,
          ),
          CheckboxListTile(
            title: const Text('Bestellnummer drucken'),
            value: _printerSettings.printOrderId,
            onChanged: _onPrintOrderIdChanged,
          ),
          CheckboxListTile(
            title: const Text('QR Code drucken'),
            value: _printerSettings.printQrCode,
            onChanged: _onPrintQrCodeChanged,
          ),
          CheckboxListTile(
            title: const Text('Labels drucken'),
            value: _printerSettings.printPropertyLabels,
            onChanged: _onPrintPropertyLabelsChanged,
          ),
          const Divider(),
          ListTile(
              title: Text(
            'Drucker',
            style: Theme.of(context).textTheme.titleLarge,
          )),
          ListTile(
            title: const Text('Drucker'),
            trailing: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 196.0),
              child: FutureBuilder(
                future: bluetooth.getBondedDevices(),
                builder:
                    (context, AsyncSnapshot<List<BluetoothDevice>> snapshot) =>
                        DropdownButton<BluetoothDevice>(
                  hint: const Text('Drucker auswählen'),
                  value: _settings.printer.address != null
                      ? _settings.printer
                      : null,
                  items: [
                    ...(snapshot.data ?? [])
                        .map((e) => DropdownMenuItem<BluetoothDevice>(
                              value: e,
                              child: Text(e.name ?? 'Device'),
                            ))
                  ],
                  onChanged: _onPrinterChanged,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Kodierung'),
            trailing: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 196.0),
              child: DropdownButton<String>(
                hint: const Text('Bitte wählen'),
                value: _printerSettings.charset,
                onChanged: _onCharsetChanged,
                items: PrinterSettings.charsets().map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          ListTile(
            title: const Text('Papiergröße'),
            trailing: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 196.0),
              child: DropdownButton<int>(
                hint: const Text('Bitte wählen'),
                value: _printerSettings.paperSize,
                onChanged: _onPaperSizeChanged,
                items: PrinterSettings.paperSizes().map<DropdownMenuItem<int>>((String value) {
                  int idx = PrinterSettings.paperSizes().indexOf(value);
                  return DropdownMenuItem<int>(
                    value: idx,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
          CheckboxListTile(
            title: const Text('Automatisch drucken'),
            value: _printerSettings.printAutomatically,
            onChanged: _onPrintAutomaticallyChanged,
          ),
          ListTile(
            title: const Text('Anzahl Kopien'),
            trailing: SizedBox(
              width: 128.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => _onChangeCopies(-1),
                      icon: const Icon(Icons.remove_rounded)),
                  Text(_printerSettings.copies.toString()),
                  IconButton(
                      onPressed: () => _onChangeCopies(1),
                      icon: const Icon(Icons.add_rounded))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: _onOpenBluetoothSettings,
              child: const Text('Bluetooth Einstellungen'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _onTestPrinter,
              child: const Text('Testrechnung drucken'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _settings.printerSettings ??= PrinterSettings();

    _printerSettings = _settings.printerSettings!;

    super.initState();
  }

  Future<Directory> _getTitleImageDirectory() async {
    final baseDir = await getApplicationDocumentsDirectory();

    return await Directory('${baseDir.path}/title_image')
        .create(recursive: true);
  }

  Future<String?> _hasTitleImage() async {
    final baseDir = await getApplicationDocumentsDirectory();

    final files = Directory('${baseDir.path}/title_image/').listSync();

    if (files.isEmpty) {
      return null;
    }

    return files.first.path.split('/').last;
  }

  /// callback for saving to settings on changes
  void _onChange() {
    _settings.printerSettings = _printerSettings;
  }

  void _onChangeCopies(int i) {
    if (_printerSettings.copies + i > 0) {
      setState(() => _printerSettings.copies += i);
    }
    _onChange();
  }

  /// delete all files in title image directory
  /// then update state to reload the image select button
  Future<void> _onDeleteTitleImage() {
    setState(() {
      _hasNewTitleImage = !_hasNewTitleImage;
    });
    return _getTitleImageDirectory().then(
        (value) => value.list().forEach((element) => element.deleteSync()));
  }

  Future<void> _onOpenBluetoothSettings() {
    return OpenSettings.openBluetoothSetting();
  }

  void _onPrintAutomaticallyChanged(value) {
    value != null
        ? setState(() => _printerSettings.printAutomatically = value)
        : null;
    _onChange();
  }

  void _onPrintCustomerDetailsChanged(bool? value) {
    value != null
        ? setState(() => _printerSettings.printCustomerDetails = value)
        : null;
    _onChange();
  }

  void _onPrinterChanged(BluetoothDevice? value) {
    if (value == null) return;
    setState(() {
      _settings.printer = value;
    });
  }

  void _onPrintOrderIdChanged(bool? value) {
    value != null
        ? setState(() => _printerSettings.printOrderId = value)
        : null;
    _onChange();
  }

  void _onPrintQrCodeChanged(bool? value) {
    value != null ? setState(() => _printerSettings.printQrCode = value) : null;
    _onChange();
  }

  void _onPrintPropertyLabelsChanged(bool? value) {
    value != null ? setState(() => _printerSettings.printPropertyLabels = value) : null;
    _onChange();
  }

  void _onPaperSizeChanged(int? value) {
    value != null ? setState(() => _printerSettings.paperSize = value) : null;
    _onChange();
  }

  void _onCharsetChanged(String? value) {
    value != null ? setState(() => _printerSettings.charset = value) : null;
    _onChange();
  }

  void _onProfileChanged(String? value) {
    value != null ? setState(() => _printerSettings.profile = value) : null;
    _onChange();
  }

  void _onPrintRestaurantDetailsChanged(value) {
    value != null
        ? setState(() => _printerSettings.printRestaurantDetails = value)
        : null;
    _onChange();
  }

  /// select a new title image
  /// show the old image in a dialog if there is one
  void _onSelectTitleImage() async {
    bool goOn = true;

    String? titleImage = await _hasTitleImage();
    Directory titleImageDir = await _getTitleImageDirectory();

    if (titleImage != null && mounted) {
      goOn = await showDialog<bool?>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Titelbild ersetzen?'),
              content: Image.file(File('${titleImageDir.path}/$titleImage')),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Abbrechen'),
                ),
                TextButton(
                  onPressed: () async {
                    await _onDeleteTitleImage();
                    if (mounted) Navigator.of(context).pop(false);
                  },
                  child: const Text('Löschen'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Ersetzen'),
                ),
              ],
            ),
          ) ??
          false;
    }

    if (goOn) {
      // Pick an image
      final XFile? imageFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imageFile == null) return;

      // Read an image from file.
      img.Image image = img.decodeImage(await imageFile.readAsBytes())!;

      // Resize the image to a thumbnail (maintaining the aspect ratio).
      img.Image resized = img.copyResize(image, width: 300);

      //resized.fillBackground(0xFFFFFFFF);

      final finalImage = img.grayscale(resized);

      // delete the old image
      await _onDeleteTitleImage();

      // write new image
      final baseDir = await _getTitleImageDirectory();
      await File('${baseDir.path}/${imageFile.name.split('.').first}.bmp')
          .writeAsBytes(img.encodeBmp(finalImage));
    }
  }

  void _onTestPrinter() {
    if (_settings.printer.address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kein Drucker ausgewählt'),
        ),
      );
      return;
    }

    TestPrint().print();
  }
}
