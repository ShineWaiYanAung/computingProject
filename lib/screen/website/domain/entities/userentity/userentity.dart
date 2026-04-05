class UserEntity {
  final String id;
  final String businessId;

  final String name;
  final String role;

  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.businessId,
    required this.name,
    required this.role,
    required this.createdAt,
  });
}