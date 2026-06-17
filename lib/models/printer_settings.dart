class PrinterSettings {
  bool printAutomatically;
  bool printRestaurantDetails;
  bool printCustomerDetails;
  bool printCategoryName;
  bool printOrderId;
  bool printProductId;
  bool printQrCode;
  bool printPropertyLabels;
  int copies;
  int paperSize = 0;
  String profile = 'default';
  String charset = 'UTF-8';

  PrinterSettings({
    this.printAutomatically = true,
    this.printRestaurantDetails = true,
    this.printCustomerDetails = true,
    this.printCategoryName = true,
    this.printOrderId = true,
    this.printProductId = true,
    this.printQrCode = true,
    this.printPropertyLabels = true,
    this.copies = 1,
    this.paperSize = 0,
    this.profile = 'default',
    this.charset = 'UTF-8',
  });

  factory PrinterSettings.fromJson(Map<String, dynamic> json) =>
      PrinterSettings(
        printAutomatically: json['printAutomatically'] as bool,
        printRestaurantDetails: json['printRestaurantDetails'] as bool,
        printCustomerDetails: json['printCustomerDetails'] as bool,
        printCategoryName: json['printCategoryName'] as bool,
        printOrderId: json['printOrderId'] as bool,
        printProductId: json['printProductId'] as bool,
        printQrCode: (json['printQrCode'] ?? true) as bool,
        printPropertyLabels: (json['printPropertyLabels'] ?? true) as bool,
        copies: json['copies'] as int,
        paperSize: (json['paperSize'] ?? 0) as int,
        profile: (json['profile'] ?? 'default') as String,
        charset: (json['charset'] ?? 'UTF-8') as String,
      );

  @override
  int get hashCode =>
      printAutomatically.hashCode ^
      printRestaurantDetails.hashCode ^
      printCustomerDetails.hashCode ^
      printCategoryName.hashCode ^
      printOrderId.hashCode ^
      printProductId.hashCode ^
      printQrCode.hashCode ^
      printPropertyLabels.hashCode ^
      copies.hashCode ^
      paperSize.hashCode ^
      profile.hashCode ^
      charset.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrinterSettings &&
          runtimeType == other.runtimeType &&
          printAutomatically == other.printAutomatically &&
          printRestaurantDetails == other.printRestaurantDetails &&
          printCustomerDetails == other.printCustomerDetails &&
          printCategoryName == other.printCategoryName &&
          printOrderId == other.printOrderId &&
          printProductId == other.printProductId &&
          printQrCode == other.printQrCode &&
          printPropertyLabels == other.printPropertyLabels &&
          copies == other.copies &&
          paperSize == other.paperSize &&
          profile == other.profile &&
          charset == other.charset;

  PrinterSettings copyWith({
    bool? printAutomatically,
    bool? printRestaurantDetails,
    bool? printCustomerDetails,
    bool? printCategoryName,
    bool? printOrderId,
    bool? printProductId,
    bool? printQrCode,
    bool? printPropertyLabels,
    int? copies,
    int? paperSize,
    String? profile,
    String? charset,
  }) =>
      PrinterSettings(
        printAutomatically: printAutomatically ?? this.printAutomatically,
        printRestaurantDetails:
            printRestaurantDetails ?? this.printRestaurantDetails,
        printCustomerDetails: printCustomerDetails ?? this.printCustomerDetails,
        printCategoryName: printCategoryName ?? this.printCategoryName,
        printOrderId: printOrderId ?? this.printOrderId,
        printProductId: printProductId ?? this.printProductId,
        printQrCode: printQrCode ?? this.printQrCode,
        printPropertyLabels: printPropertyLabels ?? this.printPropertyLabels,
        copies: copies ?? this.copies,
        paperSize: paperSize ?? this.paperSize,
        profile: profile ?? this.profile,
        charset: charset ?? this.charset,
      );

  Map<String, dynamic> toJson() => {
        'printAutomatically': printAutomatically,
        'printRestaurantDetails': printRestaurantDetails,
        'printCustomerDetails': printCustomerDetails,
        'printCategoryName': printCategoryName,
        'printOrderId': printOrderId,
        'printProductId': printProductId,
        'printQrCode': printQrCode,
        'printPropertyLabels': printPropertyLabels,
        'copies': copies,
        'paperSize': paperSize,
        'profile': profile,
        'charset': charset,
      };

  @override
  String toString() => 'PrinterSettings($toJson())';

  static List<String> charsets() {
    return <String>[
      'UTF-8',
      'windows-1250',
      'windows-1251',
      'windows-1252',
      'windows-1254',
      'GB18030',
      'CP1252',
    ];
  }

  static List<String> paperSizes() {
    return <String>['58mm', '80mm'];
  }
}
