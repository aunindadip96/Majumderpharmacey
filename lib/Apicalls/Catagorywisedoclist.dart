import '../Modelclasses/modelclassfordoctorlist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class futurefordoclist{

  Future<List<modelclassfordoctor>> docinfo(String a) async {
    var url = Uri.parse("https://dms.symbexit.com/api/viewDoctor");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    final list = jsonData as List<dynamic>;
    return list
        .map((e) => modelclassfordoctor.fromJson(e))
        .where((element) => element.specialistId
        .toString()
        .toLowerCase()
        .contains(a.toString().toLowerCase()))
        .toList();
  }


}