import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Apicalls/Catagorywisedoclist.dart';
import '../../../Controllers/availavldayscontroller.dart';
import '../../../Modelclasses/modelclassfordoctorlist.dart';
import '../../../Modelclasses/viewSpecialistModel.dart';
import '../../Appointments/ModelClass/allappointmentsModel.dart';
import '../Controlaer/dropdown_contollaer.dart';
import '../Model_Class/patient_info_model.dart';

class PatientSearchScreen extends StatefulWidget {
  @override
  _PatientSearchScreenState createState() => _PatientSearchScreenState();
}

class _PatientSearchScreenState extends State<PatientSearchScreen> {
  bool _isLoading = false;
  List<PatienInfo> _searchResults = [];
  List<PatienInfo> _patientList = [];
  bool _noResultsFound = false;
  TextEditingController _searchController = TextEditingController();
  PatienInfo? _selectedPatient;
  bool _showForm = false;

  Timer? _timer;

  final dropdownController = Get.put(DropdownController()); // Initialize the controller

  @override
  void initState() {
    super.initState();
    _fetchAllPatients(); // Fetch patient list on initialization
  }

  // Function to fetch the complete patient list
  Future<void> _fetchAllPatients() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse('https://pharmacy.symbexbd.com/api/patientlist'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _patientList =
              data.map((jsonItem) => PatienInfo.fromJson(jsonItem)).toList();
        });
      } else {
        setState(() {
          _noResultsFound = true;
        });
      }
    } catch (e) {
      setState(() {
        _noResultsFound = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to filter the patient list based on the query
  void _filterPatientList(String query) {
    final cleanedQuery = query.replaceFirst("+91", "").trim();

    if (cleanedQuery.isEmpty) {
      setState(() {
        _searchResults = [];
        _noResultsFound = false;
      });
      return;
    }

    setState(() {
      _searchResults = _patientList
          .where((patient) =>
      patient.patientId.toLowerCase().contains(cleanedQuery.toLowerCase()) ||
          patient.phone.toLowerCase().contains(cleanedQuery.toLowerCase()))
          .toList();
      _noResultsFound = _searchResults.isEmpty;
    });
  }

  // Function to show the patient form in a BottomSheet


  void _showPatientForm({PatienInfo? patient}) {
    // Reset the form fields and state
    dropdownController.resetDropdowns();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: patient?.patient ?? '',
                decoration: const InputDecoration(labelText: 'Patient Name'),
              ),
              TextFormField(
                initialValue: patient?.phone ?? '',
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                initialValue: patient?.email ?? '',
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                initialValue: patient?.address ?? '',
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),

              // Category Dropdown with GetX
              Obx(() {
                if (dropdownController.isCategoryLoading.value) {
                  return const CircularProgressIndicator();
                } else {
                  return DropdownButtonFormField<String>(
                    value: dropdownController.selectedCategory.value,
                    decoration: const InputDecoration(
                      labelText: 'Select Specialist Category',
                      border: OutlineInputBorder(),
                    ),
                    items: dropdownController.categories
                        .map((category) => DropdownMenuItem<String>(
                      value: category.id.toString(),
                      child: Text(category.specialist.toString()),
                    ))
                        .toList(),
                    onChanged: (value) {
                      dropdownController.selectedCategory.value = value;
                      if (value != null) {
                        dropdownController.fetchDoctors(value);
                      }
                    },
                  );
                }
              }),
              const SizedBox(height: 16),

              // Doctor Dropdown with GetX
              Obx(() {



                if (dropdownController.isDoctorLoading.value) {
                  return const CircularProgressIndicator();
                } else if (dropdownController.noDoctorsFound.value) {
                  return const Text('No doctors found.');
                } else {
                  final doctorItems = dropdownController.doctors.map((doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor.id.toString(),
                      child: Text(doctor.name),
                    );
                  }).toList();

                  return DropdownButtonFormField<String>(
                    value: dropdownController.selectedDoctor.value?.id.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Select Doctor',
                      border: OutlineInputBorder(),
                    ),
                    items: doctorItems,
                    onChanged: (value) {
                      final selectedDoctor = dropdownController.doctors
                          .firstWhere((doctor) => doctor.id.toString() == value);
                      dropdownController.onDoctorSelected(selectedDoctor);

                      print('Selected Doctor Details:');
                      print('ID: ${selectedDoctor.id}');
                      print('Name: ${selectedDoctor.name}');
                      print('Schedule Days: ${dropdownController.selectedDoctorScheduleDays}');
                      print('Schedule Days: ${dropdownController.selectedDoctorDates}');

                    },
                  );
                }
              }),

              // Button to open the calendar
              Obx(() {

                DateTime now = DateTime.now();
                DateTime firstSelectableDate = now;

                for (int i = 0; i < 7; i++) {if (dropdownController.selectedDoctorScheduleDays.contains(DateFormat('EEEE').format(firstSelectableDate)) || dropdownController.selectedDoctorScheduleDays.contains(DateFormat('yyyy-MM-dd').format(firstSelectableDate)))
                {
                  break;
                }
                firstSelectableDate = firstSelectableDate.add(const Duration(days: 1));
                }

                // Check if a doctor is selected
                if (dropdownController.selectedDoctor.value != null) {
                  return ElevatedButton(
                    onPressed: () async {
                      // Show the date picker
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: dropdownController.selectedDate.value ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 90)),
                      );
                      if (pickedDate != null) {
                        // Update the selected date in the controller
                        dropdownController.selectedDate.value = pickedDate;
                      }
                    },
                    child: const Text('Select Date'),
                  );
                } else {
                  return Container(); // Return an empty container if no doctor is selected
                }
              }),

              // Display selected date
              Obx(() {
                DateTime? selectedDate = dropdownController.selectedDate.value;
                return Text(
                  selectedDate != null
                      ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'
                      : 'No date selected',
                  style: const TextStyle(fontSize: 16),
                );
              }),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle save logic here
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: dropdownController.resetDropdowns,
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Patient'),
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Text(
                    '+91',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Enter Patient ID or Phone Number',
                    ),
                    onChanged: _filterPatientList,
                  ),
                ),
              ],
            ),
          ),

          // Search Results List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _noResultsFound
                ? const Center(child: Text('No results found.'))
                : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final patient = _searchResults[index];
                return ListTile(
                  title: Text(patient.patient),
                  subtitle: Text(patient.phone),
                  onTap: () {
                    setState(() {
                      _selectedPatient = patient;
                      _showForm = true;
                    });
                    _showPatientForm(patient: patient);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
