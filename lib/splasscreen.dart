import 'dart:async';
import 'dart:convert';
import 'package:doctorappointment/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Admin_Pannel/AdminHompage/AdminHompage.dart';
import 'log_in.dart';

class splashscreeen extends StatefulWidget {
  const splashscreeen({super.key});

  @override
  State<splashscreeen> createState() => _splashscreeenState();
}

class _splashscreeenState extends State<splashscreeen> {
  var Userdata;
  var adminUserInfo;

  @override
  void initState() {
    super.initState();
    validation().whenComplete(() {
      Timer(Duration(seconds: 4), () {
        if (adminUserInfo != null) {
          // Navigate to Admin Home Page if adminUserInfo is not null
          Get.to(() => const AdminMyHomePage(), transition: Transition.leftToRight);
        } else if (Userdata != null) {
          // Navigate to User Home Page if Userdata is not null
          Get.to(() => const MyHomePage(), transition: Transition.leftToRight);
        } else {
          // Navigate to Login Page if both are null
          Get.to(() => const login(), transition: Transition.leftToRight);
        }
      });
    });
  }

  Future<void> validation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Retrieve user and admin user info from SharedPreferences
    var userJson = sharedPreferences.getString('user');
    var adminUserJson = sharedPreferences.getString('adminuserinfo');

    // Decode JSON data
    Userdata = userJson != null ? jsonDecode(userJson) : null;
    adminUserInfo = adminUserJson != null ? jsonDecode(adminUserJson) : null;

    setState(() {
      // Update state if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, // Change the background color here

      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              child: Icon(Icons.medical_services_rounded),
              radius: 50,
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
