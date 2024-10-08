
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import '../../../Apicalls/Notifications_API.dart';
import '../../../Controllers/availavldayscontroller.dart';
import '../../../Modelclasses/creatappointmentmodelclass.dart';
import '../../../catagorywisedoctorlist.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../Appointments/Screen/AllAppointments.dart';
import '../Controlaer/dropdown_contollaer.dart';

class Adminpostappointment {
  final sucesscontroller successController = Get.find();
  final dropdownController = Get.put(DropdownController());

  Future<void> AdminmakeAppointmEnt(
      String patientiD, doctorID, specalistID, daynumber,date) async {
    creatappointmentmodelclass obj = creatappointmentmodelclass(
        p_id: patientiD,
        d_id: doctorID,
        s_id: specalistID,
        appointment_date:date,
        d_number: daynumber,
        token: " ");

    print(obj.toJson());

    final url = Uri.parse("https://pharmacy.symbexbd.com/api/make_appointment");
    EasyLoading.show(status: "sending..");

    try {
      final response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: json.encode(obj.toJson()),
      );


      if (response.statusCode == 201 || response.statusCode == 200) {


        if(response.body=="401")
        {
          print(response.body.toString());

          EasyLoading.showError("You already have an appointment with this doctor  ");
          EasyLoading.dismiss();


        }
        else{

          print(response.body.toString());



          dropdownController.selectedDate.value=null;
          Future.delayed(const Duration(seconds: 1), () {
            EasyLoading.showSuccess("Your appointment is Created");


            EasyLoading.dismiss();
          });

          Get.to(() => const allAppointment(),
              transition: Transition.leftToRight);



        }

      }



      else {

        print(response.body.toString());
        EasyLoading.showError("Something Went Wrong");
        EasyLoading.dismiss();

      }
    } catch (e) {
      EasyLoading.showError("Something Went Wrong");
      EasyLoading.dismiss();

    }
  }
}