import 'package:flutter/material.dart';
import '../../../Apicalls/Delete_Appointmerns.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    // Payment confirmation logic
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
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                admindeleteappointment delete = admindeleteappointment();
                delete.Admindelete(appointmentId);
                Navigator.of(context).pop();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
