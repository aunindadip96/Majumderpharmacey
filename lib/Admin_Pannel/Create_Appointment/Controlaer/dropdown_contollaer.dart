import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../Apicalls/Catagorywisedoclist.dart';
import '../../../Modelclasses/modelclassfordoctorlist.dart';
import '../../../Modelclasses/viewSpecialistModel.dart';
import 'package:intl/intl.dart'; // Make sure to import intl for date formatting

class DropdownController extends GetxController {
  var categories = <catagoryModel>[].obs;
  var selectedCategory = RxnString();
  var doctors = <ModelClassForDoctorList>[].obs;
  var selectedDoctor = Rxn<ModelClassForDoctorList>();
  var isCategoryLoading = true.obs;
  var isDoctorLoading = false.obs;
  var noDoctorsFound = false.obs;
  var selectedDate = Rxn<DateTime>();


  // Holds the selected doctor's specialist ID
  var selectedDoctorSpecialistId = Rxn<int>();

  // Holds the schedule days of the selected doctor
  var selectedDoctorScheduleDays = <String>[].obs;

  // Holds the selected doctor's forbidden dates
  var selectedDoctorDates = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      var url = Uri.parse("https://pharmacy.symbexbd.com/api/viewSpecialist");
      var data = await http.get(url);
      var jsonData = json.decode(data.body);
      final list = jsonData as List<dynamic>;
      categories.value = list.map((e) => catagoryModel.fromJson(e)).toList();
    } catch (e) {
      // Handle the error, e.g., show a message
    } finally {
      isCategoryLoading.value = false;
    }
  }

  Future<void> fetchDoctors(String categoryId) async {
    try {
      isDoctorLoading.value = true;
      noDoctorsFound.value = false;

      final futureForDoctorList = futurefordoclist();
      final doctorsList = await futureForDoctorList.docinfo(categoryId);
      doctors.value = doctorsList;
      noDoctorsFound.value = doctors.isEmpty;
    } catch (e) {
      // Handle the error, e.g., show a message
    } finally {
      isDoctorLoading.value = false;
    }
  }

  void resetDropdowns() {
    selectedCategory.value = null;
    selectedDoctor.value = null;
    doctors.clear();
    noDoctorsFound.value = false;
  }

  // Method to handle doctor selection
  void onDoctorSelected(ModelClassForDoctorList selectedDoctor) {
    this.selectedDoctor.value = selectedDoctor; // Store the selected doctor
    selectedDoctorSpecialistId.value = selectedDoctor.specialistId; // Store specialist ID
    selectedDoctorScheduleDays.value = selectedDoctor.schedule.map((s) => s.day).toList(); // Store schedule days
    selectedDoctorDates.value = selectedDoctor.dates.expand((d) => d.date).toList(); // Store forbidden dates
  }

  // Method to get available dates based on the selected doctor's schedule and forbidden dates
  List<DateTime> getAvailableDates() {
    DateTime now = DateTime.now();
    List<DateTime> availableDates = [];

    // Loop through the next 30 days (adjust as necessary)
    for (int i = 0; i < 30; i++) {
      DateTime date = now.add(Duration(days: i));
      String weekday = DateFormat('EEEE').format(date);
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      // Check if the day is available and not forbidden
      if (selectedDoctorScheduleDays.contains(weekday) || selectedDoctorDates.contains(formattedDate)) {
        availableDates.add(date);
      }
    }

    return availableDates.where((date) {
      return !selectedDoctorDates.contains(DateFormat('yyyy-MM-dd').format(date));
    }).toList(); // Filter out forbidden dates
  }
}
