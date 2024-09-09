import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../log_in.dart';

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
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "Auto logger",
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
                height: screenHeight * 0.350,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("lib/assets/Images/pic2.jpg"),
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
                            color: Colors.black),
                      ),
                      Center(
                        child: Text(
                          "Let's Find Your Doctor",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCustomButton(
                    image: "https://via.placeholder.com/150",
                    text: "pH",
                    textValue: "7.5",
                    text2: "Temp",
                    text3: "24°C",
                    color: const Color.fromRGBO(208, 242, 230, 1),
                    onTap: () {
                      //...
                    },
                  ),
                  _buildCustomButton(
                    image: "https://via.placeholder.com/151",
                    text: "TDS",
                    textValue: "500 ppm",
                    text2: "Temp",
                    text3: "24°C",
                    color: const Color.fromRGBO(242, 223, 228, 1.0),
                    onTap: () {
                      //...
                    },
                  ),
                  _buildCustomButton(
                    image: "https://via.placeholder.com/152",
                    text: "DO",
                    textValue: "8 mg/L",
                    text2: "Temp",
                    text3: "24°C",
                    color: const Color.fromRGBO(174, 171, 245, 1.0),
                    onTap: () {
                      //...
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCustomButton(
                    image: "https://via.placeholder.com/153",
                    text: "EC",
                    textValue: "1.2 mS/cm",
                    text2: "Temp",
                    text3: "24°C",
                    color: const Color.fromRGBO(162, 242, 170, 1),
                    onTap: () {
                      //...
                    },
                  ),
                  _buildCustomButton(
                    image: "https://via.placeholder.com/154",
                    text: "ORP",
                    textValue: "250 mV",
                    text2: "Temp",
                    text3: "24°C",
                    color: const Color.fromRGBO(240, 200, 127, 1.0),
                    onTap: () {
                      //...
                    },
                  ),
                  _buildCustomButton(
                    image: "https://via.placeholder.com/157",
                    text: "NH3",
                    textValue: "0.5 mg/L",
                    text2: "Temp",
                    text3: "24°C",
                    color: const Color.fromRGBO(212, 119, 181, 1.0),
                    onTap: () {
                      //...
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCustomButton(
                    image: "https://via.placeholder.com/157",
                    text: "Auninda",
                    textValue: "Signout",
                    text2: "Signout",
                    text3: " ",
                    color: const Color.fromRGBO(212, 119, 181, 1.0),
                    onTap: () {
                      // Sign out code here...
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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
                Navigator.of(context).pop(false); // Return false to prevent exit
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
    )) ?? false;
  }

  Widget _buildCustomButton({
    required String image,
    required String text,
    required String textValue,
    required String text2,
    required String text3,
    required Color color,
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
                Text(
                  text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 2),
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
                          fontWeight: FontWeight.bold, fontSize: 19),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 2),
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
                          fontWeight: FontWeight.bold, fontSize: 19),
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
