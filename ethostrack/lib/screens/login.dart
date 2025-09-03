import 'package:ethostrack/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                'Log in',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [LoginInputs()]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginInputs extends StatefulWidget {
  const LoginInputs({super.key});

  @override
  State<LoginInputs> createState() => _LoginInputsState();
}

class _LoginInputsState extends State<LoginInputs> {
  bool isPasswordVisible = false;
  bool isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    if (emailController.text.isEmpty) {
      _showErrorDialog('Please enter your email');
      return;
    }
    if (passwordController.text.isEmpty) {
      _showErrorDialog('Please enter your password');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      UserModel? user = await AuthService.logIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (user != null) {
        print('✅ Login exitoso para: ${user.username}');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()
            ),
          );
        }
      } else {
        _showErrorDialog('Login failed. Please check your credentials.');
      }
    } catch (e) {
      String errorMessage = 'Login failed. Please try again.';

      print('❌ Error en login: $e');

      if (e.toString().contains('user-not-found')) {
        errorMessage = 'No account found with this email.';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Incorrect password.';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Invalid email format.';
      } else if (e.toString().contains('user-disabled')) {
        errorMessage = 'This account has been disabled.';
      } else if (e.toString().contains('too-many-requests')) {
        errorMessage = 'Too many failed attempts. Please try again later.';
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
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          width: 300,
          child: FloatingActionButton(
            onPressed: isLoading ? null : _handleLogin,
            backgroundColor: isLoading ? Colors.grey : Colors.white,
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.grey,
                    strokeWidth: 2,
                  )
                : Text(
                    "Login",
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
              'Don\'t have an account?',
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
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                'Sign up',
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
