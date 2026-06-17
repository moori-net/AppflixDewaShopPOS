import 'attributes.dart';

class OrderAddress extends Attributes {
  final String? versionId;
  final String? countryId;
  final String? countryStateId;
  final String? orderId;
  final String? orderVersionId;
  final String? salutationId;
  final String? firstName;
  final String? lastName;
  final String? street;
  final String? zipcode;
  final String? city;
  final String? company;
  final String? department;
  final String? title;
  final String? vatId;
  final String? phoneNumber;
  final String? additionalAddressLine1;
  final String? additionalAddressLine2;
  final dynamic customFields;

  const OrderAddress({
    this.versionId,
    this.countryId,
    this.countryStateId,
    this.orderId,
    this.orderVersionId,
    this.salutationId,
    this.firstName,
    this.lastName,
    this.street,
    this.zipcode,
    this.city,
    this.company,
    this.department,
    this.title,
    this.vatId,
    this.phoneNumber,
    this.additionalAddressLine1,
    this.additionalAddressLine2,
    this.customFields,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(createdAt: createdAt, updatedAt: updatedAt);

  factory OrderAddress.fromJson(Map<String, dynamic> json) => OrderAddress(
        versionId: json['versionId'],
        countryId: json['countryId'],
        countryStateId: json['countryStateId'],
        orderId: json['orderId'],
        orderVersionId: json['orderVersionId'],
        salutationId: json['salutationId'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        street: json['street'],
        zipcode: json['zipcode'],
        city: json['city'],
        company: json['company'],
        department: json['department'],
        title: json['title'],
        vatId: json['vatId'],
        phoneNumber: json['phoneNumber'],
        additionalAddressLine1: json['additionalAddressLine1'],
        additionalAddressLine2: json['additionalAddressLine2'],
        customFields: json['customFields'] ?? const {},
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
        'countryId': countryId,
        'countryStateId': countryStateId,
        'orderId': orderId,
        'orderVersionId': orderVersionId,
        'salutationId': salutationId,
        'firstName': firstName,
        'lastName': lastName,
        'street': street,
        'zipcode': zipcode,
        'city': city,
        'company': company,
        'department': department,
        'title': title,
        'vatId': vatId,
        'phoneNumber': phoneNumber,
        'additionalAddressLine1': additionalAddressLine1,
        'additionalAddressLine2': additionalAddressLine2,
        'customFields': customFields,
        ...super.toJson(),
      };

  @override
  String toString() => 'OrderAddress(${toJson()}';
}
