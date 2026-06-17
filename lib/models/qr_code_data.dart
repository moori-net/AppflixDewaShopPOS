class QrCodeData {
  String appUrl;
  String accessKey;
  String secretAccessKey;
  String shopId;

  QrCodeData({
    this.appUrl = '',
    this.accessKey = '',
    this.secretAccessKey = '',
    this.shopId = ''
  });

  factory QrCodeData.fromJson(Map<String, dynamic> json) =>
      QrCodeData(
        appUrl: json['appUrl'] as String,
        accessKey: json['accessKey'] as String,
        secretAccessKey: json['secretAccessKey'] as String,
        shopId: json['shopId'] as String,
      );

  factory QrCodeData.fromRawValue(String rawValue) {
    final split = rawValue.split(';');

    return QrCodeData(
      appUrl: split[0],
      accessKey: split[1],
      secretAccessKey: split[2],
      shopId: split[3],
    );
  }

  Map<String, dynamic> toJson() => {
    'appUrl': appUrl,
    'accessKey': accessKey,
    'secretAccessKey': secretAccessKey,
    'shopId': shopId
  };

  @override
  String toString() => 'QrCodeData($toJson())';
}
