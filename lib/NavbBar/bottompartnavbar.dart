import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Appointments/MyAppointments.dart';
import '../MyProfile.dart';
import '../Appointments/MytodaysAppointment.dart';
import '../Notice/Notice_Screen.dart';
import '../log_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


myDrwaerlist() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ExpansionTile(
        leading: const Icon(
          Icons.schedule,
          color: Colors.black,
        ),
        title: const Text(
          'My Appointments',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          ListTile(
            title: const Text('Today Appointment'),
            onTap: () {
              Get.to(const todaysappointment());
            },
          ),
          ListTile(
            title: const Text('All Appointments'),
            onTap: () {
              Get.to(const Myappointment());

            },
          ),
        ],
      ),


      /*TextButton.icon(
        onPressed: ()  {
          Get.to(Myprofile());

          },
        icon: const Icon(Icons.logout,
          color: Colors.black,),
        label: Row(
          children: const [
            SizedBox(
                width: 40.0), // add some spacing between the icon and the text
            Text(
              "My Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),

*/






      TextButton.icon(
        onPressed: ()  {
          Get.to(NoticeListScreen());

        },
        icon: const Icon(Icons.logout,
          color: Colors.black,),
        label: Row(
          children: const [
            SizedBox(
                width: 40.0), // add some spacing between the icon and the text
            Text(
              "Notice",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),

      TextButton.icon(
        onPressed: () async {
          try {
            final GoogleSignIn _googleSignIn = GoogleSignIn();
            await _googleSignIn.signOut();
            print('User signed out from Google');

            // Remove external user ID from OneSignal
            OneSignal.shared.removeExternalUserId();

            // Clear user data from SharedPreferences
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.remove("user");

            // Navigate to the login screen
            Get.offAll(const login());
          } catch (e) {
            print('Error signing out: $e');
            Fluttertoast.showToast(
              msg: 'Error signing out: $e',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        },
        icon: const Icon(
          Icons.logout,
          color: Colors.black,
        ),
        label: Row(
          children: const [
            SizedBox(
              width: 40.0, // Add some spacing between the icon and the text
            ),
            Text(
              "Sign Out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      )

    ],
  );
}
