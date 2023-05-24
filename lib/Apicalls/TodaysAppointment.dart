import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Modelclasses/Viewappointmentmodelclass.dart';

class daytoday{

  Future<List<viewappoinment>> dailyappointment (String id, date) async {
    var url = Uri.parse("https://dms.symbexit.com/api/all_appointments/$id");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    final list = jsonData as List<dynamic>;
    print(list.toString());

    return list
        .map((e) => viewappoinment.fromJson(e))
        .where((element) => element.appointmentDate.toString()
         .replaceAll("T00:00:00.000000Z", " ").contains(date.toString()) && element.appointmentStatus!="2")
        .toList();



  }


}