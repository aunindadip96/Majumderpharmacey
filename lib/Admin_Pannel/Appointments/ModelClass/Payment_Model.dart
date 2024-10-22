class Payment {
  String appointmentId;
  String doctorId;
  String patientId;
  String appointmentDate;
  String earnings;
  String fees;
  String discountCategory;
  String discountAmount;
  String payableAmount;

  Payment({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.appointmentDate,
    required this.earnings,
    required this.fees,
    required this.discountCategory,
    required this.discountAmount,
    required this.payableAmount,
  });

  // Method to convert JSON to Payment object (for deserialization)
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      appointmentId: json['appointment_id'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      appointmentDate: json['appointment_date'],
      earnings: json['earnings'].toDouble(),
      fees: json['fees'].toDouble(),
      discountCategory: json['discount_category'],
      discountAmount: json['discount_amount'].toDouble(),
      payableAmount: json['payable_amount'].toDouble(),
    );
  }

  // Method to convert Payment object to JSON (for serialization)
  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'doctor_id': doctorId, 
      'patient_id': patientId,
      'appointment_date': appointmentDate,
      'commission': earnings,
      'doctor_fee': fees,
      'discount': discountCategory,
      'discount_amount': discountAmount,
      'payable_amount': payableAmount,
    };
  }
}
