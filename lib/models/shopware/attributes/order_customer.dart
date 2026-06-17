import 'attributes.dart';

class OrderCustomer extends Attributes {
  final String? versionId;
  final String? customerId;
  final String? orderId;
  final String? orderVersionId;
  final String? email;
  final String? salutationId;
  final String? firstName;
  final String? lastName;
  final String? company;
  final String? title;
  final String? vatIds;
  final String? customerNumber;
  final dynamic customFields;
  final String? remoteAddress;
  final String? phoneNumber;

  const OrderCustomer({
    this.versionId,
    this.customerId,
    this.orderId,
    this.orderVersionId,
    this.email,
    this.salutationId,
    this.firstName,
    this.lastName,
    this.company,
    this.title,
    this.vatIds,
    this.customerNumber,
    this.customFields,
    this.remoteAddress,
    this.phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory OrderCustomer.fromJson(Map<String, dynamic> json) => OrderCustomer(
        versionId: json['versionId'],
        customerId: json['customerId'],
        orderId: json['orderId'],
        orderVersionId: json['orderVersionId'],
        email: json['email'],
        salutationId: json['salutationId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        company: json['company'],
        title: json['title'],
        vatIds: json['vatIds'],
        customerNumber: json['customerNumber'],
        customFields: json['customFields'],
        remoteAddress: json['remoteAddress'],
        phoneNumber: json['phoneNumber'],
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt']),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt']),
      );

  @override
  Map<String, dynamic> toJson() => {
        'versionId': versionId,
        'customerId': customerId,
        'orderId': orderId,
        'orderVersionId': orderVersionId,
        'email': email,
        'salutationId': salutationId,
        'firstName': firstName,
        'lastName': lastName,
        'company': company,
        'title': title,
        'vatIds': vatIds,
        'customerNumber': customerNumber,
        'customFields': customFields,
        'remoteAddress': remoteAddress,
        'phoneNumber': phoneNumber,
        ...super.toJson(),
      };

  @override
  String toString() => 'OrderCustomer(${toJson()}';
}
