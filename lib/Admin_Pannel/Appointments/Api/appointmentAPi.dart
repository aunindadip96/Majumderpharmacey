// data_fetcher.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../ModelClass/allappointmentsModel.dart';

Future<PaginatedAppointments> fetchAppointments(int page) async {
  final url = Uri.parse('https://pharmacy.symbexbd.com/api/appointments?page=$page');
  final response = await http.get(url);

  if (response.statusCode == 200) {

    return PaginatedAppointments.fromJson(jsonDecode(response.body));
    print(response.body.toString());

  } else {
    throw Exception('Failed to load appointments');
  }
}

Future<PaginatedAppointments> TodayfetchAppointments( String date) async {
  final url = Uri.parse('https://pharmacy.symbexbd.com/api/allappointments');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print(response.body.toString());

    // Parse the JSON response
    var paginatedAppointments = PaginatedAppointments.fromJson(jsonDecode(response.body));

    // Filter the appointments by the given date
    List<Appointment> filteredAppointments = paginatedAppointments.appointments.where((appointment) {
      // Extract the date part from the appointmentDate
      String appointmentDate = appointment.appointmentDate.split('T')[0]; // Get only the date part
      return appointmentDate == date; // Compare with the provided date
    }).toList();

    // Return a new instance of PaginatedAppointments with the filtered appointments
    return PaginatedAppointments(
      currentPage: paginatedAppointments.currentPage,
      appointments: filteredAppointments,
      nextPageUrl: paginatedAppointments.nextPageUrl,
    );

  } else {
    throw Exception('Failed to load appointments');
  }
}




