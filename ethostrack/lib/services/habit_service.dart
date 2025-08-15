import 'package:ethostrack/models/habit_model.dart';
import 'package:flutter/material.dart';

class HabitService {

  // CREATE
  static Future<HabitModel?> createHabit({
    required String userId,
    required String title,
    required String description,
  }) async {

  }
  // READ
  static Future<List<HabitModel>> getUserHabits(String userId) async {

  }

  // UPDATE
  static Future<bool> toggleHabitCompletion(String habitId, bool isCompleted) async {

  }

  // DELETE
  static Future<bool> deleteHabit(String habitId) async {
    
  }
}