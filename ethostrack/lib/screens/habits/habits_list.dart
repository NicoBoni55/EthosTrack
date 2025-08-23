import 'package:ethostrack/models/habit_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/habit_service.dart';
import '../habits/edit_habits_screen.dart';
import 'create_habits_screen.dart';

class HabitsList extends StatefulWidget {
  const HabitsList({super.key});

  @override
  State<HabitsList> createState() => _HabitsListState();
}

class _HabitsListState extends State<HabitsList> {
  late Future<List<HabitModel>> _habitsFuture;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
    _loadHabits();
  }

  void _loadHabits() {
    if (userId != null) {
      setState(() {
        _habitsFuture = HabitService.getUserHabits(userId!);
      });
    }
  }

  Future<void> _toggleHabitCompletion(HabitModel habit) async {
    bool newState = !habit.isCompleted;
    bool success = await HabitService.toggleHabitCompletion(habit.id, newState);

    if (success) {
      _loadHabits();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newState ? 'Completed' : 'Pending'),
          backgroundColor: newState ? Colors.green : Colors.orange,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error updating habit',
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteHabit(HabitModel habit) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Habit',
            style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete "${habit.title}"?',
            style: GoogleFonts.montserrat(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Delete',
                style: GoogleFonts.montserrat(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      bool success = await HabitService.deleteHabit(habit.id);

      if (success) {
        _loadHabits();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Habit deleted successfully',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error deleting habit',
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A0DAD),
        centerTitle: true,
        title: Text(
          'My Habits',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF6A0DAD), Color(0xFF2C0547)],
              ),
            ),
          ),
          FutureBuilder<List<HabitModel>>(
            future: _habitsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.white, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading habits',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: _loadHabits,
                        child: Text(
                          'Try Again',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              List<HabitModel> habits = snapshot.data ?? [];

              if (habits.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.task_alt, color: Colors.white, size: 64),
                      const SizedBox(height: 16),
                      Text(
                        'No habits yet',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first habit!',
                        style: GoogleFonts.montserrat(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    HabitModel habit = habits[index];
                    return Card(
                      elevation: 4,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: Color(0xFF6A0DAD).withOpacity(0.5),
                          width: 1.5,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    habit.title,
                                    style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 23,
                                      color: Color(0xFF6A0DAD),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: habit.isCompleted
                                        ? Colors.green
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Text(
                                    habit.isCompleted ? 'Completed' : 'Pending',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                habit.description,
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.blueGrey.shade700,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Created: ${habit.createdAt.day}/${habit.createdAt.month}/${habit.createdAt.year}',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.blueGrey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: Icon(
                                    size: 18,
                                    habit.isCompleted
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: habit.isCompleted
                                        ? Colors.green.shade700
                                        : Colors.grey.shade600,
                                  ),
                                  label: Text(
                                    habit.isCompleted
                                        ? 'Completed'
                                        : 'Complete',
                                    style: GoogleFonts.montserrat(
                                      color: habit.isCompleted
                                          ? Colors.green.shade700
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                  onPressed: () =>
                                      _toggleHabitCompletion(habit),
                                ),
                                TextButton.icon(
                                  icon: Icon(
                                    size: 18,
                                    Icons.edit,
                                    color: Colors.blue.shade700,
                                  ),
                                  label: Text(
                                    'Edit',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.blue.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditHabitsScreen(habit: habit),
                                      ),
                                    );
                                    if (result == true) {
                                      print('✅ Habit updated, refreshing list');
                                      _loadHabits();
                                    }
                                  },
                                ),
                                TextButton.icon(
                                  icon: Icon(
                                    size: 18,
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  label: Text(
                                    'Delete',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                  onPressed: () => _deleteHabit(habit),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateHabitsScreen()),
            );

            if (result == true) {
              print('✅ Habit created');
              _loadHabits();
            }
          },
          child: Icon(Icons.add, color: Color(0xFF6A0DAD), size: 40),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
