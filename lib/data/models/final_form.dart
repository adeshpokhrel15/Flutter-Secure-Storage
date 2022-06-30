// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FinalFormModel {
  final String name;
  final String address;
  final String country;
  final String district;
  FinalFormModel({
    required this.name,
    required this.address,
    required this.country,
    required this.district,
  });

  FinalFormModel copyWith({
    String? name,
    String? address,
    String? country,
    String? district,
  }) {
    return FinalFormModel(
      name: name ?? this.name,
      address: address ?? this.address,
      country: country ?? this.country,
      district: district ?? this.district,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'country': country,
      'district': district,
    };
  }

  factory FinalFormModel.fromMap(Map<String, dynamic> map) {
    return FinalFormModel(
      name: map['name'] as String,
      address: map['address'] as String,
      country: map['country'] as String,
      district: map['district'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FinalFormModel.fromJson(String source) =>
      FinalFormModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FinalFormModel(name: $name, address: $address, country: $country, district: $district)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FinalFormModel &&
        other.name == name &&
        other.address == address &&
        other.country == country &&
        other.district == district;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        address.hashCode ^
        country.hashCode ^
        district.hashCode;
  }
}
