import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../log_in.dart'; // If using GetX for navigation

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image that covers the entire screen
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/Images/moju.jpg'),
                fit: BoxFit.contain, // This ensures the image takes up the entire screen
              ),
            ),
          ),
          // Overlaying content, like a welcome message and button
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title or description
                Text(
                  'Welcome to the App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color to contrast with background
                  ),
                ),
                SizedBox(height: 30),
                // Button to navigate to the next page
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Button color
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: () {
                    // Navigate to the next page (e.g., login or home page)
                    Get.to(() => const login(), transition: Transition.leftToRight);
                  },
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
