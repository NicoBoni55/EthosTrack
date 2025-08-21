import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../screens/habits/create_habits_screen.dart';
import 'login.dart';
import 'home_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0077B6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              SvgPicture.asset('assets/images/Logo.svg', width: 70, height: 70),
              const SizedBox(height: 10),
              Text(
                'Sign up',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [SignUpInputs()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpInputs extends StatefulWidget {
  const SignUpInputs({super.key});

  @override
  State<SignUpInputs> createState() => _LoginInputsState();
}

class _LoginInputsState extends State<SignUpInputs> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  Future<void> _handleSignUp() async {
    print('🚀 BOTÓN PRESIONADO - _handleSignUp iniciado');
    print('📝 Email controller: ${emailController.text}');
    print('📝 Username controller: ${usernameController.text}');
    print('📝 Password controller: ${passwordController.text}');
    if (emailController.text.isEmpty) {
      _showErrorDialog('Please enter your email');
      return;
    }
    if (usernameController.text.isEmpty) {
      _showErrorDialog('Please enter your username');
      return;
    }
    if (passwordController.text.isEmpty) {
      _showErrorDialog('Please enter your password');
      return;
    }
    if (passwordController.text.length < 6) {
      _showErrorDialog('Password must be at least 6 characters');
      return;
    }
    if (passwordController.text != confirmpasswordController.text) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserModel? user = await AuthService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        username: usernameController.text.trim(),
      );

      if (user != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const CreateHabitsScreen()),
          );
        }
      } else {
        _showErrorDialog('Registration failed. Please try again.');
      }
    } catch (e) {
      String errorMessage = 'Registration failed. Please try again.';

      print('ERROR COMPLETO: $e');
      print('TIPO DE ERROR: ${e.runtimeType}');


      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'This email is already registered.';
      } else if (e.toString().contains('weak-password')) {
        errorMessage = 'Password is too weak.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Invalid email format.';
      } else if (e.toString().contains('Username already exists')) {
        errorMessage = 'This username is already taken.';
      } else {
        errorMessage = 'Error: ${e.toString()}';
      }

      _showErrorDialog(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: Text(
            'Error',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: GoogleFonts.montserrat(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: emailController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Email",
              labelStyle: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFF0077B6),
              prefixIcon: Icon(Icons.email, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: usernameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Username",
              labelStyle: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFF0077B6),
              prefixIcon: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: passwordController,
            obscureText: !isPasswordVisible,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Password",
              labelStyle: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFF0077B6),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: confirmpasswordController,
            obscureText: !isPasswordVisible,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: "Confirm Password",
              labelStyle: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF0CC0DF), width: 2),
              ),
              filled: true,
              fillColor: const Color(0xFF0077B6),
              prefixIcon: Icon(Icons.lock, color: Colors.white),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 50,
          width: 300,
          child: FloatingActionButton(
            onPressed: isLoading ? null : _handleSignUp,
            backgroundColor: isLoading ? Colors.grey : Colors.white,
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Color(0xFF0077B6),
                    strokeWidth: 2,
                  )
                : Text(
                    "Sign up",
                    style: GoogleFonts.montserrat(
                      color: Color(0xFF0CC0DF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Flexible(
              child: Divider(thickness: 2, indent: 40, color: Colors.white),
            ),
            Text(
              "   or   ",
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Flexible(
              child: Divider(thickness: 2, endIndent: 40, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Have an account?',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Log in',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
