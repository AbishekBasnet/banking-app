import 'package:mongo_dart/mongo_dart.dart';

/// Model class representing a user with client card credentials
class User {
  final ObjectId? id;
  final String clientCard;
  final String passwordHash;
  final String name;
  final DateTime createdAt;

  User({
    this.id,
    required this.clientCard,
    required this.passwordHash,
    required this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Factory constructor to create a User from MongoDB document
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as ObjectId?,
      clientCard: json['clientCard'] as String,
      passwordHash: json['passwordHash'] as String,
      name: json['name'] as String,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  /// Convert User to MongoDB document
  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'clientCard': clientCard,
      'passwordHash': passwordHash,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
