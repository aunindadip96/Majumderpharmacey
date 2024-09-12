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
  final int? appointmentStatus;
  final String appointmentDate;
  final String token;
  final String? docFee;
  final String? appIncome;
  final Doctor doctor;
  final Patient patient;

  Appointment({
    required this.id,
    required this.appointmentDate,
    required this.token,
    required this.doctor,
    required this.patient,
    this.appointmentStatus,
    this.docFee,
    this.appIncome,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      appointmentDate: json['appointment_date'],
      token: json['token'],
      appointmentStatus: json['appointment_status'],
      docFee: json['doc_fee'],
      appIncome: json['app_income'],
      doctor: Doctor.fromJson(json['d']),
      patient: Patient.fromJson(json['p']),
    );
  }
}

class Doctor {
  final int id;
  final String doctorName;
  final String fees;
  final String phone;
  final String email;

  Doctor({
    required this.id,
    required this.doctorName,
    required this.fees,
    required this.phone,
    required this.email,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      doctorName: json['doctor'],
      fees: json['fees'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}

class Patient {
  final int id;
  final String patientName;
  final String address;
  final String phone;
  final String email;

  Patient({
    required this.id,
    required this.patientName,
    required this.address,
    required this.phone,
    required this.email,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      patientName: json['patient'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
    );
  }
}
