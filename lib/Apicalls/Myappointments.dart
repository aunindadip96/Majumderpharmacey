import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Modelclasses/Viewappointmentmodelclass.dart';

class Myappointments{

  Future<List<viewappoinment>> Myappointment (String id) async {
    var url = Uri.parse("https://dms.symbexit.com/api/all_appointments/$id");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    final list = jsonData as List<dynamic>;
    print(list.toString());

    return list
        .map((e) => viewappoinment.fromJson(e))
        .toList();

  }


}