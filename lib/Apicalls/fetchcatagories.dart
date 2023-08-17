import 'dart:convert';
import 'package:doctorappointment/Modelclasses/viewSpecialistModel.dart';
import 'package:http/http.dart' as http;


Future<List<catagoryModel>> fetchCategories() async {
  return Future.delayed(Duration(seconds: 2), () async {
    var url = Uri.parse("https://pharmacy.symbexbd.com/api/viewSpecialist");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    final list = jsonData as List<dynamic>;
    return list.map((e) => catagoryModel.fromJson(e)).toList();
  });



}
