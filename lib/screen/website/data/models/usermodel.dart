
import '../../domain/entities/userentity/userentity.dart';

class UserModel {
  final String userId;
  final String businessId;

  final String name;
  final String role;

  final String createdAt;

  UserModel({
    required this.userId,
    required this.businessId,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  /// JSON → Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      businessId: json['business_id'],
      name: json['name'],
      role: json['role'],
      createdAt: json['created_at'],
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'business_id': businessId,
      'name': name,
      'role': role,
      'created_at': createdAt,
    };
  }

  /// Model → Entity
  UserEntity toEntity() {
    return UserEntity(
      id: userId,
      businessId: businessId,
      name: name,
      role: role,
      createdAt: DateTime.parse(createdAt),
    );
  }

  /// Entity → Model
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      userId: entity.id,
      businessId: entity.businessId,
      name: entity.name,
      role: entity.role,
      createdAt: entity.createdAt.toIso8601String(),
    );
  }
}