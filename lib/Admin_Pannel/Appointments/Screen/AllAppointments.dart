// Myappointment.dart
import 'package:flutter/material.dart';
import '../../../Apicalls/Delete_Appointmerns.dart';
import '../Api/DeleteAppointment.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _fetchAppointments() async {
    if (isLoadingMore || !hasMore) return;

    setState(() {
      isLoadingMore = true;
    });

    try {
      final paginatedAppointments = await fetchAppointments(currentPage);

      setState(() {
        currentPage++;
        appointments.addAll(paginatedAppointments.appointments);
        hasMore = paginatedAppointments.nextPageUrl != null;
      });
    } catch (error) {
      print('Error fetching appointments: $error');
    } finally {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && hasMore) {
      _fetchAppointments();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
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
        title: const Text("All Appointments"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: appointments.length + (hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == appointments.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final appointment = appointments[index];
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

                    // Appointment Pending (Null Status) - Show Pay and Delete Buttons
                    if (appointment.appointmentStatus == null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Appointment Status: Payment Pending",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Pay Button
                              ElevatedButton(
                                onPressed: () {
                                  print("Redirect to payment for appointment ID: ${appointment.id}");
                                  // Implement payment functionality here
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

                              // Delete Button
                              ElevatedButton(
                                onPressed: () {

                                  _showDeleteConfirmation( appointment.id.toString());

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
                      ),

                    // Appointment Completed (Status = 1)
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

  void _showDeleteConfirmation( String appointmentId) {
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
                Navigator.of(context).pop(); // Dismiss after confirming
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteAppointment(String appointmentId) {
    print("Deleting appointment with ID: $appointmentId");
    // Implement appointment deletion API call here
  }
}
