import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Import the SplashScreen widget

void main() => runApp(NutritionApp());

class NutritionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition AI App',
      home: SplashScreen(), // Set SplashScreen as the home screen
      debugShowCheckedModeBanner: false,
    );
  }
}
