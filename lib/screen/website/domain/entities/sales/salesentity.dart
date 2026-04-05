class SaleEntity {
  final String id;
  final String businessId;

  final List<SaleItemEntity> items;

  final double subtotal;

  final DateTime createdAt;
  final String createdBy;

  const SaleEntity({
    required this.id,
    required this.businessId,
    required this.items,
    required this.subtotal,
    required this.createdAt,
    required this.createdBy,

  });
}
class SaleItemEntity {
  final String productId;
  final String name;

  final String type;
  final double quantity;
  final double pricePerUnit;
  final double total;
  final double costPerUnit;

  const SaleItemEntity({
    required this.productId,
    required this.name,
    required this.type,
    required this.quantity,
    required this.pricePerUnit,
    required this.total, required this.costPerUnit,
  });
}