
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import '../Controllers/availavldayscontroller.dart';
import '../HomePage.dart';
import '../Modelclasses/creatappointmentmodelclass.dart';
import '../catagorywisedoctorlist.dart';
import 'Notifications_API.dart';

class postappointment
{
  final sucesscontroller Sucesscontroller = Get.find();


  placeappointment(String patientiD, doctorID, specalistID, daynumber) async {
    creatappointmentmodelclass obj = creatappointmentmodelclass(
        p_id: patientiD,
        d_id: doctorID,
        s_id: specalistID,
        appointment_date: Sucesscontroller.appointday.toString(),
        d_number: daynumber,
        token: " ");
    var url = Uri.parse("https://dms.symbexit.com/api/make_appointment");

    var response = await http.post(
      url,
      headers: {"Content-type": "application/json"},
      body: json.encode(obj.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Noti.showBigTextNotification(
          title: "Doctor's Appointment",
          body: "Your Appointment is Created ",
          fln: flutterLocalNotificationsPlugin);

      Sucesscontroller.appointday = " ".obs;

      Future.delayed(Duration(seconds: 2), () {
        Get.offAll(MyHomePage());
        // code to execute after 5 seconds
      });

      print(jsonEncode(response.body.toString()));

      final data = jsonDecode(response.body);

      Sucesscontroller.Tokennum = RxString(data['token']);
    } else {
      print(response.body);
    }
  }
}