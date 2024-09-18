import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../Apicalls/Catagorywisedoclist.dart';
import '../../../Controllers/availavldayscontroller.dart';
import '../../../Modelclasses/modelclassfordoctorlist.dart';
import '../../../Modelclasses/viewSpecialistModel.dart';
import '../../Appointments/ModelClass/allappointmentsModel.dart';
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

  List<String> daysList = [];
  Doctor? selectedDoctor;
  final successController = Get.find<sucesscontroller>();


  List<ModelClassForDoctorList> _doctors = [];


  bool _noDoctorsFound = false; // Track if no doctors are found




  String? _selectedDoctor; // Holds the selected doctor value
  bool _isDoctorLoading = false; // Track if doctors are being fetched


  Timer? _timer;

  // Category dropdown variables
  List<catagoryModel> _categories = [];
  String? _selectedCategory; // Holds the selected category value
  bool _isCategoryLoading = true; // Track if categories are being fetched

  @override
  void initState() {
    super.initState();
    _fetchAllPatients(); // Fetch patient list on initialization
    _fetchCategories(); // Fetch categories on initialization
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


  Future<void> _fetchDoctors(String categoryId) async {
    setState(() {
      _isDoctorLoading = true;
      _noDoctorsFound = false; // Reset no-doctors-found flag
    });

    try {
      final futureForDoctorList = futurefordoclist();
      final doctorsList = await futureForDoctorList.docinfo(categoryId);
      setState(() {
        _doctors = doctorsList;
        _noDoctorsFound = _doctors.isEmpty; // Set no-doctors-found flag
      });
    } catch (e) {
      // Handle error (you might want to show an error message)
    } finally {
      setState(() {
        _isDoctorLoading = false;
      });
    }
  }



  // Function to fetch categories for the dropdown
  Future<void> _fetchCategories() async {
    try {
      var url = Uri.parse("https://pharmacy.symbexbd.com/api/viewSpecialist");
      var data = await http.get(url);
      var jsonData = json.decode(data.body);
      final list = jsonData as List<dynamic>;
      setState(() {
        _categories = list.map((e) => catagoryModel.fromJson(e)).toList();
        _isCategoryLoading = false; // Categories have been fetched
      });
    } catch (e) {
      setState(() {
        _isCategoryLoading = false; // In case of error, stop loading
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
    // Function to handle category change
    void _onCategoryChanged(String? newCategory) {
      setState(() {
        _selectedCategory = newCategory;
        _selectedDoctor = null; // Clear the selected doctor when category changes
        _doctors = []; // Reset the list of doctors
        _isDoctorLoading = true; // Show loading indicator
        _noDoctorsFound = false; // Reset no-doctors-found flag
      });

      if (newCategory != null) {
        _fetchDoctors(newCategory).catchError((error) {
          setState(() {
            _isDoctorLoading = false; // Hide loading indicator
            _noDoctorsFound = true; // Show no doctors found message
          });
        });
      } else {
        setState(() {
          _isDoctorLoading = false;
          _noDoctorsFound = false;
        });
      }
    }

    // Reset the form fields and state
    void _resetForm() {
      setState(() {
        _searchController.clear();
        _selectedCategory = null;
        _selectedDoctor = null;
        _doctors = [];
        _noDoctorsFound = false;
        _isDoctorLoading = false;
      });
    }

    // Initialize the form fields and reset state when showing the form
    _resetForm();

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
          child: Stack(
            children: [
              SingleChildScrollView(
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

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Select Specialist Category',
                        border: OutlineInputBorder(),
                      ),
                      items: _categories
                          .map((category) => DropdownMenuItem<String>(
                        value: category.id.toString(),
                        child: Text(category.specialist.toString()),
                      ))
                          .toList(),
                      onChanged: _onCategoryChanged,
                    ),
                    const SizedBox(height: 16),

                    // Doctor Dropdown with Loading Screen
                    Stack(
                      children: [
                        DropdownButtonFormField<String>(
                          value: _selectedDoctor,
                          decoration: const InputDecoration(
                            labelText: 'Select Doctor',
                            border: OutlineInputBorder(),
                          ),
                          items: _isDoctorLoading
                              ? []
                              : _noDoctorsFound
                              ? []
                              : _doctors
                              .map((doctor) => DropdownMenuItem<String>(
                            value: doctor.id.toString(),
                            child: Text(doctor.name),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDoctor = value;
                            });
                          },
                        ),
                        if (_isDoctorLoading)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              child: Center(child: const CircularProgressIndicator()),
                            ),
                          ),
                        if (_noDoctorsFound)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black.withOpacity(0.3),
                              child: Center(child: const Text('No doctors found.', style: TextStyle(color: Colors.white))),
                            ),
                          ),
                      ],
                    ),
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
                          onPressed: _resetForm,
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }




  void _resetForm() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _selectedDoctor = null;
      _doctors = [];
      _noDoctorsFound = false;
      _isDoctorLoading = false;
    });
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
                    decoration: const InputDecoration(
                      labelText: 'Enter patient number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      _filterPatientList("+91" + value); // Prepend +91 for search
                    },
                  ),
                ),
              ],
            ),
          ),

          // Loading indicator
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_noResultsFound)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No patient found.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showPatientForm(); // Show empty form in BottomSheet
                    },
                    child: const Text("Create Appointment Manually"),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final patient = _searchResults[index];
                  return ListTile(
                    title: Text(patient.patient),
                    subtitle: Text(patient.phone),
                    onTap: () {
                      _showPatientForm(patient: patient); // Show form in BottomSheet with patient data
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
