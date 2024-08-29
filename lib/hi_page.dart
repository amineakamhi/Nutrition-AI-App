import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

class HiPage extends StatefulWidget {
  final String userName;
  final String age;
  final String height;
  final String weight;
  final String sex;

  HiPage({
    required this.userName,
    required this.age,
    required this.height,
    required this.weight,
    required this.sex,
  });

  @override
  _HiPageState createState() => _HiPageState();
}

class _HiPageState extends State<HiPage> {
  String? selectedGoal;
  bool isLoading = false;
  Map<String, String> nutritionPlan = {};

  Future<void> _generateNutritionPlan() async {
    setState(() {
      isLoading = true;
    });

    final question =
        "Create a 7-day nutrition program for a person with the following details: "
        "Name: ${widget.userName}, Age: ${widget.age}, Height: ${widget.height} cm, Weight: ${widget.weight} kg, Sex: ${widget.sex}. "
        "Their goal is $selectedGoal. Please ensure breakfast, lunch, dinner, and snacks are consistent throughout the week and present them separately. "
        "Please provide the response in this format: 'breakfast: ', 'lunch: ', 'dinner: ', 'snacks: '. Do not include any additional text.";

    final String apiURL = "https://api.cohere.ai/v1/chat";
    final String apiKey = "m4W8ffP6CEsAbY94gDku8dJoOfSLKJOcTVpYpSz9";

    try {
      final response = await http.post(
        Uri.parse(apiURL),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'command-r-plus',
          'message': question,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _parseNutritionPlan(data['text']);
      } else {
        setState(() {
          nutritionPlan['Error'] =
              'Error fetching nutrition plan. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        nutritionPlan['Error'] =
            'Error fetching nutrition plan. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _parseNutritionPlan(String responseText) {
    final sections = responseText.split(':');
    final Map<String, String> plan = {};

    if (sections.length >= 2)
      plan['Breakfast'] = sections[1].split('lunch')[0].trim();
    if (sections.length >= 3)
      plan['Lunch'] = sections[2].split('dinner')[0].trim();
    if (sections.length >= 4)
      plan['Dinner'] = sections[3].split('snacks')[0].trim();
    if (sections.length >= 5) plan['Snacks'] = sections[4].trim();

    setState(() {
      nutritionPlan = plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/new2.jpg'), // Background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: isLoading
                ? Center(
                    child: Lottie.asset(
                      'assets/loading.json', // Replace with your Lottie file path
                      width: 150,
                      height: 150,
                    ),
                  )
                : nutritionPlan.isNotEmpty
                    ? ListView.builder(
                        itemCount: nutritionPlan.length,
                        itemBuilder: (context, index) {
                          final entry = nutritionPlan.entries.elementAt(index);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Card(
                              color: Colors.white.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 5,
                              child: ExpansionTile(
                                title: Center(
                                  child: Text(
                                    entry.key,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10.0),
                                    child: Center(
                                      child: Text(
                                        entry.value,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Lottie Animation at the Top
                          Container(
                            height: 300.0,
                            child: Lottie.asset(
                              'assets/welcome2_animation.json', // Replace with your Lottie file path
                            ),
                          ),
                          SizedBox(height: 20.0),
                          // Welcome message with selected goal
                          Text(
                            'Hello ${widget.userName}!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "What is your primary goal?",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          GoalOptionButton(
                            text: 'Losing weight',
                            icon: Icons.local_fire_department,
                            onPressed: () {
                              setState(() {
                                selectedGoal = 'Losing weight';
                              });
                              _generateNutritionPlan();
                            },
                            isSelected: selectedGoal == 'Losing weight',
                          ),
                          GoalOptionButton(
                            text: 'Gaining muscle and losing fat',
                            icon: Icons.fitness_center,
                            onPressed: () {
                              setState(() {
                                selectedGoal = 'Gaining muscle and losing fat';
                              });
                              _generateNutritionPlan();
                            },
                            isSelected:
                                selectedGoal == 'Gaining muscle and losing fat',
                          ),
                          GoalOptionButton(
                            text: 'Gaining muscle, losing fat is secondary',
                            icon: Icons.military_tech,
                            onPressed: () {
                              setState(() {
                                selectedGoal =
                                    'Gaining muscle, losing fat is secondary';
                              });
                              _generateNutritionPlan();
                            },
                            isSelected: selectedGoal ==
                                'Gaining muscle, losing fat is secondary',
                          ),
                          GoalOptionButton(
                            text: 'Eating healthier without losing weight',
                            icon: Icons.restaurant_menu,
                            onPressed: () {
                              setState(() {
                                selectedGoal =
                                    'Eating healthier without losing weight';
                              });
                              _generateNutritionPlan();
                            },
                            isSelected: selectedGoal ==
                                'Eating healthier without losing weight',
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class GoalOptionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isSelected;

  GoalOptionButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? Colors.greenAccent.shade100
              : Colors.white.withOpacity(0.8), // Change color if selected
          foregroundColor: Colors.black, // Text color
          padding: EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: isSelected ? Colors.greenAccent.shade700 : Colors.grey,
              width: 2.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon,
                color: isSelected ? Colors.greenAccent.shade700 : Colors.grey),
            SizedBox(width: 15),
            Text(
              text,
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
