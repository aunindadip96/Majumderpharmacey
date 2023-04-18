import 'package:doctorappointment/Apicalls/Myappointments.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class Myappointment extends StatefulWidget {
  const Myappointment({super.key});

  @override
  State<Myappointment> createState() => _MyappointmentState();
}

class _MyappointmentState extends State<Myappointment> {
  var User;

  void initState() {
    _getuserinfo();
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

  Myappointments obj = new Myappointments();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Appointments"),
      ),
      body: User == null
          ? Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: obj.Myappointment(User["patient_key"].toString()),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data == null) {
                  return const Center(child: Text("sadf"));
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
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Specialist:" +
                                          snapshot.data[index].s.specialist,
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      DateFormat('dd MMMM, yyyy').format(
                                          DateTime.parse(snapshot
                                              .data[index].appointmentDate
                                              .replaceAll(
                                              "T00:00:00.000000Z", ""))),
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "Token Number :  " +
                                          snapshot.data[index].token.toString(),
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return (Center(
                    child: Text("Something Went Wrong "),
                  ));
                }
              }),
    );
  }
}
