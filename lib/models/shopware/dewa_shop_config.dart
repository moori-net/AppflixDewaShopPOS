class DewaShopConfig {
  final bool disableOffcanvasCart;
  final int checkoutDateMin;
  final bool checkoutDropdownAsap;
  final String? checkoutDropdownSteps;
  final bool checkoutOpenDeliveryMethods;
  final bool checkoutPhoneNumber;
  final String? checkoutTimepicker;
  final bool orderInvoice;
  final bool orderMail;
  final bool orderPrintJob;
  final List<String> orderWhitelistPaymentMethods;
  final bool posAutoOpen;
  final num? pricePrecision;
  final String? priceRounding;
  final bool registrationFormDewa;
  final bool searchPortalActive;
  final String? searchPortalCategory;
  final String? searchPortalToken;
  final String? searchPortalUrl;
  final String? timezone;
  final bool useMenuAsLandingPage;
  final bool useMenuBadgeFilter;

  DewaShopConfig({
    this.disableOffcanvasCart = false,
    this.checkoutDateMin = 0,
    this.checkoutDropdownAsap = false,
    this.checkoutDropdownSteps,
    this.checkoutOpenDeliveryMethods = false,
    this.checkoutPhoneNumber = false,
    this.checkoutTimepicker,
    this.orderInvoice = false,
    this.orderMail = false,
    this.orderPrintJob = false,
    this.orderWhitelistPaymentMethods = const [],
    this.posAutoOpen = false,
    this.pricePrecision,
    this.priceRounding,
    this.registrationFormDewa = false,
    this.searchPortalActive = false,
    this.searchPortalCategory,
    this.searchPortalToken,
    this.searchPortalUrl,
    this.timezone,
    this.useMenuAsLandingPage = false,
    this.useMenuBadgeFilter = false,
  });

  factory DewaShopConfig.fromJson(Map<String, dynamic> json) {
    return DewaShopConfig(
      /*disableOffcanvasCart: json['AppflixDewaShop.config.disableOffcanvasCart'],
      checkoutDateMin: json['AppflixDewaShop.config.checkoutDateMin'],
      checkoutDropdownAsap: json['AppflixDewaShop.config.checkoutDropdownAsap'],
      checkoutDropdownSteps: json['AppflixDewaShop.config.checkoutDropdownSteps'],
      checkoutOpenDeliveryMethods: json['AppflixDewaShop.config.checkoutOpenDeliveryMethods'],
      checkoutPhoneNumber: json['AppflixDewaShop.config.checkoutPhoneNumber'],
      checkoutTimepicker: json['AppflixDewaShop.config.checkoutTimepicker'],
      orderInvoice: json['AppflixDewaShop.config.orderInvoice'],
      orderMail: json['AppflixDewaShop.config.orderMail'],
      orderPrintJob: json['AppflixDewaShop.config.orderPrintJob'],*/
      orderWhitelistPaymentMethods: List<String>.from(
          json['AppflixDewaShop.config.orderWhitelistPaymentMethods']?.map((x) => x)
      ),
      /*posAutoOpen: json['AppflixDewaShop.config.posAutoOpen'],
      pricePrecision: json['AppflixDewaShop.config.pricePrecision'],
      priceRounding: json['AppflixDewaShop.config.priceRounding'],
      registrationFormDewa: json['AppflixDewaShop.config.registrationFormDewa'],
      searchPortalActive: json['AppflixDewaShop.config.searchPortalActive'],
      searchPortalCategory: json['AppflixDewaShop.config.searchPortalCategory'],
      searchPortalToken: json['AppflixDewaShop.config.searchPortalToken'],
      searchPortalUrl: json['AppflixDewaShop.config.searchPortalUrl'],
      timezone: json['AppflixDewaShop.config.timezone'],
      useMenuAsLandingPage: json['AppflixDewaShop.config.useMenuAsLandingPage'],
      useMenuBadgeFilter: json['AppflixDewaShop.config.useMenuBadgeFilter'],*/
    );
  }

  Map<String, dynamic> toJson() => {
        'disableOffcanvasCart': disableOffcanvasCart,
        'checkoutDateMin': checkoutDateMin,
        'checkoutDropdownAsap': checkoutDropdownAsap,
        'checkoutDropdownSteps': checkoutDropdownSteps,
        'checkoutOpenDeliveryMethods': checkoutOpenDeliveryMethods,
        'checkoutPhoneNumber': checkoutPhoneNumber,
        'checkoutTimepicker': checkoutTimepicker,
        'orderInvoice': orderInvoice,
        'orderMail': orderMail,
        'orderPrintJob': orderPrintJob,
        'orderWhitelistPaymentMethods': orderWhitelistPaymentMethods,
        'posAutoOpen': posAutoOpen,
        'pricePrecision': pricePrecision,
        'priceRounding': priceRounding,
        'registrationFormDewa': registrationFormDewa,
        'searchPortalActive': searchPortalActive,
        'searchPortalCategory': searchPortalCategory,
        'searchPortalToken': searchPortalToken,
        'searchPortalUrl': searchPortalUrl,
        'timezone': timezone,
        'useMenuAsLandingPage': useMenuAsLandingPage,
        'useMenuBadgeFilter': useMenuBadgeFilter,
      };

  @override
  String toString() => 'DewaShopConfig(${toJson()})';
}
