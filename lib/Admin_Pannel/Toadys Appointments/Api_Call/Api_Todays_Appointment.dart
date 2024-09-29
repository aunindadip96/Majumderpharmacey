import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Modelclasses/Viewappointmentmodelclass.dart';


class TodaysAppointmentAll{

  Future<List<viewappoinment>> dailyappointment ( date) async {
    var url = Uri.parse("https://pharmacy.symbexbd.com/api/allappointments");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    final list = jsonData as List<dynamic>;
    return list
        .map((e) => viewappoinment.fromJson(e))
        .where((element) => element.appointmentDate.toString()
        .replaceAll("T00:00:00.000000Z", " ").contains(date.toString()) )
        .toList();



  }


}