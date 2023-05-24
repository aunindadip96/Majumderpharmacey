import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MyAppointments.dart';
import '../MyProfile.dart';
import '../MytodaysAppointment.dart';
import '../log_in.dart';

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


      TextButton.icon(
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

      TextButton.icon(
        onPressed: () async {
          SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
          sharedPreferences.remove("user");
          Get.offAll(const login());
          print(sharedPreferences.toString());

          },
        icon: const Icon(Icons.logout,
          color: Colors.black,),
        label: Row(
          children: const [
            SizedBox(
                width: 40.0), // add some spacing between the icon and the text
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
      ),

    ],
  );
}
