import '../../domain/entities/business/bizentity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class BusinessModel {
  final String businessId;
  final String name;
  final DateTime createdAt;

  BusinessModel({
    required this.businessId,
    required this.name,
    required this.createdAt,
  });

  /// JSON → Model
  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['created_at'];

    DateTime parsedDate;

    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.parse(rawDate);
    } else {
      parsedDate = DateTime.now(); // fallback
    }

    return BusinessModel(
      businessId: json['business_id'] ?? '',
      name: json['name'] ?? '',
      createdAt: parsedDate,
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'business_id': businessId,
      'name': name,
      'created_at': createdAt,
    };
  }

  /// Model → Entity
  BusinessEntity toEntity() {
    return BusinessEntity(
      id: businessId,
      name: name,
      createdAt:createdAt,
    );
  }

  /// Entity → Model
  factory BusinessModel.fromEntity(BusinessEntity entity) {
    return BusinessModel(
      businessId: entity.id,
      name: entity.name,
      createdAt: entity.createdAt,
    );
  }
}