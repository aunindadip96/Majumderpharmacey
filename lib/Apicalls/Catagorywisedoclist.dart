import 'dart:async';
import 'dart:io';
import '../Modelclasses/modelclassfordoctorlist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class futurefordoclist{
 /*Future<List<ModelClassForDoctorList>> docinfo(String a) async {
    var url = Uri.parse("https://dms.symbexit.com/api/viewDoctor");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    final list = jsonData as List<dynamic>;
    print (list.toString());
    return list
        .map((e) => ModelClassForDoctorList.fromJson(e))
        .where((element) => element.specialistId
        .toString()
        .toLowerCase()
        .contains(a.toString().toLowerCase()))
        .toList();
  }*/

 Future<List<ModelClassForDoctorList>> docinfo(String a) async {
   var url = Uri.parse("https://dms.symbexit.com/api/viewDoctor");
   try {
     var data = await http.get(url).timeout(Duration(seconds: 10));
     var jsonData = json.decode(data.body);
     final list = jsonData as List<dynamic>;
     print(list.toString());
     return list
         .map((e) => ModelClassForDoctorList.fromJson(e))
         .where((element) =>
         element.specialistId
             .toString()
             .toLowerCase()
             .contains(a.toString().toLowerCase()))
         .toList();
   } on TimeoutException catch (e) {
     throw ('Timeout: $e');
   } on SocketException catch (e) {
     throw ('Network error: $e');
   } on http.ClientException catch (e) {
     throw ('Client error: $e');
   } catch (e) {
     throw ('Unexpected error: $e');
   }
 }}




 /* Stream<List<ModelClassForDoctorList>> docinfo(String a) async* {
    var url = Uri.parse("https://dms.symbexit.com/api/viewDoctor");
    var stop = false;
    while (!stop) {
      var data = await http.get(url);
      var jsonData = json.decode(data.body);
      final list = jsonData as List<dynamic>;
      yield list
          .map((e) => ModelClassForDoctorList.fromJson(e))
          .where((element) => element.specialistId
          .toString()
          .toLowerCase()
          .contains(a.toString().toLowerCase()))
          .toList();
      await Future.delayed(Duration(seconds: 1));
    }
  }
*/


