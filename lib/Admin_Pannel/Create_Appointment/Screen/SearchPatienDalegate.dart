import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Apicalls/Postappointment.dart';
import '../../../Modelclasses/SignUpModelclass.dart';
import '../Api_Call/make_appointment.dart';
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
  bool isLoading = false; // Add a loading state variable

  Timer? _timer;

  final dropdownController = Get.put(DropdownController());

  @override
  void initState() {
    super.initState();
    _fetchAllPatients();
  }

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
              patient.patientId
                  .toLowerCase()
                  .contains(cleanedQuery.toLowerCase()) ||
              patient.phone.toLowerCase().contains(cleanedQuery.toLowerCase()))
          .toList();
      _noResultsFound = _searchResults.isEmpty;
    });
  }

  void _showPatientForm({PatienInfo? patient}) {
    // Initialize controllers with initial values or empty strings.
    TextEditingController patientNameController =
        TextEditingController(text: patient?.patient ?? '');
    TextEditingController phoneController =
        TextEditingController(text: patient?.phone ?? '');
    TextEditingController emailController =
        TextEditingController(text: patient?.email ?? '');
    TextEditingController addressController =
        TextEditingController(text: patient?.address ?? '');

    // Reset the form fields and state when showing the form.
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
              // Use controllers in TextFormFields to capture input.
              TextFormField(
                controller: patientNameController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              const SizedBox(height: 16),

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
                      // Update the selected category
                      dropdownController.selectedCategory.value = value;
                      dropdownController.selectedCategoryId.value =
                          int.parse(value!); // Store the selected category ID

                      // Fetch doctors for the selected category
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
                  // Create a list of DropdownMenuItems for doctors
                  final doctorItems = dropdownController.doctors.map((doctor) {
                    return DropdownMenuItem<String>(
                      value: doctor.id.toString(),
                      child: Text(doctor.name),
                    );
                  }).toList();

                  // Check if the selectedDoctor is valid, otherwise set to null
                  final selectedDoctorValue =
                      dropdownController.selectedDoctor.value?.id?.toString();
                  final isValidSelectedDoctor = doctorItems
                      .any((item) => item.value == selectedDoctorValue);

                  return DropdownButtonFormField<String>(
                    value: isValidSelectedDoctor
                        ? selectedDoctorValue
                        : null, // Reset if invalid
                    decoration: const InputDecoration(
                      labelText: 'Select Doctor',
                      border: OutlineInputBorder(),
                    ),
                    items: doctorItems,
                    onChanged: (value) {
                      if (value != null) {
                        final selectedDoctor = dropdownController.doctors
                            .firstWhere(
                                (doctor) => doctor.id.toString() == value);
                        dropdownController.onDoctorSelected(selectedDoctor);

                        print('Selected Doctor Details:');
                        print('ID: ${selectedDoctor.id}');
                        print('Name: ${selectedDoctor.name}');
                        print(
                            'Schedule Days: ${dropdownController.selectedDoctorScheduleDays}');
                        print(
                            'Forbidden Days: ${dropdownController.selectedDoctorDates}');
                      } else {
                        dropdownController.selectedDoctor.value =
                            null; // Reset if no value selected
                      }
                    },
                  );
                }
              }),

              SizedBox(height: 10),

              // Date Selection Button and Display
              Obx(() {
                DateTime now = DateTime.now();
                DateTime firstSelectableDate = now;
                bool dateFound = false;

                // Find the first selectable date based on the doctor's schedule and forbidden dates.
                for (int i = 0; i < 90; i++) {
                  String dayName =
                      DateFormat('EEEE').format(firstSelectableDate);
                  String formattedDate =
                      DateFormat('yyyy-MM-dd').format(firstSelectableDate);

                  // Check if the day is in the schedule and not in forbidden dates
                  bool isDaySelectable = dropdownController
                      .selectedDoctorScheduleDays
                      .contains(dayName);
                  bool isDayForbidden = dropdownController.selectedDoctorDates
                      .contains(formattedDate);

                  if (isDaySelectable && !isDayForbidden) {
                    dateFound = true;
                    break;
                  }

                  firstSelectableDate =
                      firstSelectableDate.add(const Duration(days: 1));
                }

                // Check if a doctor is selected.
                if (dropdownController.selectedDoctor.value != null) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (!dateFound) {
                        // Show toast if no available date is found within 90 days
                        Fluttertoast.showToast(
                          msg: "No available dates within the next 90 days.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        return; // Exit early if no date is found
                      }

                      // Show the date picker with selectable days predicate.
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: firstSelectableDate,
                        firstDate: firstSelectableDate,
                        lastDate: DateTime.now().add(Duration(days: 90)),
                        selectableDayPredicate: (DateTime date) {
                          String dayName = DateFormat('EEEE').format(date);
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(date);

                          // Check if the day is selectable.
                          bool isDaySelectable = dropdownController
                              .selectedDoctorScheduleDays
                              .contains(dayName);

                          // Check if the day is forbidden.
                          bool isDayForbidden = dropdownController
                              .selectedDoctorDates
                              .contains(formattedDate);

                          return isDaySelectable && !isDayForbidden;
                        },
                      );

                      if (pickedDate != null) {
                        // Update the selected date in the controller.
                        dropdownController.selectedDate.value = pickedDate;
                      }
                    },
                    child: const Text('Select Date'),
                  );
                } else {
                  return Container(); // Return an empty container if no doctor is selected.
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
                    onPressed: _isLoading
                        ? null // Disable the button when loading
                        : () {

                      String patientName = patientNameController.text;
                      String phone = phoneController.text;
                      String email = emailController.text;
                      String address = addressController.text;
                      String? selectedCategory =
                          dropdownController.selectedCategory.value;
                      String? selectedDoctor = dropdownController
                          .selectedDoctor.value?.id
                          ?.toString();
                      DateTime? selectedDate =
                          dropdownController.selectedDate.value;
                      String? weekday = dropdownController
                          .selectedDate.value?.weekday
                          .toString();

                      // Print the captured values to the console for debugging
                      print('Patient Name: $patientName');
                      print('Phone: $phone');
                      print('Email: $email');
                      print('Address: $address');
                      print('Selected Category: $selectedCategory');
                      print('Selected Doctor: $selectedDoctor');
                      print('Selected Date: $selectedDate');
                      print('Selected day: $weekday');

                      // Perform your save logic here with the retrieved values

                      // Close the modal after saving

                      CreatePatient(
                          patientName,
                          phone,
                          address,
                          email,
                          dropdownController.selectedCategoryId.toString(),
                          dropdownController.selectedDoctor.value!.id
                              .toString(),
                          dropdownController.selectedDate.toString(),
                          weekday);

                      // Your existing logic to capture and process the form data

                    },
                    child: _isLoading
                        ? const CircularProgressIndicator() // Show progress indicator
                        : const Text('Save'),
                  ),


                  ElevatedButton(
                    onPressed: () {
                      // Reset form fields
                      patientNameController.clear();
                      phoneController.clear();
                      emailController.clear();
                      addressController.clear();
                      dropdownController.resetDropdowns();
                      dropdownController.selectedDate.value =
                          null; // Reset the selected date
                    },
                    child: const Text('Reset'),
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
        title: const Text('Patient Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,

              keyboardType:
                  TextInputType.number, // Sets the keyboard to number input
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly, // Restricts input to digits only
              ],

              decoration: const InputDecoration(
                labelText: 'Search Patient by ID or Phone',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                _filterPatientList(query);
              },
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : _noResultsFound
                    ? Column(
                        children: [
                          const Text('No results found.'),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _showForm = true;
                                _selectedPatient = null;
                              });
                              _showPatientForm();
                            },
                            child: const Text('Create Appointment Manually'),
                          ),
                        ],
                      )
                    : Expanded(
                        child: ListView.builder(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> CreatePatient(
      String name,
      String email,
      String mobile,
      String address,
      String catagoryID,
      String docID,
      String day,
      String? weekday,
      ) async {
    setState(() {
      _isLoading = true; // Use _isLoading here
    });

    final random = Random();
    final externalId = (random.nextInt(900000) + 100000).toString(); // Generates a number between 100000 and 999999

    Signup signup = Signup(
      patient_id: externalId,
      patient: name,
      address: address,
      phone: mobile,
      email: email,
      username: name,
      password: mobile,
      external_id: externalId,
    );

    print('Creating patient with data: ${signup.toJson()}');

    var url = Uri.parse("https://pharmacy.symbexbd.com/api/createpatientlist");

    try {
      var response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(signup.toJson()),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        var body = json.decode(response.body);
        var patientKey = body['patientLogin']['patient_key'];
        print('Patient created successfully with patientKey: $patientKey');

        // Check if the required parameters are valid before calling the function
        if (patientKey != null && catagoryID.isNotEmpty && docID.isNotEmpty && weekday != null) {
          Adminpostappointment adminpostappointment = Adminpostappointment();

          print('Calling AdminmakeAppointmEnt with patientKey: $patientKey');
          adminpostappointment.AdminmakeAppointmEnt(
            patientKey.toString(),
            docID.toString(),
            catagoryID.toString(),

            weekday.toString(),
            dropdownController.selectedDate
                .toString()
                .replaceAll("00:00:00.000", " "),
          );
          print('AdminmakeAppointmEnt called successfully.');
        } else {
          print('Invalid parameters passed to AdminmakeAppointmEnt.');
        }

      } else {
        print('Failed to create patient. Error: ${response.body}');
        Fluttertoast.showToast(
          msg: "This account is already in use",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (error) {
      print('Error during patient creation: $error');
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }




}
