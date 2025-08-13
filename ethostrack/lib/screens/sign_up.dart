import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login.dart';

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController = TextEditingController();

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
              labelStyle: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
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
              labelStyle: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
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
              labelStyle: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
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
              labelStyle: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold),
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
            onPressed: () {},
            backgroundColor: Colors.white,
            child: Text(
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
              child: Divider(
                thickness: 2,
                indent: 40,
                color: Colors.white,
              ),
            ),
            Text("   or   ", style: GoogleFonts.montserrat(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold
            )),
            Flexible(
              child: Divider(
                thickness: 2,
                endIndent: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Have an account?', 
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage()
                    )
                  );
              }, 
              child: Text('Log in',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ],
        )
      ],
    );
  }
}
