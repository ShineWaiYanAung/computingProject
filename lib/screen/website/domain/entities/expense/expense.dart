class ExpenseEntity {
  final String id;
  final String businessId;

  final String type;
  final String category;
  final String title;
  final double amount;
  final String frequency;

  final DateTime createdAt;
  final String createdBy;

  final DateTime? updatedAt;
  final String? updatedBy;

  const ExpenseEntity({
    required this.id,
    required this.businessId,
    required this.type,
    required this.category,
    required this.title,
    required this.amount,
    required this.frequency,
    required this.createdAt,
    required this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });
}