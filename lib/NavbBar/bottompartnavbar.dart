
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MyAppointments.dart';
import '../log_in.dart';

myDrwaerlist() {
  return Container(
    padding: EdgeInsets.all(10),
    child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          icon: Icon(
            Icons.star_border_sharp,
            color: Colors.black,
          ),
          onPressed: () {
            Get.to(Myappointment());


          },
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "My Apponitments ",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),

        TextButton.icon(
            icon: Icon(
              Icons.animation,
              color: Colors.black,
            ),
            onPressed: () {},
            label: const Text(
              "My Profile",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
            )),

        TextButton.icon(
            icon: Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () async{
              SharedPreferences
              sharedPreferences =
              await SharedPreferences
                  .getInstance();
              sharedPreferences.remove("user");
              Get.to(login());
            },
            label: const Text(
              "SignOut",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16),
            )),

      ],
    ),
  );
}
