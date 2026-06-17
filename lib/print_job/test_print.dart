import 'package:dewa_app/models/printer_settings.dart';

import '/models/printer_enums.dart';
import 'print_job.dart';

class TestPrint extends PrintJob {
  @override
  Future<bool> print() async {
    final image = await imageBytes();
    final charset = settings.printerSettings?.charset ?? 'UTF-8';

    try {
      await connectPrinter((isConnected) {
        if (isConnected == true) {
          bluetooth.printNewLine();

          bluetooth.printCustom("TEST CHARSETS", Size.boldMedium.val, Align.center.val);
          bluetooth.printNewLine();
          PrinterSettings.charsets().forEach((charset) {
            bluetooth.printLeftRight(charset, 'čĆžŽšŠščđÄäÖöß€@', Size.bold.val, charset: charset);
          });
          bluetooth.printNewLine();
          /// Logo image
          if (image != null) {
            bluetooth.printImageBytes(image);
            bluetooth.printNewLine();
          }
          bluetooth.printLeftRight("LEFT", "RIGHT", Size.medium.val);
          bluetooth.printLeftRight("LEFT", "RIGHT", Size.bold.val);
          bluetooth.printLeftRight("LEFT", "RIGHT", Size.bold.val, format: "%-15s %15s %n"); //15 is number off character from left or right
          bluetooth.printNewLine();
          bluetooth.printLeftRight("LEFT", "RIGHT", Size.boldMedium.val);
          bluetooth.printLeftRight("LEFT", "RIGHT", Size.boldLarge.val);
          bluetooth.printLeftRight("LEFT", "RIGHT", Size.extraLarge.val);
          bluetooth.printNewLine();
          bluetooth.print3Column("Col1", "Col2", "Col3", Size.bold.val);
          bluetooth.print3Column("Col1", "Col2", "Col3", Size.bold.val, format: "%-10s %10s %10s %n"); //10 is number off character from left center and right
          bluetooth.printNewLine();
          bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", Size.bold.val);
          bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", Size.bold.val, format: "%-8s %7s %7s %7s %n");
          bluetooth.printNewLine();
          bluetooth.printCustom("Body left", Size.bold.val, Align.left.val);
          bluetooth.printCustom("Body right", Size.medium.val, Align.right.val);
          bluetooth.printNewLine();
          bluetooth.printCustom("Thank You", Size.bold.val, Align.center.val);
          bluetooth.printNewLine();
          bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, Align.center.val);
          bluetooth.printNewLine();
          bluetooth.printNewLine();
          bluetooth.paperCut();
        }
      });
    } catch (e) {
      return false;
    }

    return true;
  }
}
