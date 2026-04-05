import '../../domain/entities/expense/expense.dart';

class ExpenseModel {
  final String expenseId;
  final String businessId;
  final String type;
  final String category;
  final String title;
  final double amount;
  final String frequency;
  final String createdAt;
  final String createdBy;
  final String? updatedAt;
  final String? updatedBy;

  ExpenseModel({
    required this.expenseId,
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

  /// JSON → Model
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      expenseId: json['expense_id'],
      businessId: json['business_id'],
      type: json['type'],
      category: json['category'],
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      frequency: json['frequency'],
      createdAt: json['created_at'],
      createdBy: json['created_by'],
      updatedAt: json['updated_at'],
      updatedBy: json['updated_by'],
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'expense_id': expenseId,
      'business_id': businessId,
      'type': type,
      'category': category,
      'title': title,
      'amount': amount,
      'frequency': frequency,
      'created_at': createdAt,
      'created_by': createdBy,
      'updated_at': updatedAt,
      'updated_by': updatedBy,
    };
  }

  /// Model → Entity
  ExpenseEntity toEntity() {
    return ExpenseEntity(
      id: expenseId,
      businessId: businessId,
      type: type,
      category: category,
      title: title,
      amount: amount,
      frequency: frequency,
      createdAt: DateTime.parse(createdAt),
      createdBy: createdBy,
      updatedAt: updatedAt != null ? DateTime.parse(updatedAt!) : null,
      updatedBy: updatedBy,
    );
  }

  /// Entity → Model
  factory ExpenseModel.fromEntity(ExpenseEntity entity) {
    return ExpenseModel(
      expenseId: entity.id,
      businessId: entity.businessId,
      type: entity.type,
      category: entity.category,
      title: entity.title,
      amount: entity.amount,
      frequency: entity.frequency,
      createdAt: entity.createdAt.toIso8601String(),
      createdBy: entity.createdBy,
      updatedAt: entity.updatedAt?.toIso8601String(),
      updatedBy: entity.updatedBy,
    );
  }
}