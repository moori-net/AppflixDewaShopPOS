# Appflix_Dewa_App

Android App for DeliveryWare POS and deliverers.

## Requires

SDK 34
org.jetbrains.kotlin:kotlin-stdlib:1.8.22
JDK 17
flutter_windows_3.3.10-stable
gradle 7.4

## Features

### POS App

* Use [QR Code](./deliveryware-paderborn-dw.pdf) to login
* Simple order management via Shopware 6 Admin API
* Print receipes

### Deliverer App

* QR-Code scan from receipes
* GPS Tracking

## Usefull links

* [Shopware Admin API](https://shopware.stoplight.io/)
* [DeliveryWare Admin Dashboard](https://github.com/moorl/AppflixDewaShop/blob/master/src/Resources/app/administration/src/module/dewa-dashboard/page/detail/index.js)
* [DeliveryWare Print Template Example](https://github.com/moorl/AppflixDewaShop/blob/moorl-foundation/src/Storefront/Controller/PrinterController.php)
* [Printer Library](https://github.com/DantSu/ESCPOS-ThermalPrinter-Android)

## Admin Example

* [https://dewashop.de/admin#/login](https://dewashop.de/admin#/login)
* User: `dw`
* PW: `#1ftw`

## Receipe print turnover

* https://github.com/moorl/AppflixDewaShop/blob/master/src/Storefront/Controller/PrinterController.php#L269
