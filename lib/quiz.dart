import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'learning.dart';

class Question {
  final String text;
  final String answer;
  final TextEditingController controller;

  Question(this.text, this.answer) : controller = TextEditingController();
}

class QuizPage extends StatefulWidget {
  final int userId;

  const QuizPage({super.key, required this.userId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Question> questions;
  int score = 0;
  bool submitted = false;
  List<dynamic> topQuizzes = [];

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

  void submitQuiz() async {
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

    await sendResult(widget.userId, tempScore);
  }

  Future<void> sendResult(int userId, int score) async {
    try {
      final response = await http.post(
        Uri.parse("http://eliehabka04.atwebpages.com/api/insert-quiz.php"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode({
          "user_id": userId,
          "score": score,
        }),
      );
    } catch (e) {
      // Silently handle error
    }
  }

  void newQuiz() {
    setState(() {
      questions = generateQuestions();
      score = 0;
      submitted = false;
    });
  }

  Future<void> fetchTopQuizzes() async {
    try {
      final response = await http.get(
        Uri.parse("http://eliehabka04.atwebpages.com/api/get-top10-quiz.php?user_id=${widget.userId}"),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          topQuizzes = data;
        });
      }
    } catch (e) {
      // Silently handle error
    }
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
            if (submitted)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  "Your score: $score / ${questions.length}",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            Expanded(
              child: ListView(
                children: [
                  // Quiz questions
                  ...questions.map((q) => Card(
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
                  )),
                  // Buttons
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7043),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          onPressed: submitQuiz,
                          child: const Text("SUBMIT QUIZ",
                              style: TextStyle(fontSize: 22)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A1B9A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          onPressed: newQuiz,
                          child: const Text("NEW QUIZ",
                              style: TextStyle(fontSize: 22)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7043),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LearningPage(userId: widget.userId),
                              ),
                            );
                          },
                          child: const Text("Back to Learning",
                              style: TextStyle(fontSize: 22)),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                          ),
                          onPressed: fetchTopQuizzes,
                          child: const Text("TOP 10 QUIZZES",
                              style: TextStyle(fontSize: 22)),
                        ),
                      ],
                    ),
                  ),
                  // Leaderboard
                  if (topQuizzes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Top 10 Quizzes",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...topQuizzes.asMap().entries.map((entry) {
                            int index = entry.key;
                            var quiz = entry.value;

                            // Determine medal/position
                            String position = "";
                            Color positionColor = const Color(0xFF1565C0);

                            if (index == 0) {
                              position = "🥇";
                              positionColor = const Color(0xFFFFD700); // Gold
                            } else if (index == 1) {
                              position = "🥈";
                              positionColor = const Color(0xFFC0C0C0); // Silver
                            } else if (index == 2) {
                              position = "🥉";
                              positionColor = const Color(0xFFCD7F32); // Bronze
                            } else {
                              position = "#${index + 1}";
                            }

                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              elevation: index < 3 ? 4 : 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Position
                                    SizedBox(
                                      width: 50,
                                      child: Text(
                                        position,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: positionColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // User info and score
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Username (if available)
                                          if (quiz['name'] != null)
                                            Text(
                                              quiz['name'],
                                              style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF1565C0),
                                              ),
                                            ),
                                          const SizedBox(height: 4),
                                          // Score
                                          Text(
                                            "Score: ${quiz['score']}",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF6A1B9A),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          // Date
                                          Text(
                                            "Date: ${quiz['date']}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
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