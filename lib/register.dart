import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int selectedGender = 1;

  // Controllers
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController ageC = TextEditingController();

  bool isLoading = false;

  // ✅ Put your API URL here
  final String apiUrl = "http://eliehabka04.atwebpages.com/api/register.php";

  @override
  void dispose() {
    usernameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    ageC.dispose();
    super.dispose();
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  bool validateInputs() {
    if (usernameC.text.trim().isEmpty) {
      showMsg("Username is required");
      return false;
    }
    if (emailC.text.trim().isEmpty || !emailC.text.trim().contains("@")) {
      showMsg("Enter a valid email");
      return false;
    }
    if (passwordC.text.trim().length < 6) {
      showMsg("Password must be at least 6 characters");
      return false;
    }
    final age = int.tryParse(ageC.text.trim());
    if (age == null || age <= 0) {
      showMsg("Enter a valid age");
      return false;
    }
    return true;
  }

  Future<void> registerToPhp() async {
    if (!validateInputs()) return;

    setState(() => isLoading = true);

    final Map<String, dynamic> body = {
      "user_id": 0,
      "name": usernameC.text.trim(),
      "email": emailC.text.trim(),
      "password": passwordC.text.trim(),
      "age": int.tryParse(ageC.text.trim()) ?? 0,
      "gender": selectedGender == 1 ? "Male" : "Female",
      // If your PHP checks an API key, add it like this:
      // "key": "YOUR_API_KEY",
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "text/plain",
        },
        body: jsonEncode(body),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final msg = response.body.trim();
        showMsg("Server: $msg");

        // If register success, go to login
        if (msg.toLowerCase().contains("record added")) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      } else {
        showMsg("Server error: ${response.statusCode}");
      }
    } catch (e) {
      if (!mounted) return;
      showMsg("Request failed: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register Page",
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // USERNAME
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Username:',
                          style: TextStyle(
                            fontSize: 23,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      MyTextField(hint: 'Username', controller: usernameC),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // EMAIL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Email:',
                          style: TextStyle(
                            fontSize: 23,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      MyTextField(hint: 'Email', controller: emailC),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // PASSWORD
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Password:',
                          style: TextStyle(
                            fontSize: 23,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                      MyTextField(
                        hint: 'Password',
                        controller: passwordC,
                        isPassword: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // AGE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Age:',
                          style: TextStyle(
                            fontSize: 23,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                      MyTextField(
                        hint: 'Age',
                        controller: ageC,
                        isNumber: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // GENDER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 150,
                        child: Text(
                          'Gender:',
                          style: TextStyle(
                            fontSize: 23,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      Radio<int>(
                        value: 1,
                        groupValue: selectedGender,
                        onChanged: (v) => setState(() => selectedGender = v ?? 1),
                      ),
                      const Text(
                        "Male",
                        style: TextStyle(
                          fontSize: 23,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Radio<int>(
                        value: 2,
                        groupValue: selectedGender,
                        onChanged: (v) => setState(() => selectedGender = v ?? 2),
                      ),
                      const Text(
                        "Female",
                        style: TextStyle(
                          fontSize: 23,
                          color: Color(0xFFE91E63),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // REGISTER BUTTON
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7043),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: isLoading ? null : registerToPhp,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
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
                        "REGISTER",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Link
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Already have an account? Login",
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
      ),
    );
  }
}

// TextField widget
class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isNumber;
  final bool isPassword;

  const MyTextField({
    required this.hint,
    required this.controller,
    this.isNumber = false,
    this.isPassword = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(fontSize: 21, color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 21,
            color: hint == 'Email'
                ? const Color(0xFF1976D2)
                : hint == 'Password'
                ? const Color(0xFF43A047)
                : const Color(0xFF6A1B9A),
          ),
        ),
      ),
    );
  }
}