import 'package:dewa_app/models/shopware/attributes/state_machine_state.dart';
import 'package:flutter/foundation.dart';

import '/models/full_order.dart';
import '/models/printer_enums.dart';
import '/models/shopware/attributes/dewa_shop.dart';
import '/models/shopware/attributes/shipping_method.dart';
import '/util.dart';
import 'print_job.dart';

@Deprecated('Check if await is mandatory')
class BillPrintJob extends PrintJob {
  final FullOrder order;
  final DewaShop shop;

  BillPrintJob(this.order, this.shop);

  @override
  Future<bool> print() async {
    //image max 300px X 300px

    final image = await imageBytes();
    final charset = settings.printerSettings?.charset ?? 'UTF-8';
    final propertyLabels = settings.printerSettings?.printPropertyLabels;

    try {
      await connectPrinter((isConnected) async {
        if (isConnected == true) {
          debugPrint('connected printer, printing bill');

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
                '${shop.street}${shop.streetNumber != null ? " ${shop.streetNumber}" : ""}, ${shop.zipCode != null ? "${shop.zipCode} " : ""}${shop.city}',
                Size.medium.val,
                Align.center.val,
                charset: charset);
            await bluetooth.printCustom(
                'Tel.: ${shop.phoneNumber}', Size.medium.val, Align.center.val,
                charset: charset);
            await bluetooth.printNewLine();
          }

          /// Order Number
          if (settings.printerSettings?.printOrderId ?? true) {
            await bluetooth.printCustom(
                order.order!.orderNumber, Size.boldLarge.val, Align.center.val);
            await bluetooth.printNewLine();
          }

          /// Order Date
          await bluetooth.printCustom(
              '${order.dewaShopOrder!.createdAt!.toLocal().dateFormat} ${order.dewaShopOrder!.createdAt!.toLocal().timeFormat}',
              Size.medium.val,
              Align.center.val);

          /// Order Type
          await bluetooth.printCustom(
              order.shippingMethod!.type == ShippingMethodType.delivery
                  ? 'Lieferung'
                  : 'Abholung',
              Size.boldLarge.val,
              Align.center.val,
              charset: charset);
          await bluetooth.printCustom(
              'Bestätigte Zeit: ${order.dewaShopOrder!.desiredTime!.toLocal().timeFormat}',
              Size.boldLarge.val,
              Align.center.val,
              charset: charset);
          await bluetooth.printNewLine();

          /// customer info
          if (settings.printerSettings?.printCustomerDetails ?? true) {
            await bluetooth.printCustom(
                '${order.orderAddress?.firstName ?? order.orderCustomer!.firstName} ${order.orderAddress?.lastName ?? order.orderCustomer!.lastName}',
                Size.bold.val,
                Align.left.val,
                charset: charset);
            if ((order.orderAddress?.company ?? order.orderCustomer?.company) !=
                null) {
              await bluetooth.printCustom(
                  order.orderAddress?.company ?? order.orderCustomer!.company!,
                  Size.bold.val,
                  Align.left.val,
                  charset: charset);
            }
            await bluetooth.printCustom(
                order.orderAddress!.street ?? 'Keine Angabe',
                Size.medium.val,
                Align.left.val,
                charset: charset);
            await bluetooth.printCustom(
                '${order.orderAddress!.zipcode} ${order.orderAddress!.city}',
                Size.medium.val,
                Align.left.val,
                charset: charset);

            String? phone = order.orderCustomer!.phoneNumber ??
                order.orderAddress!.phoneNumber;
            if (phone != null) {
              await bluetooth.printCustom(
                  'Tel: $phone', Size.medium.val, Align.left.val);
            }
            await bluetooth.printNewLine();
          }

          /// Order Items
          for (var item in order.orderLineItems) {
            final indentation = ' ' * (4 - (item.quantity.toString().length + 1));

            await bluetooth.printCustom(
                '${item.quantity}x$indentation${item.label}',
                Size.medium.val,
                Align.left.val,
                charset: charset);

            for (var payloadItem in item.payload?.dewaShop ?? []) {
              if (propertyLabels == true) {
                await bluetooth.printCustom(
                    '    ${payloadItem.name}:${payloadItem.value.join(",")}',
                    Size.medium.val,
                    Align.left.val,
                    charset: charset);
              } else {
                await bluetooth.printCustom(
                    '    ${payloadItem.value.join(",")}',
                    Size.medium.val,
                    Align.left.val,
                    charset: charset);
              }
            }

            await bluetooth.printLeftRight(
                '',
                item.totalPrice != null
                    ? formatPrice(item.totalPrice!)
                    : 'N.A.',
                Size.medium.val,
                charset: charset);
          }

          await bluetooth.printNewLine();

          /// Order Summary
          if ((order.order?.shippingCosts?.totalPrice ?? 0.0) > 0.0) {
            await bluetooth.printLeftRight(
                'Lieferkosten',
                formatPrice(order.order?.shippingCosts?.totalPrice ?? 0.0),
                Size.medium.val,
                charset: charset);
          }
          await bluetooth.printLeftRight(
              'Gesamtkosten',
              formatPrice(order.order?.price?.totalPrice ?? 0.0),
              Size.medium.val,
              charset: charset);
          await bluetooth.printLeftRight(
              'Davon Steuer',
              formatPrice((order.order!.price?.calculatedTaxes ?? [])
                  .map((e) => e.tax)
                  .reduce((value, element) => value + element)),
              Size.medium.val,
              charset: charset);
          await bluetooth.printNewLine();

          /// Order Payment Info
          await bluetooth.printCustom(
            'Zahlungsmethode: ${order.paymentMethod?.name}',
            Size.medium.val,
            Align.left.val,
          );
          await bluetooth.printCustom(
              order.transactionState!.state == OrderState.cancelled
                  ? 'Bestellung wurde storniert'
                  : (order.paymentMethod?.afterOrderEnabled ?? false) &&
                  order.transactionState!.state != OrderState.paid
                  ? 'Barzahlung vor Ort'
                  : order.transactionState!.state == OrderState.paid
                  ? 'Bestellung wurde bezahlt'
                  : 'Bestellung wurde nicht bezahlt',
              Size.boldLarge.val,
              Align.center.val,
              charset: charset);

          /// order Notes
          await bluetooth.printNewLine();
          await bluetooth.printCustom(
              'Anmerkungen: ${order.dewaShopOrder?.comment ?? 'Keine'}',
              Size.medium.val,
              Align.left.val,
              charset: charset);
          await bluetooth.printNewLine();

          /// No bill
          await bluetooth.printCustom(
              'Dies ist keine Rechnung', Size.bold.val, Align.center.val);

          /// QR Code
          if (settings.printerSettings?.printQrCode ?? true) {
            await bluetooth.printQRcode(
                order.order!.orderNumber, 200, 200, Align.center.val);
            await bluetooth.printNewLine();
          }

          /// End of paper
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
          await bluetooth.printNewLine();
          await bluetooth.paperCut();
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
