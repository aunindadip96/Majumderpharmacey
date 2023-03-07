import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'Apicalls/Catagorywisedoclist.dart';

import 'Controllers/availavldayscontroller.dart';
import 'Controllers/availavldayscontroller.dart';
import 'Modelclasses/creatappointmentmodelclass.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Modelclasses/modelclassfordoctorlist.dart';
import 'log_in.dart';
import 'package:http/http.dart' as http;

class catagoryisedoctorlist extends StatefulWidget {
  final String catagorwiseID;

  const catagoryisedoctorlist({super.key, required this.catagorwiseID});

  @override
  State<catagoryisedoctorlist> createState() => _catagoryisedoctorlistState();
}

class _catagoryisedoctorlistState extends State<catagoryisedoctorlist> {
  @override
  var User;
  List<String> daysList = [];
/*
final controller availabledays=Get.find();
*/
  var Datetoappointment;
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

/*
  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    // Retrieve available dates from API
    List<DateTime> availableDates = await _getAvailableDates();

    // Create a SelectableDayPredicate function that only allows available dates to be selectable
    final bool Function(DateTime) isAvailableDate = (DateTime day) {
      return availableDates.contains(day);
    };
*/

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    futurefordoclist doclist = new futurefordoclist();

    DateTime? findNextSelectableDate(
        DateTime startDate, Function(DateTime) selectableDayPredicate) {
      DateTime date = startDate;
      while (!selectableDayPredicate(date)) {
        date = date.add(Duration(days: 1));
      }
      return date;
    }

    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: doclist.docinfo(widget.catagorwiseID),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null) {
                return const Center(child: Text("sadf"));
              }

              if (snapshot.data.toString() == "[]") {
                return const Center(
                  child: Text("Sorry No Doctor Available"),
                );
              }

              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8),
                              child: Container(
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
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: const Image(
                                            image: AssetImage(
                                              "lib/assets/Images/pic2.jpg",
                                            ),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Name: " +
                                                  snapshot.data[index].name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              "Specealist: " +
                                                  snapshot
                                                      .data[index].specialist,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            const Text("Available Days :",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            for (var i = 0;
                                                i <
                                                    snapshot.data[index]
                                                        .schedule.length;
                                                i++)
                                              Text(
                                                snapshot.data[index].schedule[i]
                                                        .day +
                                                    "," +
                                                    " " +
                                                    DateFormat('h:mm a').format(
                                                        DateTime.parse(
                                                            "1900-01-01 " +
                                                                snapshot
                                                                    .data[index]
                                                                    .schedule[i]
                                                                    .startingTime)) +
                                                    " " +
                                                    "-" +
                                                    DateFormat('h:mm a').format(
                                                        DateTime.parse(
                                                            "1900-01-01 " +
                                                                snapshot
                                                                    .data[index]
                                                                    .schedule[i]
                                                                    .endingTime)),
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.left,
                                                softWrap: false,
                                              ),
                                            Center(
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      for (var i = 0;
                                                          i <
                                                              snapshot
                                                                  .data[index]
                                                                  .schedule
                                                                  .length;
                                                          i++)
                                                        daysList.add(snapshot
                                                            .data[index]
                                                            .schedule[i]
                                                            .day);

                                                      print(
                                                          daysList.toString());

                                                      String dddd = "Sunday";

                                                      DateTime now = DateTime.now();
                                                      DateTime firstSelectableDate = now;

                                                      for (int i = 0; i < 7; i++) {
                                                        if (daysList.contains(DateFormat('EEEE').format(firstSelectableDate))) {
                                                          break;
                                                        }
                                                        firstSelectableDate = firstSelectableDate.add(Duration(days: 1));
                                                      }


                                                      await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                        firstSelectableDate,
                                                        firstDate:
                                                            DateTime.now(),
                                                        lastDate: DateTime.now()
                                                            .add(Duration(
                                                                days: 10)),
                                                        selectableDayPredicate:
                                                            (DateTime date) {
                                                          final weekday =
                                                              DateFormat('EEEE')
                                                                  .format(date);

                                                          // Disable dates that are in the _disabledDates list
                                                          return daysList
                                                              .contains(
                                                                  weekday);
                                                        },
                                                      ).then((date) {
                                                        setState(() {
                                                          Datetoappointment =
                                                              DateFormat(
                                                                      "yyyy-MM-dd")
                                                                  .format(
                                                                      date!);
                                                        });
                                                      });

                                                      creatappointmentmodelclass
                                                          obj =
                                                          creatappointmentmodelclass(
                                                              p_id: User["id"]
                                                                  .toString(),
                                                              d_id: snapshot
                                                                  .data[index]
                                                                  .id
                                                                  .toString(),
                                                              s_id: snapshot
                                                                  .data[index]
                                                                  .specialistId
                                                                  .toString(),
                                                              appointment_date:
                                                                  Datetoappointment,
                                                              d_number: snapshot
                                                                  .data[index]
                                                                  .schedule
                                                                  .length
                                                                  .toString(),
                                                              token: " ");

                                                      print(jsonEncode(
                                                          obj.toJson()));
                                                    },
                                                    child: const Text(
                                                        "Book Appointment")))
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: () async {
                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            sharedPreferences.remove("user");
                                            Get.to(login());
                                          },
                                          child: Text("Sign Out"))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              } else {
                return Text("I dont know");
              }
            }));
  }

  Future<List<modelclassfordoctor>> docinfo(String a) async {
    var url = Uri.parse("https://dms.symbexit.com/api/viewDoctor");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    final list = jsonData as List<dynamic>;
    return list
        .map((e) => modelclassfordoctor.fromJson(e))
        .where((element) => element.specialistId
            .toString()
            .toLowerCase()
            .contains(a.toString().toLowerCase()))
        .toList();
  }
}
