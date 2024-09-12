import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Model_Class/patient_info_model.dart';

class SearchPatientDelegate extends SearchDelegate<String> {
  bool _isLoading = false;
  List<PatienInfo> _searchResults = [];
  List<PatienInfo> _patientList = []; // List to store all patients
  bool _noResultsFound = false;
  bool _isInitialLoad = true; // Flag to track initial load

  // Function to fetch the complete patient list
  Future<void> _fetchAllPatients(BuildContext context) async {
    _isLoading = true;
    _noResultsFound = false;

    try {
      final response = await http.get(
          Uri.parse('https://pharmacy.symbexbd.com/api/patientlist'));

      print('Response body: ${response.body}'); // Debugging statement

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _patientList = data.map((jsonItem) => PatienInfo.fromJson(jsonItem)).toList();
        print('Fetched ${_patientList.length} patients.');
      } else {
        _noResultsFound = true;
        print('Failed to fetch patients: ${response.statusCode}');
      }
    } catch (e) {
      _noResultsFound = true;
      print('Error fetching patients: $e');
    } finally {
      _isLoading = false;
      print('Fetching patients complete.');
      _filterPatientList(query); // Filter patient list after fetching
      if (!_isInitialLoad) {
        showSuggestions(context); // Refresh suggestions if not initial load
      }
      _isInitialLoad = false; // Update flag after first fetch
    }
  }

  // Function to filter the patient list based on the query
  void _filterPatientList(String query) {
    if (query.isEmpty) {
      _searchResults = _patientList; // Show all patients when query is empty
      _noResultsFound = _searchResults.isEmpty;
      return;
    }

    _searchResults = _patientList
        .where((patient) =>
    patient.patientId.toLowerCase().contains(query.toLowerCase()) ||
        patient.phone.toLowerCase().contains(query.toLowerCase()))
        .toList();

    _noResultsFound = _searchResults.isEmpty;
    print('Filtered ${_searchResults.length} patients for query: $query');
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    // Action buttons for clearing or resetting the search field
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            _searchResults = _patientList; // Reset search results to show all patients
            _noResultsFound = false;
            showSuggestions(context); // Refresh suggestions
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon (back button)
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Close the search and return to previous screen
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Show loading indicator if search is in progress
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Show "no results found" message
    if (_noResultsFound) {
      print('No results found.');
      return Padding(
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
                // Navigate to the page where users can create an appointment manually
                /* Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateAppointmentPage(), // Replace with your page
                  ),
                );*/
              },
              child: const Text("Create Appointment Manually"),
            ),
          ],
        ),
      );
    }

    // Show list of search results
    if (_searchResults.isEmpty) {
      print('No search results.');
      return const Center(
        child: Text('No results match your query.'),
      );
    } else {
      print('Displaying ${_searchResults.length} search results.');
    }

    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final patient = _searchResults[index];
        return ListTile(
          title: Text(patient.patient),
          subtitle: Text(patient.phone), // Show phone number
          onTap: () {
            // Select a search result and close the search delegate
            close(context, patient.patientId); // You can return any value you need
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Show loading indicator only when fetching data and not on initial load
    if (_isLoading && _patientList.isEmpty && !_isInitialLoad) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Fetch the patient list when the search page opens, only if not already fetched
    if (_patientList.isEmpty && _isInitialLoad) {
      _fetchAllPatients(context); // Fetch patient list if not already fetched
    }

    // Filter the patient list for suggestions based on the query
    _filterPatientList(query);

    // Show suggestions or placeholder
    return ListView(
      children: [

         if (query.isEmpty)
          ListTile(
            title: Text(
              "Search for patient by entering number or phone...",
              style: TextStyle(color: Colors.grey.shade400),
            ),
          )
        else if (_noResultsFound)
            ListTile(
              title: const Text(
                'No suggestions available.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            ..._searchResults.map((patient) => ListTile(
              title: Text(patient.patient),
              subtitle: Text(patient.phone), // Show phone number
              onTap: () {
                // Set query to selected suggestion and show results
                query = patient.patient;
                showResults(context);
              },
            )),
        // Optionally, you can add a button here as well
        if (_noResultsFound && query.isNotEmpty)
          ListTile(
            title: ElevatedButton(
              onPressed: () {
                /* Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateAppointmentPage(), // Replace with your page
                  ),
                );*/
              },
              child: const Text("Create Appointment Manually"),
            ),
          ),
      ],
    );
  }
}
