
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import '../../../Appointments/MyAppointments.dart';
import '../../../Controllers/availavldayscontroller.dart';
import '../../AdminHompage/AdminHompage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Screen/AllAppointments.dart';

class admindeleteappointment {
  final sucesscontroller successController = Get.find();

  // Method to delete an appointment
  Future<void> Admindelete(String appointmentID) async {
    final url = Uri.parse("https://pharmacy.symbexbd.com/api/delete_appointments/$appointmentID");
    EasyLoading.show(status: "Deleting..");

    try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess("Appointment Deleted Successfully");

        Future.delayed(const Duration(seconds: 2), () {
          Get.offAll(allAppointment());
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.showError("Failed to delete appointment");
        EasyLoading.dismiss();
        Get.offAll(allAppointment());
      }
    } catch (e) {
      EasyLoading.showError("Something Went Wrong");
      EasyLoading.dismiss();
      Get.offAll(allAppointment());
    }
  }
}
