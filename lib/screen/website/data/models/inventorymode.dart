import '../../domain/entities/inventory/inventoryEntity.dart';

class InventoryModel {
  final String inventoryId;
  final String productId;
  final String businessId;

  final String type;

  final double stockQuantity;
  final double costPrice;
  final double sellingPrice;

  final bool isActive;

  final String createdAt;
  final String updatedAt;
  final String createdBy;

  InventoryModel({
    required this.inventoryId,
    required this.productId,
    required this.businessId,
    required this.type,
    required this.stockQuantity,
    required this.costPrice,
    required this.sellingPrice,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
  });

  /// JSON → Model
  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      inventoryId: json['inventory_id'],
      productId: json['product_id'],
      businessId: json['business_id'],
      type: json['type'],
      stockQuantity: (json['stock_quantity'] as num).toDouble(),
      costPrice: (json['cost_price'] as num).toDouble(),
      sellingPrice: (json['selling_price'] as num).toDouble(),
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      createdBy: json['created_by'],
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'inventory_id': inventoryId,
      'product_id': productId,
      'business_id': businessId,
      'type': type,
      'stock_quantity': stockQuantity,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'created_by': createdBy,
    };
  }

  /// Model → Entity
  InventoryEntity toEntity() {
    return InventoryEntity(
      id: inventoryId,
      productId: productId,
      businessId: businessId,
      type: type,
      stockQuantity: stockQuantity,
      costPrice: costPrice,
      sellingPrice: sellingPrice,
      isActive: isActive,
      createdAt: DateTime.parse(createdAt),
      updatedAt: DateTime.parse(updatedAt),
      createdBy: createdBy,
    );
  }

  /// Entity → Model
  factory InventoryModel.fromEntity(InventoryEntity entity) {
    return InventoryModel(
      inventoryId: entity.id,
      productId: entity.productId,
      businessId: entity.businessId,
      type: entity.type,
      stockQuantity: entity.stockQuantity,
      costPrice: entity.costPrice,
      sellingPrice: entity.sellingPrice,
      isActive: entity.isActive,
      createdAt: entity.createdAt.toIso8601String(),
      updatedAt: entity.updatedAt.toIso8601String(),
      createdBy: entity.createdBy,
    );
  }
}