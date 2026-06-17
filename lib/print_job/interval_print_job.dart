import 'package:flutter/foundation.dart';

import '/models/full_order.dart';
import '/models/printer_enums.dart';
import '/models/shopware/attributes/dewa_shop.dart';
import '/util.dart';
import 'print_job.dart';

///Test printing
class IntervalPrintJob extends PrintJob {
  final List<FullOrder> orders;
  final DewaShop shop;
  final DateTime? startDate;
  final DateTime? endDate;

  IntervalPrintJob(this.orders, this.shop, {this.startDate, this.endDate});

  @override
  Future<bool> print() async {
    //image max 300px X 300px

    final image = await imageBytes();
    final charset = settings.printerSettings?.charset ?? 'UTF-8';

    try {
      await connectPrinter((isConnected) async {
        if (isConnected == true) {
          /// Logo image
          if (image != null) {
            await bluetooth.printImageBytes(image);
          }
          await bluetooth.printNewLine();

          /// Vendor info
          if (settings.printerSettings?.printRestaurantDetails ?? true) {
            await bluetooth.printCustom(
                shop.name, Size.medium.val, Align.center.val,
                charset: charset);
            await bluetooth.printCustom(
                '${shop.street}${shop.streetNumber != null ? " ${shop.streetNumber}" : ""}, ${shop.zipCode ?? ""} ${shop.city}',
                Size.medium.val,
                Align.center.val,
                charset: charset);
            await bluetooth.printCustom(
                'Tel.: ${shop.phoneNumber}', Size.medium.val, Align.center.val,
                charset: charset);
            await bluetooth.printNewLine();
          }

          /// Print Date
          await bluetooth.printCustom(
              '${DateTime.now().toLocal().dateFormat} ${DateTime.now().toLocal().timeFormat}',
              Size.medium.val,
              Align.center.val);
          await bluetooth.printNewLine();

          /// Order Date Range
          if (startDate != null && endDate != null) {
            await bluetooth.printCustom(
                'Abrechnungszeitraum:', Size.medium.val, Align.center.val);
            await bluetooth.printCustom(
                '${startDate!.toLocal().dateFormat} - ${endDate!.toLocal().dateFormat}',
                Size.medium.val,
                Align.center.val);
          } else {
            await bluetooth.printCustom(
                'Abrechnung für den ${DateTime.now().toLocal().dateFormat}',
                Size.medium.val,
                Align.center.val);
          }
          await bluetooth.printNewLine();
          await bluetooth.printCustom(
            'Bestellungen',
            Size.boldMedium.val,
            Align.left.val,
            charset: charset,
          );

          /// Orders
          for (var order in orders) {
            if (order.orderTransaction?.amount?.totalPrice == null) {
              continue;
            }

            await bluetooth.printCustom(
                '${order.order!.orderNumber} - ${order.order!.orderDateTime.toLocal().dateFormat} ${order.order!.orderDateTime.toLocal().timeFormat}',
                Size.medium.val,
                Align.left.val,
                charset: charset);
            await bluetooth.printCustom(
                '${order.shippingMethod!.name}, ${order.paymentMethod!.name}',
                Size.medium.val,
                Align.left.val,
                charset: charset);
            await bluetooth.printCustom(
                'Brutto: ${formatPrice(order.orderTransaction!.amount!.totalPrice)}',
                Size.medium.val,
                Align.right.val,
                charset: charset);
            if ((order.order!.shippingCosts?.totalPrice ?? 0.0) > 0.0) {
              await bluetooth.printCustom(
                  'Versand: ${formatPrice(order.order!.shippingCosts!.totalPrice)}',
                  Size.medium.val,
                  Align.right.val,
                  charset: charset);
            }

            await bluetooth.printNewLine();
          }

          /// Summary
          final total = orders
              .map((e) => e.orderTransaction!.amount?.totalPrice ?? 0.0)
              .reduce((value, element) => value + element);
          final totalTaxes = orders
              .map((e) => (e.orderTransaction!.amount?.calculatedTaxes ?? [])
                  .map((e) => e.tax)
                  .reduce((value, element) => value + element))
              .reduce((value, element) => value + element);
          final totalShippingCosts = orders
              .map((e) => e.orderDelivery?.shippingCosts?.totalPrice ?? 0.0)
              .reduce((value, element) => value + element);

          await bluetooth.printCustom(
            'Gesamt',
            Size.boldMedium.val,
            Align.left.val,
            charset: charset,
          );
          await bluetooth.printLeftRight(
              'Brutto', formatPrice(total), Size.medium.val,
              charset: charset);
          await bluetooth.printLeftRight(
              'Netto', formatPrice(total - totalTaxes), Size.medium.val,
              charset: charset);
          if (totalShippingCosts > 0) {
            await bluetooth.printLeftRight('Lieferkosten',
                formatPrice(totalShippingCosts), Size.medium.val,
                charset: charset);
          }

          await bluetooth.printCustom('Steuern', Size.bold.val, Align.left.val,
              charset: charset);
          // find unique taxRates on orders and sum up the taxes accordingly
          final Map<int, num> taxRates = {};
          for (var order in orders) {
            for (var tax
                in order.orderTransaction!.amount?.calculatedTaxes ?? []) {
              final taxRate = tax.taxRate.toInt();
              if (!taxRates.containsKey(taxRate)) {
                taxRates.addAll({taxRate: 0.0});
              }
              taxRates[taxRate] = taxRates[taxRate]! + tax.tax;
            }
          }

          await bluetooth.printLeftRight(
              'Gesamt', formatPrice(totalTaxes), Size.medium.val,
              charset: charset);
          for (var taxRate in taxRates.keys) {
            await bluetooth.printLeftRight(
                '$taxRate%', formatPrice(taxRates[taxRate]!), Size.medium.val,
                charset: charset);
          }
          await bluetooth.printNewLine();

          /// End of paper
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();

          return;
        } else {
          debugPrint('No printer connected, throwing error');
          throw Exception();
        }
      });
    } catch (e) {
      return false;
    }

    return true;
  }
}
