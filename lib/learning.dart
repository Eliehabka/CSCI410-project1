import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // needed for inputFormatters

class LearningPage extends StatefulWidget {
  const LearningPage({super.key});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  String operation = "+";
  final TextEditingController n1 = TextEditingController();
  final TextEditingController n2 = TextEditingController();

  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Learning Page",
          style: TextStyle(
            color: Color(0xFF6A1B9A), // playful purple
            fontSize: 35, // match LoginPage title
          ),
        ),
        backgroundColor: const Color(0xFFA7FFEB), // solid mint aqua
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFA7FFEB), // solid mint aqua background
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // DROPDOWN for operations
              DropdownButton(
                value: operation,
                style:const TextStyle(
                  fontSize:500,),
                items: const [
                  DropdownMenuItem(
                    value: "+",
                    child: Text("+", style: TextStyle(fontSize: 23, color: Color(0xFF1565C0))),
                  ),
                  DropdownMenuItem(
                    value: "-",
                    child: Text("-", style: TextStyle(fontSize: 23, color: Color(0xFF1565C0))),
                  ),
                  DropdownMenuItem(
                    value: "*",
                    child: Text("*", style: TextStyle(fontSize: 23, color: Color(0xFF1565C0))),
                  ),
                  DropdownMenuItem(
                    value: "/",
                    child: Text("/", style: TextStyle(fontSize: 23, color: Color(0xFF1565C0))),
                  ),
                ],
                onChanged: (v) {
                  setState(() => operation = v!);
                },
              ),

              const SizedBox(height: 20),

              // NUMBER 1
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text(
                      'Number 1:',
                      style: TextStyle(
                        fontSize: 23, // match LoginPage labels
                        color: Color(0xFF1565C0), // strong blue
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: n1,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 21, color: Colors.black),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Enter number",
                        hintStyle: TextStyle(
                          fontSize: 21, // match LoginPage hints
                          color: Color(0xFF1976D2), // stronger bright blue
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // NUMBER 2
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 150,
                    child: Text(
                      'Number 2:',
                      style: TextStyle(
                        fontSize: 23,
                        color: Color(0xFF2E7D32), // strong green
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: n2,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 21, color: Colors.black),
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: "Enter number",
                        hintStyle: TextStyle(
                          fontSize: 21,
                          color: Color(0xFF43A047), // stronger fresh green
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // SHOW RESULT BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7043), // bright orange
                  foregroundColor: Colors.white, // white text
                ),
                onPressed: () {
                  double a = double.tryParse(n1.text) ?? 0;
                  double b = double.tryParse(n2.text) ?? 0;
                  double r = 0;

                  if (operation == "+") r = a + b;
                  if (operation == "-") r = a - b;
                  if (operation == "*") r = a * b;
                  if (operation == "/") r = b == 0 ? 0 : a / b;

                  setState(() {
                    result = "Result = $r";
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  child: Text(
                    "SHOW RESULT",
                    style: TextStyle(fontSize: 22), // match LoginPage button
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // RESULT
              Text(
                result,
                style: const TextStyle(
                  fontSize: 24, // emphasis, matches LoginPage bold style
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A), // purple result text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
