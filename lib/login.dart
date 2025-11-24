import 'package:flutter/material.dart';
import 'register.dart';
import 'learning.dart';
import 'users.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    bool found = false;

    for (var user in Users) {
      if (user.email == email && user.password == password) {
        found = true;
        break;
      }
    }

    if (found) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LearningPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect email or password!"),
          backgroundColor: Color(0xFFF06292), // softer pinkish red
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome To Fun With Math ",
          style: TextStyle(
            color: Color(0xFF6A1B9A), // playful purple
            fontSize: 35,
          ),
        ),
        backgroundColor: const Color(0xFFA7FFEB), // solid mint aqua
        // foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFA7FFEB), // solid background (no gradient)
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // EMAIL
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 23,
                          color: Color(0xFF1565C0), // strong blue
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: emailController,
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                            fontSize: 21,
                            color: Color(0xFF1976D2), // stronger bright blue
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // PASSWORD
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 120,
                      child: Text(
                        'Password:',
                        style: TextStyle(
                          fontSize: 23,
                          color: Color(0xFF2E7D32), // strong green
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: passwordController,
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                            fontSize: 21,
                            color: Color(0xFF43A047), // stronger fresh green
                          ),
                        ),
                        obscureText: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // LOGIN BUTTON
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7043), // bright orange
                    foregroundColor: Colors.white, // white text
                  ),
                  onPressed: loginUser,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    child: Text(
                      "LOGIN",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // REGISTER LINK
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFE91E63), // hot pink
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
