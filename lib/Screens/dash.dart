import 'package:flutter/material.dart';
import 'package:untitled/Screens/forms_screen.dart';

class dash extends StatefulWidget {
  const dash({super.key});

  @override
  State<dash> createState() => _dashState();
}
class _dashState extends State<dash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Your existing Center widget with Text.rich...
          Center(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'my',
                    style: TextStyle(fontSize: 20.0, color: Color(0xFFB64620)),
                  ),
                  TextSpan(
                    text: 'Suite',
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Color(0xFFB64620),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'App',
                    style: TextStyle(fontSize: 30.0),
                  ),
                ],
              ),
            ),
          ),
          // New positioned button with navigation
          Positioned(
            bottom: 100.0, // Adjust as needed
            right: 145.0, // Adjust as needed
            child: ElevatedButton(
              onPressed: () {
                // Use Navigator.push to navigate to forms_screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormScreen()),
                );
              },
              child: Text(
                "Get Started",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB64620),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

