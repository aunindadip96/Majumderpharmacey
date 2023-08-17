import 'dart:async';
import 'dart:io';
import '../Modelclasses/modelclassfordoctorlist.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';




class futurefordoclist{

 Future<List<ModelClassForDoctorList>> docinfo(String a) async {
   var url = Uri.parse("https://pharmacy.symbexbd.com/api/viewDoctor");
   try {
     var data = await http.get(url).timeout(Duration(seconds: 10));
     var jsonData = json.decode(data.body);
     final list = jsonData as List<dynamic>;
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
 }
}







