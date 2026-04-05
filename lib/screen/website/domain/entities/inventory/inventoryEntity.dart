class InventoryEntity {
  final String id;
  final String productId;
  final String businessId;

  final String type; // weighted | fixed

  final double stockQuantity;
  final double costPrice;
  final double sellingPrice;

  final bool isActive; // 🔥 important for batch lifecycle

  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;

  const InventoryEntity({
    required this.id,
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

  /// copyWith (VERY useful for updating stock)
  InventoryEntity copyWith({
    double? stockQuantity,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return InventoryEntity(
      id: id,
      productId: productId,
      businessId: businessId,
      type: type,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      costPrice: costPrice,
      sellingPrice: sellingPrice,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy,
    );
  }
}