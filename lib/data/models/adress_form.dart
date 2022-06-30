// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddressFormModel {
  final String country;
  final String district;
  final String uniqueId;
  AddressFormModel({
    required this.country,
    required this.district,
    required this.uniqueId,
  });

  AddressFormModel copyWith({
    String? country,
    String? district,
    String? uniqueId,
  }) {
    return AddressFormModel(
      country: country ?? this.country,
      district: district ?? this.district,
      uniqueId: uniqueId ?? this.uniqueId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'country': country,
      'district': district,
      'uniqueId': uniqueId,
    };
  }

  factory AddressFormModel.fromMap(Map<String, dynamic> map) {
    return AddressFormModel(
      country: map['country'] as String,
      district: map['district'] as String,
      uniqueId: map['uniqueId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressFormModel.fromJson(String source) =>
      AddressFormModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AddressForm(country: $country, district: $district, uniqueId: $uniqueId)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressFormModel &&
        other.country == country &&
        other.district == district &&
        other.uniqueId == uniqueId;
  }

  @override
  int get hashCode => country.hashCode ^ district.hashCode ^ uniqueId.hashCode;
}
