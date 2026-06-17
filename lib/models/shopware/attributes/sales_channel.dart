import 'package:dewa_app/models/shopware/attributes/attributes.dart';

import '../translated.dart';

class SalesChannel extends Attributes {
  final String? accessKey;
  final bool active;
  final String? analyticsId;
  final dynamic configuration;
  final String? countryId;
  final String? currencyId;
  final dynamic customFields;
  final String? customerGroupId;
  final String? footerCategoryId;
  final String? footerCategoryVersionId;
  final String? homeCmsPageId;
  final String? homeCmsPageVersionId;
  final bool homeEnabled;
  final dynamic homeKeywords;
  final dynamic homeMetaDescription;
  final dynamic homeMetaTitle;
  final dynamic homeName;
  final dynamic homeSlotConfig;
  final bool hreflangActive;
  final String? hreflangDefaultDomainId;
  final String? languageId;
  final String? mailHeaderFooterId;
  final bool maintenance;
  final List<dynamic>? maintenanceIpWhitelist;
  final String name;
  final int? navigationCategoryDepth;
  final String? navigationCategoryId;
  final String? navigationCategoryVersionId;
  final String? paymentMethodId;
  final List<dynamic> paymentMethodIds;
  final String? serviceCategoryId;
  final String? serviceCategoryVersionId;
  final String? shippingMethodId;
  final String? shortName;
  final String? taxCalculationType;
  final Translated? translated;
  final String? typeId;

  SalesChannel({
    this.accessKey,
    this.active = false,
    this.analyticsId,
    this.configuration,
    this.countryId,
    this.currencyId,
    this.customFields,
    this.customerGroupId,
    this.footerCategoryId,
    this.footerCategoryVersionId,
    this.homeCmsPageId,
    this.homeCmsPageVersionId,
    this.homeEnabled = false,
    this.homeKeywords,
    this.homeMetaDescription,
    this.homeMetaTitle,
    this.homeName,
    this.homeSlotConfig,
    this.hreflangActive = false,
    this.hreflangDefaultDomainId,
    this.languageId,
    this.mailHeaderFooterId,
    this.maintenance = false,
    this.maintenanceIpWhitelist = const [],
    required this.name,
    this.navigationCategoryDepth,
    this.navigationCategoryId,
    this.navigationCategoryVersionId,
    this.paymentMethodId,
    this.paymentMethodIds = const [],
    this.serviceCategoryId,
    this.serviceCategoryVersionId,
    this.shippingMethodId,
    this.shortName,
    this.taxCalculationType,
    this.translated,
    this.typeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory SalesChannel.fromJson(Map<String, dynamic> json) => SalesChannel(
        accessKey: json['accessKey'],
        active: json['active'],
        analyticsId: json['analyticsId'],
        configuration: json['configuration'],
        countryId: json['countryId'],
        currencyId: json['currencyId'],
        customFields: json['customFields'],
        customerGroupId: json['customerGroupId'],
        footerCategoryId: json['footerCategoryId'],
        footerCategoryVersionId: json['footerCategoryVersionId'],
        homeCmsPageId: json['homeCmsPageId'],
        homeCmsPageVersionId: json['homeCmsPageVersionId'],
        homeEnabled: json['homeEnabled'],
        homeKeywords: json['homeKeywords'],
        homeMetaDescription: json['homeMetaDescription'],
        homeMetaTitle: json['homeMetaTitle'],
        homeName: json['homeName'],
        homeSlotConfig: json['homeSlotConfig'],
        hreflangActive: json['hreflangActive'],
        hreflangDefaultDomainId: json['hreflangDefaultDomainId'],
        languageId: json['languageId'],
        mailHeaderFooterId: json['mailHeaderFooterId'],
        maintenance: json['maintenance'],
        maintenanceIpWhitelist: json['maintenanceIpWhitelist'] != null
            ? json['maintenanceIpWhitelist'] as List<dynamic>
            : const [],
        name: json['name'],
        navigationCategoryDepth: json['navigationCategoryDepth'],
        navigationCategoryId: json['navigationCategoryId'],
        navigationCategoryVersionId: json['navigationCategoryVersionId'],
        paymentMethodId: json['paymentMethodId'],
        paymentMethodIds:
            (json['paymentMethodIds'] as List<dynamic>?) ?? const [],
        serviceCategoryId: json['serviceCategoryId'],
        serviceCategoryVersionId: json['serviceCategoryVersionId'],
        shippingMethodId: json['shippingMethodId'],
        shortName: json['shortName'],
        taxCalculationType: json['taxCalculationType'],
        translated: json['translated'] != null
            ? Translated.fromJson(json['translated'] as Map<String, dynamic>)
            : null,
        typeId: json['typeId'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'accessKey': accessKey,
        'active': active,
        'analyticsId': analyticsId,
        'configuration': configuration,
        'countryId': countryId,
        'currencyId': currencyId,
        'customFields': customFields,
        'customerGroupId': customerGroupId,
        'footerCategoryId': footerCategoryId,
        'footerCategoryVersionId': footerCategoryVersionId,
        'homeCmsPageId': homeCmsPageId,
        'homeCmsPageVersionId': homeCmsPageVersionId,
        'homeEnabled': homeEnabled,
        'homeKeywords': homeKeywords,
        'homeMetaDescription': homeMetaDescription,
        'homeMetaTitle': homeMetaTitle,
        'homeName': homeName,
        'homeSlotConfig': homeSlotConfig,
        'hreflangActive': hreflangActive,
        'hreflangDefaultDomainId': hreflangDefaultDomainId,
        'languageId': languageId,
        'mailHeaderFooterId': mailHeaderFooterId,
        'maintenance': maintenance,
        'maintenanceIpWhitelist': maintenanceIpWhitelist,
        'name': name,
        'navigationCategoryDepth': navigationCategoryDepth,
        'navigationCategoryId': navigationCategoryId,
        'navigationCategoryVersionId': navigationCategoryVersionId,
        'paymentMethodId': paymentMethodId,
        'paymentMethodIds': paymentMethodIds,
        'serviceCategoryId': serviceCategoryId,
        'serviceCategoryVersionId': serviceCategoryVersionId,
        'shippingMethodId': shippingMethodId,
        'shortName': shortName,
        'taxCalculationType': taxCalculationType,
        'translated': translated?.toJson(),
        'typeId': typeId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  @override
  String toString() => 'SalesChannel(${toJson()})';
}
