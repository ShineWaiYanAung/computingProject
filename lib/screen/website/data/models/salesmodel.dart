import '../../domain/entities/sales/salesentity.dart';

class SaleItemModel {
  final String productId;
  final String name;
  final String type; // weighted | fixed

  final double quantity;
  final double pricePerUnit;
  final double costPerUnit;
  final double total;

  SaleItemModel({
    required this.productId,
    required this.name,
    required this.type,
    required this.quantity,
    required this.pricePerUnit,
    required this.total, required this.costPerUnit,
  });

  factory SaleItemModel.fromJson(Map<String, dynamic> json) {
    return SaleItemModel(
      productId: json['product_id'],
      name: json['name'],
      type: json['type'],
      quantity: (json['quantity'] as num).toDouble(),
      pricePerUnit: (json['price_per_unit'] as num).toDouble(),
      total: (json['total'] as num).toDouble(), costPerUnit: (json['cost_per_unit'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'type': type,
      'quantity': quantity,
      'price_per_unit': pricePerUnit,
      'cost_per_unit': costPerUnit,
      'total': total,
    };
  }

  SaleItemEntity toEntity() {
    return SaleItemEntity(
      productId: productId,
      name: name,
      type: type,
      quantity: quantity,
      costPerUnit: costPerUnit,
      pricePerUnit: pricePerUnit,
      total: total,
    );
  }

  factory SaleItemModel.fromEntity(SaleItemEntity entity) {
    return SaleItemModel(
      productId: entity.productId,
      name: entity.name,
      type: entity.type,
      quantity: entity.quantity,
      pricePerUnit: entity.pricePerUnit,
      total: entity.total, costPerUnit: entity.costPerUnit,
    );
  }
}

class SaleModel {
  final String saleId;
  final String businessId;

  final List<SaleItemModel> items;

  final double subtotal;

  final String createdAt;   // full datetime
  final String createdBy;   // who sold

  SaleModel({
    required this.saleId,
    required this.businessId,
    required this.items,
    required this.subtotal,
    required this.createdAt,
    required this.createdBy,
  });

  /// JSON → Model
  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      saleId: json['sale_id'],
      businessId: json['business_id'],
      items: (json['items'] as List)
          .map((e) => SaleItemModel.fromJson(e))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      createdAt: json['created_at'],
      createdBy: json['created_by'],
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'sale_id': saleId,
      'business_id': businessId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'created_at': createdAt,
      'created_by': createdBy,
    };
  }

  /// Model → Entity
  SaleEntity toEntity() {
    return SaleEntity(
      id: saleId,
      businessId: businessId,
      items: items.map((e) => e.toEntity()).toList(),
      subtotal: subtotal,
      createdAt: DateTime.parse(createdAt),
      createdBy: createdBy,
    );
  }

  /// Entity → Model
  factory SaleModel.fromEntity(SaleEntity entity) {
    return SaleModel(
      saleId: entity.id,
      businessId: entity.businessId,
      items: entity.items.map((e) => SaleItemModel.fromEntity(e)).toList(),
      subtotal: entity.subtotal,
      createdAt: entity.createdAt.toIso8601String(),
      createdBy: entity.createdBy,
    );
  }
}