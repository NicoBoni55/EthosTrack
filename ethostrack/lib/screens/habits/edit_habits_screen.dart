import '../../models/habit_model.dart';
import '../../services/habit_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditHabitsScreen extends StatefulWidget {
  final HabitModel habit;
  const EditHabitsScreen({super.key, required this.habit});

  @override
  State<EditHabitsScreen> createState() => _EditHabitsScreenState();
}

class _EditHabitsScreenState extends State<EditHabitsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.habit.title);
    _descriptionController = TextEditingController(text: widget.habit.description);
  }

  Future<void> _updateHabit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('🔍 Updating habit: ${widget.habit.id}');
      print('🔍 New title: ${_titleController.text.trim()}');
      print('🔍 New description: ${_descriptionController.text.trim()}');

      bool success = await HabitService.updateHabit(
        habitId: widget.habit.id, 
        title: _titleController.text.trim(), 
        description: _descriptionController.text.trim(),
      );

      if (success) {
        print('✅ Habit updated successfully, returning true');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Habit updated successfully!',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        print('❌ Failed to update habit');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error updating habit',
              style: GoogleFonts.montserrat(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.red,
          )
        );
      }
    } catch (e) {
      print('❌ Error updating habit: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A0DAD),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF6A0DAD),
                          Color(0xFF2C0547)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            size: 40,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 22),
                          Text(
                            'Edit Your Habit',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Habit Title',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF6A0DAD),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'e.g., Exercise daily, Read books',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color(0xFF6A0DAD),
                                width: 2,
                              ),
                            ),
                            prefixIcon: Icon(
                              Icons.title,
                              color: Color(0xFF6A0DAD),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a habit title';
                            }
                            if (value.trim().length < 3) {
                              return 'Title must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Card(
                  color: Colors.white,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF6A0DAD),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Describe your habit and why it\'s important...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Color(0xFF6A0DAD),
                                width: 2,
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: EdgeInsets.only(bottom: 60),
                              child: Icon(Icons.description,
                                color: Color(0xFF6A0DAD),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a description';
                            }
                            if (value.trim().length < 10) {
                              return 'Description must be at least 10 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF6A0DAD),
                        Color(0xFF2C0547)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateHabit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      elevation: 0
                    ), 
                    child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Update Habit',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                TextButton(
                  onPressed: _isLoading ? null : () => Navigator.of(context).pop(), 
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.red,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}