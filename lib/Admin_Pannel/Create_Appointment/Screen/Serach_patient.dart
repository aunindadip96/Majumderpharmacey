import 'package:flutter/material.dart';

import 'SearchPatienDalegate.dart';

class SearchPatientPage extends StatelessWidget {
  const SearchPatientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "MDC",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Open the search delegate when search icon is tapped
              showSearch(
                context: context,
                delegate: SearchPatientDelegate(),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Tap the search icon to find patients.'),
      ),
    );
  }
}