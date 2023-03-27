import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Controllers/availavldayscontroller.dart';
import '../MyAppointments.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Noti{

  static  final sucesscontroller Sucesscontroller = Get.find<sucesscontroller>();






  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = new IOSInitializationSettings();
    var initializationsSettings = new InitializationSettings(android: androidInitialize,
        iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String? payload) async {
     /* Get.to(AppointmentSucess(),transition: Transition.upToDown);*/

      Get.dialog(
        AlertDialog(
          title: Text('Doctor Appointment ',style: TextStyle(
            color: Colors.blueAccent
          ),),
          content: Text(
            "Doctor Name : ${Sucesscontroller.DocName}\n"
              "Day and Date :${Sucesscontroller.appointday},${Sucesscontroller.date}\n"
              "Token Number : ${Sucesscontroller.Tokennum} "
            ,style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
          actions: [
            TextButton(
              onPressed: () {
                Get.offAll(Myappointment());
              },
              child: Text('Go to Appointments'),
            ),
          ],
        ),
      );

    });
  }

  static Future showBigTextNotification({var id =0,required String title, required String body,
    var payload, required FlutterLocalNotificationsPlugin fln
  } ) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    new AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',

      /*   playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),*/
      importance: Importance.max,
      priority: Priority.high,


    );

    var not= NotificationDetails(android: androidPlatformChannelSpecifics,
        iOS: IOSNotificationDetails()
    );
    await fln.show(0, title, body,not );



  }

}
