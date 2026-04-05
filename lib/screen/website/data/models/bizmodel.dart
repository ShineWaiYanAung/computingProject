
import '../../domain/entities/business/bizentity.dart';

class BusinessModel {
  final String businessId;
  final String name;
  final String createdAt;

  BusinessModel({
    required this.businessId,
    required this.name,
    required this.createdAt,
  });

  /// JSON → Model
  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      businessId: json['business_id'],
      name: json['name'],
      createdAt: json['created_at'],
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
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// Entity → Model
  factory BusinessModel.fromEntity(BusinessEntity entity) {
    return BusinessModel(
      businessId: entity.id,
      name: entity.name,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}