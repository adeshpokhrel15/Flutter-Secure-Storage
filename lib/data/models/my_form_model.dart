import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MyFormModel {
  final String name;
  final String address;
  final DateTime createdAt;
  final String uniqueId;
  MyFormModel({
    required this.name,
    required this.address,
    required this.createdAt,
    required this.uniqueId,
  });

  MyFormModel copyWith({
    String? name,
    String? address,
    DateTime? createdAt,
    String? uniqueId,
  }) {
    return MyFormModel(
      name: name ?? this.name,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      uniqueId: uniqueId ?? this.uniqueId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'address': address,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'uniqueId': uniqueId,
    };
  }

  factory MyFormModel.fromMap(Map<String, dynamic> map) {
    return MyFormModel(
      name: map['name'] as String,
      address: map['address'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      uniqueId: map['uniqueId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'MyFormModel(name: $name, address: $address, createdAt: $createdAt, uniqueId: $uniqueId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyFormModel &&
        other.name == name &&
        other.address == address &&
        other.createdAt == createdAt &&
        other.uniqueId == uniqueId;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        address.hashCode ^
        createdAt.hashCode ^
        uniqueId.hashCode;
  }

  factory MyFormModel.fromJson(String source) =>
      MyFormModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
