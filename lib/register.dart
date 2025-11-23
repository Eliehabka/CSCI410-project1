import 'package:flutter/material.dart';
import 'login.dart';
import 'users.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int selectedGender = 1;

  final TextEditingController usernameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController ageC = TextEditingController();

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
                      MyTextField(hint: 'Password', controller: passwordC),
                    ],
                  ),
                  const SizedBox(height: 16),

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
                      MyTextField(hint: 'Age', controller: ageC, isNumber: true),
                    ],
                  ),
                  const SizedBox(height: 16),

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
                      Radio(
                        value: 1,
                        groupValue: selectedGender,
                        onChanged: (v) => setState(() => selectedGender = v!),
                      ),
                      const Text(
                        "Male",
                        style: TextStyle(
                          fontSize: 23,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: 2,
                        groupValue: selectedGender,
                        onChanged: (v) => setState(() => selectedGender = v!),
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
                    onPressed: () {
                      User newUser = User(
                        usernameC.text.trim(),
                        emailC.text.trim(),
                        passwordC.text.trim(),
                        int.tryParse(ageC.text.trim()) ?? 0,
                        selectedGender == 1 ? "Male" : "Female",
                      );
                      Users.add(newUser);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      child: Text(
                        "REGISTER",
                        style: TextStyle(fontSize: 22),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
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

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isNumber;

  const MyTextField({
    required this.hint,
    required this.controller,
    this.isNumber = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,
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
