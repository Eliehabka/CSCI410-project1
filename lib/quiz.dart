import 'package:flutter/material.dart';
import 'dart:math';
import 'learning.dart';
class Question {
  final String text;
  final String answer;
  final TextEditingController controller;

  Question(this.text, this.answer) : controller = TextEditingController();
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> questions;
  int score = 0;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    questions = generateQuestions();
  }

  List<Question> generateQuestions() {
    final rand = Random();

    int a1 = rand.nextInt(10);
    int b1 = rand.nextInt(10);

    int a2 = rand.nextInt(10);
    int b2 = rand.nextInt(10);

    int a3 = rand.nextInt(10);
    int b3 = rand.nextInt(10);

    int a4 = rand.nextInt(9) + 1;
    int b4 = rand.nextInt(9) + 1;

    int a5 = rand.nextInt(10);
    int b5 = rand.nextInt(10);

    return [
      Question("What is $a1 + $b1?", (a1 + b1).toString()),
      Question("What is $a2 - $b2?", (a2 - b2).toString()),
      Question("What is $a3 * $b3?", (a3 * b3).toString()),
      Question("What is $a4 / $b4?", (a4 / b4).toString()),
      Question("What is $a5 + $b5?", (a5 + b5).toString()),
    ];
  }


  void submitQuiz() {
    int tempScore = 0;
    for (var q in questions) {
      if (q.controller.text.trim() == q.answer) {
        tempScore++;
      }
    }
    setState(() {
      score = tempScore;
      submitted = true;
    });
  }

  void newQuiz() {
    setState(() {
      questions = generateQuestions();
      score = 0;
      submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Test Your Knowledge",
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
        child: Column(
          children: [
            // Score display at the top
            if (submitted)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "Your score: $score / ${questions.length}",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32), // strong green
                  ),
                ),
              ),

            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q.text,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: q.controller,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              fontSize: 24,
                              color: Color(0xFF6A1B9A),
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFE1F5FE),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: "Enter your answer",
                              hintStyle: const TextStyle(
                                fontSize: 22,
                                color: Color(0xFF43A047),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Buttons at the bottom
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7043),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: submitQuiz,
                    child: const Text(
                      "SUBMIT QUIZ",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1B9A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: newQuiz,
                    child: const Text(
                      "NEW QUIZ",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7043), // orange
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LearningPage()),
                      );
                    },
                    child: const Text(
                      "Back to Learning",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
