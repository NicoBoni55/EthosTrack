import '../models/habit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HabitService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // CREATE
  static Future<HabitModel?> createHabit({
    required String userId,
    required String title,
    required String description,
  }) async {
    try {
    print('✅ Create habit');
    print('✅ UserId: $userId');
    print('✅ Title: $title');
    print('✅ Description: $description');

    String habitId = _firestore.collection('habits').doc().id;
    print('✅ Habit ID: $habitId');

    HabitModel newHabit = HabitModel(
      id: habitId, 
      userId: userId, 
      title: title, 
      description: description, 
      createdAt: DateTime.now(), 
      isCompleted: false, // default
    );
    print('✅ Habit created');

    await _firestore
      .collection('habits')
      .doc(habitId)
      .set(newHabit.toMap());
    print('✅ Habit saved in firestore');

    print('✅ New Habit created successfully');
    return newHabit;
    } catch (e) {
      print('❌ Error created Habit: $e');
      return null;
    }


  }
  // READ
  static Future<List<HabitModel>> getUserHabits(String userId) async {
    try {
      print('✅ Obtain habits from the user: $userId');

      QuerySnapshot querySnapshot = await _firestore
        .collection('habits')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
      print('✅ documents found: ${querySnapshot.docs.length}');

      List<HabitModel> habits = querySnapshot.docs.map((doc) {
        return HabitModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      print('✅ Habits converted to models: ${habits.length}');
      return habits;

    } catch (e) {
      print('❌ Error get habits: $e');
      return [];     
    }
  }

  // UPDATE
  static Future<bool> toggleHabitCompletion(String habitId, bool isCompleted) async {
    try {
      print('✅ Update habit $habitId to completed: $isCompleted');

      await _firestore
        .collection('habits')
        .doc(habitId)
        .update({
          'isCompleted': isCompleted,
        });
      
      print('✅ Habit update successfully');
      return true;
    } catch (e) {
      print('❌ Error updating habit: $e');
      return false;
    }
  }

  static Future<bool> updateHabit ({
    required String habitId,
    required String title,
    required String description,
  }) async {
    try {
      print('✅ Updating habit: $habitId');
      print('✅ New title: $title');
      print('✅ New Description: $description');

      await _firestore
        .collection('habits')
        .doc(habitId)
        .update({
          'title': title,
          'description': description,
          'upadateAt': DateTime.now(),
        });

        print('✅ Habit updated successfully');
        return true;
    } catch (e) {
      print('❌ Error updating habit: $e');
      return false;
    }
  }

  // DELETE
  static Future<bool> deleteHabit(String habitId) async {
    try {
      print('✅ Deleting habit: $habitId');

      await _firestore
        .collection('habits')
        .doc(habitId)
        .delete();
      
      print('✅ habit deleted successfully');
      return true;
    } catch (e) {
      print('❌ Error deleting habit: $e');
      return false;
    }
  }
}