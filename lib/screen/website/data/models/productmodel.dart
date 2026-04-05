import '../../domain/entities/product/productEntity.dart';

class ProductModel {
  final String productId;
  final String businessId;

  final String name;
  final String category;
  final String type;

  final String createdAt;
  final String createdBy;

  ProductModel({
    required this.productId,
    required this.businessId,
    required this.name,
    required this.category,
    required this.type,
    required this.createdAt,
    required this.createdBy,
  });

  /// JSON → Model
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'],
      businessId: json['business_id'],
      name: json['name'],
      category: json['category'],
      type: json['type'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'business_id': businessId,
      'name': name,
      'category': category,
      'type': type,
      'created_at': createdAt,
      'created_by': createdBy,
    };
  }

  /// Model → Entity
  ProductEntity toEntity() {
    return ProductEntity(
      id: productId,
      businessId: businessId,
      name: name,
      category: category,
      type: type,
      createdAt: DateTime.parse(createdAt),
      createdBy: createdBy,
    );
  }

  /// Entity → Model
  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      productId: entity.id,
      businessId: entity.businessId,
      name: entity.name,
      category: entity.category,
      type: entity.type,
      createdAt: entity.createdAt.toIso8601String(),
      createdBy: entity.createdBy,
    );
  }
}