// data_fetcher.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ModelClass/allappointmentsModel.dart';

Future<PaginatedAppointments> fetchAppointments(int page) async {
  final url = Uri.parse('https://pharmacy.symbexbd.com/api/appointments?page=$page');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print(response.body.toString());

    return PaginatedAppointments.fromJson(jsonDecode(response.body));
    print(response.body.toString());

  } else {
    throw Exception('Failed to load appointments');
  }
}
