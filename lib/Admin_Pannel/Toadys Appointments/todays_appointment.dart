import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../Modelclasses/Viewappointmentmodelclass.dart';
import '../AdminHompage/AdminHompage.dart';
import '../Appointments/Api/DeleteAppointment.dart';
import '../Appointments/Api/Post_Payment_request.dart';
import '../Appointments/ModelClass/Payment_Model.dart';
import '../Appointments/ModelClass/allappointmentsModel.dart';

class AllAppointmentToday extends StatefulWidget {
  const AllAppointmentToday({super.key});

  @override
  State<AllAppointmentToday> createState() => _AllAppointmentTodayState();
}

class _AllAppointmentTodayState extends State<AllAppointmentToday> {
  bool isLoading = true;
  List<Appointment> appointments = [];
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Default to today's date

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() {
      isLoading = true;
    });

    List<Appointment> newAppointments = await fetchAppointments();

    setState(() {
      appointments = newAppointments;
      isLoading = false;
    });
  }

  Future<List<Appointment>> fetchAppointments() async {
    var url = Uri.parse("https://pharmacy.symbexbd.com/api/allappointments");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      final list = jsonData as List<dynamic>;

      return list
          .map((e) => Appointment.fromJson(e))
          .where((element) => element.appointmentDate.toString()
          .replaceAll("T00:00:00.000000Z", " ")
          .contains(selectedDate))
          .toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => const AdminMyHomePage(), transition: Transition.leftToRight);
          },
        ),
        title: const Text(
          "Today's Appointments",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                DateFormat('dd MMM yyyy').format(DateTime.parse(selectedDate)),
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : appointments.isEmpty
          ? const Center(child: Text("No Appointments Found"))
          : ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          final doctor = appointment.doctor;
          final patient = appointment.patient;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(5.0, 5.0),
                    blurRadius: 8.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Appointment ID: ${appointment.id}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Appointment Date: ${appointment.appointmentDate.toString().replaceAll('T00:00:00.000000Z', '')}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Token: ${appointment.token}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Doctor: ${doctor.doctorName}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    Text(
                      "Doctor Fees: ${doctor.fees}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Doctor Phone: ${doctor.phone}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Patient: ${patient.patientName}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    Text(
                      "Patient Address: ${patient.address}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Patient Phone: ${patient.phone}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (appointment.appointmentStatus == null)
                      _buildPendingActions(appointment, patient, doctor),
                    if (appointment.appointmentStatus == 1)
                      const Text(
                        "Appointment Status: Completed",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPendingActions(Appointment appointment, Patient patient, Doctor doctor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Appointment Status: Payment Pending",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                _showPaymentConfirmation(
                  appointment.id.toString(),
                  appointment.token,
                  appointment.appointmentDate.replaceAll('T00:00:00.000000Z', ''),
                  appointment.docFee.toString(),
                  appointment.appIncome.toString(),
                  patient.patientName.toString(),
                  doctor.doctorName.toString(),
                  doctor.id.toString(),
                  patient.id.toString(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Pay"),
            ),
            ElevatedButton(
              onPressed: () {
                _showDeleteConfirmation(appointment.id.toString());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("Delete"),
            ),
          ],
        ),
      ],
    );
  }
  void _showPaymentConfirmation(
      String appointmentId,
      String token,
      String appointmentDate,
      String Doc_fee,
      String commission,
      String patientName,
      String DocName,
      String Doc_ID,
      String Patient_ID,
      ) {
    String selectedDiscountType = "No Discount"; // Default selected option
    double discount = 0.0; // Default discount value
    String discountCategory = "1"; // Default discount category (No Discount)

    // Parse the fees to double for calculation
    double doctorFee = double.tryParse(Doc_fee) ?? 0.0;
    double hospitalCommission = double.tryParse(commission) ?? 0.0;

    // Calculate the total payable amount
    double totalPayable = doctorFee + hospitalCommission;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Confirm Payment"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Appointment ID: $appointmentId"),
                  Text("Token: $token"),
                  Text("Doctor's Fee: ₹${doctorFee.toStringAsFixed(2)}"),
                  Text("Hospital Commission: ₹${hospitalCommission.toStringAsFixed(2)}"),

                  // Display total payable sum
                  const SizedBox(height: 10),
                  Text(
                    "Total Payable: ₹${(totalPayable - discount).toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  Text("Patient Name: $patientName"),
                  Text("Doctor Name: $DocName"),
                  Text("Appointment Date: ${appointmentDate.replaceAll('T00:00:00.000000Z', '')}"),
                  const SizedBox(height: 10),

                  // Dropdown for selecting discount type
                  const Text(
                    "Select Discount Type:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String>(
                    value: selectedDiscountType,
                    items: <String>['Doctor Discount', 'Admin Discount', 'No Discount']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDiscountType = newValue!;
                        // Update discount category based on the selected discount type
                        if (selectedDiscountType == 'No Discount') {
                          discount = 0.0;
                          discountCategory = "1"; // No Discount
                        } else if (selectedDiscountType == 'Doctor Discount') {
                          discountCategory = "2"; // Doctor Discount
                        } else if (selectedDiscountType == 'Admin Discount') {
                          discountCategory = "3"; // Hospital/Admin Discount
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 10),

                  // Discount input field, enabled only if a discount type other than 'No Discount' is selected
                  const Text(
                    "Enter Discount Amount:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter discount in ₹',
                    ),
                    enabled: selectedDiscountType != 'No Discount', // Disable input if 'No Discount' is selected
                    onChanged: (String? newValue) {
                      setState(() {
                        discount = double.tryParse(newValue ?? '0') ?? 0.0;
                      });
                    },
                    onSubmitted: (String? newValue) {
                      setState(() {
                        // Format the discount value to 2 decimal places after input
                        discount = double.tryParse(newValue ?? '0') ?? 0.0;
                      });
                    },
                  ),

                  const SizedBox(height: 10),
                  Text(
                    "Discount: ₹${discount.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Are you sure you want to proceed with the payment?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Payment payment = Payment(
                      appointmentId: appointmentId,
                      doctorId: Doc_ID,
                      patientId: Patient_ID,
                      appointmentDate: appointmentDate,
                      earnings: hospitalCommission.toString(),
                      fees: doctorFee.toString(),
                      discountCategory: discountCategory, // Set the correct discount category
                      discountAmount: discount.toString(),
                      payableAmount: (totalPayable - discount).toStringAsFixed(2),
                    );

                    print(payment.toJson());

                    AdminMakePayment adminPayment = AdminMakePayment();

                    adminPayment.makePayment(payment);

                    Navigator.of(context).pop(); // Dismiss the dialog

/*
                    _processPayment(appointmentId, selectedDiscountType); // Pass selected discount type
*/
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Confirm Payment"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(String appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this appointment?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                admindeleteappointment delete = admindeleteappointment();
                delete.Admindelete(appointmentId);
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
