import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../log_in.dart';
import '../Appointments/Screen/AllAppointments.dart';
import '../Create_Appointment/Screen/SearchPatienDalegate.dart';
import '../Toadys Appointments/todays_appointment.dart';

class AdminMyHomePage extends StatefulWidget {
  const AdminMyHomePage({super.key});

  @override
  State<AdminMyHomePage> createState() => _AdminMyHomePageState();
}

class _AdminMyHomePageState extends State<AdminMyHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Show a confirmation dialog when the back button is pressed
        return await _showExitConfirmationDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown,
          title: const Text(
            "Logged In As Admin",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: screenHeight * 0.300,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("lib/assets/Images/admin.jpg"),
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Hello! ",
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Center(
                        child: Text(
                          "Manage Your Appointments",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true, // Prevents grid from scrolling independently
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4, // Number of grid items (3 buttons + sign out)
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.0, // Ratio of width to height
                ),
                itemBuilder: (context, index) {
                  // Return different buttons based on index
                  switch (index) {
                    case 0:
                      return _buildGradientButton(
                        label: "All Appointments",
                        gradientColors: [Colors.indigo, Colors.black],
                        onTap: () {
                          Get.to(() => const allAppointment(),
                              transition: Transition.leftToRight);
                        },
                      );
                    case 1:
                      return _buildGradientButton(
                        label: "Create Appointment",
                        gradientColors: [Colors.cyanAccent, Colors.green],
                        onTap: () {
                          Get.to(() => PatientSearchScreen(),
                              transition: Transition.leftToRight);
                        },
                      );
                    case 2:
                      return _buildGradientButton(
                        label: "Today's Appointment",
                        gradientColors: [Colors.deepPurple, Colors.red],
                        onTap: () {
                          Get.to(() => AllAppointmentToday(),
                              transition: Transition.leftToRight);
                        },
                      );
                    case 3:
                      return _buildGradientButton(
                        label: "Sign Out",
                        gradientColors: [Colors.blue, Colors.brown],
                        onTap: () async {
                          bool confirmSignOut = await _showSignOutConfirmationDialog();

                          if (confirmSignOut) {
                            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                            sharedPreferences.remove("adminuserinfo");

                            // Navigate to the login screen
                            Get.offAll(const login());
                          }
                          // If 'No' is pressed, the dialog will automatically dismiss
                        },
                      );

                    default:
                      return Container(); // Default empty container
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> _showSignOutConfirmationDialog() async {
    return (await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false (No)
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true (Yes)
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    )) ?? false;
  }


  Future<bool> _showExitConfirmationDialog() async {
    return (await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false to prevent exit
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop(); // Close the app
              },
              child: const Text('Exit'),
            ),
          ],
        );
      },
    )) ??
        false;
  }

  Widget _buildGradientButton({
    required String label,
    List<Color>? gradientColors, // Optional gradient colors
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors ??
                [Colors.blue, Colors.purple], // Default gradient if null
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(4, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
