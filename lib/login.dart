import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'register.dart';
import 'learning.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  final String apiUrl = "http://eliehabka04.atwebpages.com/api/login.php";

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showMsg(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMsg("Email and password are required");
      return;
    }

    setState(() => isLoading = true);

    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "key": "password",
    };

    try {
      final response = await http
          .post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      final dynamic decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map &&
          decoded["success"] == true) {

        // ✅ Get the user ID from API response
        int userId = decoded["user_id"] ?? 0;

        showMsg("Login successful ✅");

        // ✅ Pass userId to LearningPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => LearningPage(userId: userId),
          ),
        );
      } else {
        final msg = (decoded is Map && decoded["message"] != null)
            ? decoded["message"].toString()
            : "Login failed";
        showMsg(msg);
      }
    } catch (e) {
      showMsg("Connection error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Welcome To Fun With Math ",
          style: TextStyle(
            color: Color(0xFF6A1B9A),
            fontSize: 35,
          ),
        ),
        backgroundColor: const Color(0xFFA7FFEB),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFA7FFEB),
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
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontSize: 21,
                            color: Color(0xFF1976D2),
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
                          color: Color(0xFF2E7D32),
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
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: 21,
                            color: Color(0xFF43A047),
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
                    backgroundColor: const Color(0xFFFF7043),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : loginUser,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    child: isLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
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
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Don't have an account? Register",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFE91E63),
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