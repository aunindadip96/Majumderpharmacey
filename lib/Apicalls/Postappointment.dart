/*
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
import 'package:flutter_easyloading/flutter_easyloading.dart';


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
    EasyLoading.show(status: "sending..");

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
        EasyLoading.showSuccess( "Your appointment is Created");

        Get.offAll(MyHomePage());

        EasyLoading.dismiss();
        // code to execute after 5 seconds
      });

      print(jsonEncode(response.body.toString()));

      final data = jsonDecode(response.body);

      Sucesscontroller.Tokennum = RxString(data['token']);
    } else {

      EasyLoading.showError( "Something Went Wrong");
      EasyLoading.dismiss();
      Get.offAll(MyHomePage());





      print(response.body);
    }
  }
}*/
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import '../Controllers/availavldayscontroller.dart';
import '../HomePage.dart';
import '../Modelclasses/creatappointmentmodelclass.dart';
import '../catagorywisedoctorlist.dart';
import 'Notifications_API.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class postappointment {
  final sucesscontroller successController = Get.find();

  Future<void> placeAppointment(
      String patientiD, doctorID, specalistID, daynumber) async {
    creatappointmentmodelclass obj = creatappointmentmodelclass(
        p_id: patientiD,
        d_id: doctorID,
        s_id: specalistID,
        appointment_date: successController.date.toString(),
        d_number: daynumber,
        token: " ");
    print(jsonEncode(obj.toJson()));

    final url = Uri.parse("https://dms.symbexit.com/api/make_appointment");
    EasyLoading.show(status: "sending..");

    try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode(obj.toJson()),
      );

      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200) {


        if(response.body=="401")
        {
          EasyLoading.showError("You already have an appointment with this doctor  ");
          EasyLoading.dismiss();
          Get.offAll(MyHomePage());


        }
        else{
          Noti.showBigTextNotification(
              title: "Doctor's Appointment",
              body: "Your Appointment is Created ",
              fln: flutterLocalNotificationsPlugin);

          successController.appointday = " ".obs;

          Future.delayed(const Duration(seconds: 2), () {
            EasyLoading.showSuccess("Your appointment is Created");

            Get.offAll(MyHomePage());

            EasyLoading.dismiss();
          });

          final data = jsonDecode(response.body);
          successController.Tokennum = RxString(data['token']);
        }

      }



      else {
        EasyLoading.showError("Something Went Wrong");
        EasyLoading.dismiss();
        Get.offAll(MyHomePage());

        print(response.body);
      }
    } catch (e) {
      EasyLoading.showError("Something Went Wrong");
      EasyLoading.dismiss();
      Get.offAll(MyHomePage());

      print(e.toString());
    }
  }
}