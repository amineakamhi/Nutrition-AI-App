import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'hi_page.dart'; // Import the HiPage

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  String? _selectedSex;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Automatically focus on the text field and open the keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_nameFocusNode);
    });
  }

  final FocusNode _nameFocusNode = FocusNode();

  void _updateButtonState() {
    setState(() {
      _isButtonEnabled = _nameController.text.isNotEmpty &&
          _ageController.text.isNotEmpty &&
          _heightController.text.isNotEmpty &&
          _weightController.text.isNotEmpty &&
          _selectedSex != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Lottie Animation at the Top
              Container(
                height: 200.0,
                child: Lottie.asset('assets/welcome_animation.json'),
              ),
              SizedBox(height: 20.0),
              // Welcome Text
              Text(
                'Welcome',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              // Subtitle Text
              Text(
                "Let's get to know each other 😊",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              // Name Input Field
              TextField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white, // Set background color to white
                ),
                style:
                    TextStyle(color: Colors.black), // Set text color to black
                onChanged: (value) {
                  _updateButtonState();
                },
              ),
              SizedBox(height: 20.0),
              // Age Input Field
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white, // Set background color to white
                ),
                style:
                    TextStyle(color: Colors.black), // Set text color to black
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _updateButtonState();
                },
              ),
              SizedBox(height: 20.0),
              // Height (Taille) Input Field
              TextField(
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white, // Set background color to white
                ),
                style:
                    TextStyle(color: Colors.black), // Set text color to black
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _updateButtonState();
                },
              ),
              SizedBox(height: 20.0),
              // Weight Input Field
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  labelStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white, // Set background color to white
                ),
                style:
                    TextStyle(color: Colors.black), // Set text color to black
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _updateButtonState();
                },
              ),
              SizedBox(height: 20.0),
              // Sex Dropdown Field
              DropdownButtonFormField<String>(
                value: _selectedSex,
                decoration: InputDecoration(
                  labelText: 'Sex',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  fillColor: Colors.white, // Set background color to white
                ),
                style:
                    TextStyle(color: Colors.black), // Set text color to black
                items: ['Male', 'Female', 'Other']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSex = value;
                    _updateButtonState();
                  });
                },
              ),
              SizedBox(height: 30.0),
              // Next Button
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        // Navigate to HiPage with animation
                        Navigator.of(context).push(_createRoute());
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? Colors.blue[800]
                      : Colors.blueGrey, // Button color changes based on input
                  foregroundColor: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Animation for page transition
  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HiPage(
        userName: _nameController.text,
        age: _ageController.text,
        height: _heightController.text,
        weight: _weightController.text,
        sex: _selectedSex!,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Start the transition from the bottom
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
