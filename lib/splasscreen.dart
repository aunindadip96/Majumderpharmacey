import 'dart:async';
import 'dart:convert';
import 'package:doctorappointment/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in.dart';

class splashscreeen extends StatefulWidget {
  const splashscreeen({super.key});

  @override
  State<splashscreeen> createState() => _splashscreeenState();
}

class _splashscreeenState extends State<splashscreeen> {
  var Userdata;

  @override
  void initState() {
    validation().whenComplete(() async {
      Timer(Duration(seconds: 4),
          () => Get.to(Userdata == null ? const login() : const MyHomePage()));
    });

    super.initState();
  }

  Future validation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userJson = sharedPreferences.getString('user');

    var user = jsonDecode(userJson!);
    setState(() {
      Userdata = user;
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
