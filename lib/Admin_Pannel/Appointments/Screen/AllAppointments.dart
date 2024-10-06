import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import '../../../Apicalls/Delete_Appointmerns.dart';
import '../../AdminHompage/AdminHompage.dart';
import '../Api/DeleteAppointment.dart';
import '../Api/Post_Payment_request.dart';
import '../ModelClass/Payment_Model.dart';
import '../ModelClass/allappointmentsModel.dart';
import '../Api/appointmentAPi.dart';

class allAppointment extends StatefulWidget {
  const allAppointment({super.key});

  @override
  State<allAppointment> createState() => _allAppointmenttState();
}

class _allAppointmenttState extends State<allAppointment> {
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMore = true;
  List<Appointment> appointments = [];
  List<Appointment> _filteredAppointments = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllAppointments(); // Fetch all appointments
    _scrollController.addListener(_scrollListener);

    // Add a listener to the search controller to filter appointments as the user types
    _searchController.addListener(_filterAppointments);
  }

  Future<void> _fetchAllAppointments() async {
    if (isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      while (hasMore) {
        final paginatedAppointments = await fetchAppointments(currentPage);

        setState(() {
          currentPage++;
          appointments.addAll(paginatedAppointments.appointments);
          hasMore = paginatedAppointments.nextPageUrl != null;
          _filteredAppointments = appointments; // Initially, all appointments are displayed
        });
      }
    } catch (error) {
      print('Error fetching appointments: $error');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }
  void refreshAppointments() async {
    setState(() {
      // Clear the current list of appointments
      appointments.clear();
      _filteredAppointments.clear();
      currentPage = 1; // Reset to the first page
      hasMore = true; // Reset hasMore flag
    });

    await _fetchAllAppointments(); // Fetch all appointments again
  }



  void _filterAppointments() {
    String searchQuery = _searchController.text.toLowerCase();

    setState(() {
      _filteredAppointments = appointments.where((appointment) {
        final doctorName = appointment.patient.phone.toLowerCase();
        return doctorName.contains(searchQuery);
      }).toList();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMore) {
      _fetchAllAppointments();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  Future<bool> _onWillPop() async {
    Get.to(() => const AdminMyHomePage(), transition: Transition.leftToRight);
    return false; // Returning false to prevent the default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:_onWillPop ,

      child: Scaffold(
        appBar: AppBar(


          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text("All Appointments",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.brown,
        ),
        body: Column(
          children: [
            // Search bar inside the body
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.white, // Search bar background color
                child: TextField(
                  keyboardType:
                  TextInputType.number,
                  controller: _searchController,

                  decoration: InputDecoration(
                    hintText: "Search by Paient's Number",
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12.0), // Padding inside the TextField
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredAppointments.length + (hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _filteredAppointments.length) {
                    return const Column(
                      children: [
                        SizedBox(height: 300),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    );
                  }

                  final appointment = _filteredAppointments[index];

                  // Access the doctor and patient details
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
                            // Doctor details
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
                            // Patient details
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
                              _buildPendingAppointmentActions(appointment, doctor, patient),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingAppointmentActions(Appointment appointment, Doctor doctor, Patient patient) {
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
                    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent),
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
                    adminPayment.makePayment(payment).then((_) {
                      Navigator.of(context).pop(); //// Dismiss the dialog
                      refreshAppointments();
                    }).catchError((error) {

                    });
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
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  admindeleteappointment delete = admindeleteappointment();

                  // Call your delete appointment API here
                  await delete.Admindelete(appointmentId);
                  Navigator.of(context).pop(); // Close the dialog

                  // After successful deletion, refresh the appointments
                  setState(() {
                    appointments.removeWhere((appointment) => appointment.id.toString() == appointmentId.toString());
                    _filteredAppointments.removeWhere((appointment) => appointment.id .toString()== appointmentId.toString());
                  });

                  // Optionally show a success message
                } catch (error) {
                  // Handle any errors here
                  print('Error deleting appointment: $error');
                  // Optionally show an error message
                }
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }


}
