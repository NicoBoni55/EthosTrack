import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String username;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '', 
      email: map['email'] ?? '', 
      username: map['username'] ?? '', 
      createdAt: map['createdAt'] != null
        ? (map['createdAt'] as Timestamp).toDate()
        : DateTime.now(),
      );
  }
}