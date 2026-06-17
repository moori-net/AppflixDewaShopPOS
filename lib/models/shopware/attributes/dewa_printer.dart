import 'attributes.dart';

class DewaPrinter extends Attributes {
  final String? mediaId;
  final String? shopId;
  final bool? active;
  final String? name;
  final String? mac;
  final String? template;
  final DateTime? lastPolled;
  final String? status;
  final num? dotWidth;
  final String? printerType;
  final String? printerVersion;

  const DewaPrinter({
    this.mediaId,
    this.shopId,
    this.active = false,
    this.name,
    this.mac,
    this.template,
    this.lastPolled,
    this.status,
    this.dotWidth,
    this.printerType,
    this.printerVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory DewaPrinter.fromJson(Map<String, dynamic> json) => DewaPrinter(
        mediaId: json['mediaId'],
        shopId: json['shopId'],
        active: json['active'],
        name: json['name'],
        mac: json['mac'],
        template: json['template'],
        lastPolled: json['lastPolled'] == null
            ? null
            : DateTime.parse(json['lastPolled']),
        status: json['status'],
        dotWidth: json['dotWidth'],
        printerType: json['printerType'],
        printerVersion: json['printerVersion'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'mediaId': mediaId,
        'shopId': shopId,
        'active': active,
        'name': name,
        'mac': mac,
        'template': template,
        'lastPolled': lastPolled?.toIso8601String(),
        'status': status,
        'dotWidth': dotWidth,
        'printerType': printerType,
        'printerVersion': printerVersion,
        ...super.toJson(),
      };

  @override
  String toString() => 'DewaPrinter(${toJson()})';
}
