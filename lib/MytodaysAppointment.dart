import 'package:doctorappointment/Apicalls/Myappointments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Apicalls/TodaysAppointment.dart';

class todaysappointment extends StatefulWidget {
  const todaysappointment({super.key});

  @override
  State<todaysappointment> createState() => _todaysappointmentState();
}

class _todaysappointmentState extends State<todaysappointment> {
  var User;
  var day;
  var dateformatter;

  void initState() {
    _getuserinfo();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat("yyyy-MM-dd").format(now);
    day = formattedDate;
    super.initState();
  }

  void _getuserinfo() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    var userJson = localstorage.getString('user');
    var user = jsonDecode(userJson!);
    setState(() {
      User = user;
    });
  }

  daytoday obj = new daytoday();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todays Appointment"),
      ),
      body: User == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: obj.dailyappointment(
                  User["patient_key"].toString(), day.toString()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.toString() == "[]") {
                  return Scaffold(
                    backgroundColor: Colors.white,
                    body: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 80),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .3,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "lib/assets/Images/Appointment .jpg"),
                                fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "No Appointment ",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "For Today",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.00),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();

                            },
                            child: const Text(
                              "Back to Homepage ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return DefaultTabController(
                          length: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(5.0, 5.0), //(x,y)
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
                                      "Doctor Name: " +
                                          snapshot.data[index].d.doctor,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Specialist:" +
                                          snapshot.data[index].s.specialist,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(

                                      "Appointment Date :${DateFormat('dd MMMM, yyyy').format(
                                          DateTime.parse(snapshot
                                              .data[index].appointmentDate
                                              .replaceAll(
                                                  "T00:00:00.000000Z", "")))}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Token Number :  ${snapshot.data[index].token}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return Scaffold(
                    backgroundColor: Colors.white,
                    body: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 80),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .3,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "lib/assets/Images/Appointment .jpg"),
                                fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "No Appointment ",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "For Today",
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40.00),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();

                            },
                            child: const Text(
                              "Back to Homepage ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),
    );
  }
}
