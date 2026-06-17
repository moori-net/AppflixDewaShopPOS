Map<String, dynamic> asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return <String, dynamic>{};
}

Map<String, dynamic>? asMapOrNull(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return null;
}

List<dynamic> asList(dynamic value) {
  if (value is List) {
    return value;
  }

  return <dynamic>[];
}

List<T> asTypedList<T>(
    dynamic value,
    T Function(dynamic item) mapper,
    ) {
  if (value is! List) {
    return <T>[];
  }

  return value.map(mapper).toList();
}

String? asStringOrNull(dynamic value) {
  if (value == null) {
    return null;
  }

  return value.toString();
}

String asString(
    dynamic value, {
      String fallback = '',
    }) {
  if (value == null) {
    return fallback;
  }

  return value.toString();
}

int asInt(
    dynamic value, {
      int fallback = 0,
    }) {
  if (value == null) {
    return fallback;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(value.toString()) ?? fallback;
}

double? asDoubleOrNull(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}

num? asNumOrNull(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value;
  }

  return num.tryParse(value.toString());
}

bool asBool(
    dynamic value, {
      bool fallback = false,
    }) {
  if (value == null) {
    return fallback;
  }

  if (value is bool) {
    return value;
  }

  if (value is num) {
    return value != 0;
  }

  final stringValue = value.toString().toLowerCase();

  if (stringValue == 'true' || stringValue == '1') {
    return true;
  }

  if (stringValue == 'false' || stringValue == '0') {
    return false;
  }

  return fallback;
}

DateTime? asDateTimeOrNull(dynamic value) {
  if (value == null) {
    return null;
  }

  final stringValue = value.toString();

  if (stringValue.isEmpty) {
    return null;
  }

  return DateTime.tryParse(stringValue);
}
