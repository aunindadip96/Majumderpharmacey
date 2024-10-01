// Model class for the Patient data
import 'dart:convert';

class PatienInfo {
  final int id;
  final String patientId;
  final String patient;
  final String address;
  final String phone;
  final String email;
  final String username;
  final String password;
  final String? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Constructor
  PatienInfo({
    required this.id,
    required this.patientId,
    required this.patient,
    required this.address,
    required this.phone,
    required this.email,
    required this.username,
    required this.password,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory method to create a Patient instance from JSON
  factory PatienInfo.fromJson(Map<String, dynamic> json) {
    return PatienInfo(
      id: json['id'],
      patientId: json['patient_id'],
      patient: json['patient'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      deletedAt: json['deleted_at'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert a Patient instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'patient': patient,
      'address': address,
      'phone': phone,
      'email': email,
      'username': username,
      'password': password,
      'deleted_at': deletedAt,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// Example usage:
// Convert JSON response to a list of Patient objects
List<PatienInfo> parsePatients(String jsonString) {
  final List<dynamic> jsonData = json.decode(jsonString);
  return jsonData.map((jsonItem) => PatienInfo.fromJson(jsonItem)).toList();
}

// Convert a list of Patient objects to JSON string
String patientsToJson(List<PatienInfo> patients) {
  final List<Map<String, dynamic>> jsonData = patients.map((patient) => patient.toJson()).toList();
  return json.encode(jsonData);
}