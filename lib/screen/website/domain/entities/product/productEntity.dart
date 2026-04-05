class ProductEntity {
  final String id;
  final String businessId;

  final String name;
  final String category; // fish | shop
  final String type;     // weighted | fixed

  final DateTime createdAt;
  final String createdBy;

  const ProductEntity({
    required this.id,
    required this.businessId,
    required this.name,
    required this.category,
    required this.type,
    required this.createdAt,
    required this.createdBy,
  });
}