import 'dart:async';
import 'dart:convert';
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildCustomButton(
                    image: "https://via.placeholder.com/157",
                    text: "NH3",
                    textValue: "0.5 mg/L",
                    text2: "Temp",
                    text3: "24°C",
                    color: const Color.fromRGBO(212, 119, 100, 1.0),
                    onTap: () {
                      Get.to(() => const allAppointment(),
                          transition: Transition.leftToRight);

                      //...
                    },
                  ),
                  _buildCustomButton(
                    text2: "Create Appointment",
                    color: const Color.fromRGBO(300, 150, 100, 1.0),
                    onTap: () {
                      Get.to(() => PatientSearchScreen(),
                          transition: Transition.leftToRight); // Open the sea
                    },
                  ),
                  _buildCustomButton(
                    text2: "Today's Appointment",
                    color: const Color.fromRGBO(300, 150, 100, 1.0),
                    onTap: () {
                      Get.to(() => AllAppointmentToday(),
                          transition: Transition.leftToRight); // Open the sea
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove("adminuserinfo");

                  // Navigate to the login screen
                  Get.offAll(const login());
                },
                child: const Text("Sign Out"),
              ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildCustomButton({
    String? image, // Optional
    String? text, // Optional
    String? textValue, // Optional
    String? text2, // Optional
    String? text3, // Optional
    Color color = Colors.blue, // Default color if not provided
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          height: 160,
          width: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (text != null) // Only display if not null
                  Text(
                    text,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                const SizedBox(height: 2),
                if (textValue != null) // Only display if not null
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.blueGrey,
                          offset: Offset(5.0, 5.0), //(x,y)
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textValue,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ),
                if (text2 != null) // Only display if not null
                  const SizedBox(height: 2),
                if (text2 != null)
                  Text(
                    text2,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 10),
                  ),
                if (text3 != null) // Only display if not null
                  const SizedBox(height: 2),
                if (text3 != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.blueGrey,
                          offset: Offset(5.0, 5.0), //(x,y)
                          blurRadius: 8.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text3,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
