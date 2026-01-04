import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'quiz.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LearningPage extends StatefulWidget {
  final int userId; // ✅ Add userId parameter

  const LearningPage({super.key, required this.userId});

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  String? operation;
  List<String> operators = [];

  final TextEditingController n1 = TextEditingController();
  final TextEditingController n2 = TextEditingController();
  String result = "";

  @override
  void initState() {
    super.initState();
    fetchOperators();
  }

  Future<void> fetchOperators() async {
    final response = await http.get(
      Uri.parse("http://eliehabka04.atwebpages.com/api/get-operator.php"),
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        operators = data.map((e) => e['symbol'] as String).toList();
        if (operators.isNotEmpty) {
          operation = operators.first;
        }
      });
    } else {
      print("Failed to load operators");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learning Page")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dynamic Dropdown
            if (operators.isNotEmpty)
              DropdownButton<String>(
                value: operation,
                items: operators.map((op) {
                  return DropdownMenuItem(
                    value: op,
                    child: Text(op, style: const TextStyle(fontSize: 23)),
                  );
                }).toList(),
                onChanged: (v) {
                  setState(() => operation = v);
                },
              )
            else
              const CircularProgressIndicator(),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 150,
                  child: Text(
                    'Number 1:',
                    style: TextStyle(
                      fontSize: 23,
                      color: Color(0xFF1565C0),
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
                        fontSize: 21,
                        color: Color(0xFF1976D2),
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
                      color: Color(0xFF2E7D32),
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
                        color: Color(0xFF43A047),
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
                backgroundColor: const Color(0xFFFF7043),
                foregroundColor: Colors.white,
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
                  style: TextStyle(fontSize: 22),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // RESULT
            Text(
              result,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A1B9A),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7043),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                // ✅ Pass userId to QuizPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(userId: widget.userId),
                  ),
                );
              },
              child: const Text(
                "go to quiz",
                style: TextStyle(fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}