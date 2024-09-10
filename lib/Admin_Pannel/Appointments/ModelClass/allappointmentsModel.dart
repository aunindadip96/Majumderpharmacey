// ModelClass/appointment_model.dart
import 'dart:convert';

class PaginatedAppointments {
  final int currentPage;
  final List<Appointment> appointments;
  final String? nextPageUrl;

  PaginatedAppointments({
    required this.currentPage,
    required this.appointments,
    this.nextPageUrl,
  });

  factory PaginatedAppointments.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<Appointment> appointmentsList = list.map((i) => Appointment.fromJson(i)).toList();

    return PaginatedAppointments(
      currentPage: json['current_page'],
      appointments: appointmentsList,
      nextPageUrl: json['next_page_url'],
    );
  }
}

class Appointment {
  final int id;
  final String appointmentDate;
  final String token;
  final int? appointmentStatus;

  Appointment({
    required this.id,
    required this.appointmentDate,
    required this.token,
    this.appointmentStatus,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      appointmentDate: json['appointment_date'],
      token: json['token'],
      appointmentStatus: json['appointment_status'],
    );
  }
}
