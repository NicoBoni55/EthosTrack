import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isCompleted;

  HabitModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'isCompleted': isCompleted,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] ?? '', 
      userId: map['userId'] ?? '',   
      title: map['title'] ?? '', 
      description: map['description'] ?? '', 
      createdAt: map['createdAt'] != null
        ? (map['createdAt'] as Timestamp).toDate()
        : DateTime.now(), 
      isCompleted: map['isCompleted'] ?? false
    );
  }

  HabitModel? copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return HabitModel(
      id: id ?? this.id, 
      userId: userId ?? this.userId, 
      title: title ?? this.title, 
      description: description ?? this.description, 
      createdAt: createdAt ?? this.createdAt, 
      isCompleted: isCompleted ?? this.isCompleted
    );
  }
}