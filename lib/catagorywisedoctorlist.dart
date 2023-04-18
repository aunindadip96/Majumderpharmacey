import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'Apicalls/Catagorywisedoclist.dart';
import 'Controllers/availavldayscontroller.dart';
import 'Modelclasses/creatappointmentmodelclass.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Modelclasses/modelclassfordoctorlist.dart';
import 'log_in.dart';
import 'package:http/http.dart' as http;
import 'Apicalls/Notifications_API.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:doctorappointment/MyAppointments.dart';
import 'dart:convert';
import 'dart:io';
import 'Apicalls/Postappointment.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class catagoryisedoctorlist extends StatefulWidget {
  final String catagorwiseID, catagoryName;

  const catagoryisedoctorlist(
      {super.key, required this.catagorwiseID, required this.catagoryName});

  @override
  State<catagoryisedoctorlist> createState() => _catagoryisedoctorlistState();
}

class _catagoryisedoctorlistState extends State<catagoryisedoctorlist> {
  var User;
  List<String> daysList = [];
  var daynumber;
  var Datetoappointment;
  final sucesscontroller Sucesscontroller = Get.find();
  Timer? _timer;

  @override
  void initState() {
    _getuserinfo();
    super.initState();
    Noti.initialize(flutterLocalNotificationsPlugin);

    EasyLoading.addStatusCallback((status) {
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
  }

  void _getuserinfo() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    var userJson = localstorage.getString('user');
    var user = jsonDecode(userJson!);
    setState(() {
      User = user;
    });
  }

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
        appBar: AppBar(
          title: Text(widget.catagoryName),
          centerTitle: true,
        ),
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
                                  "lib/assets/Images/sorry_no_doc.jpg"),
                              fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Sorrry no Doctor is,",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        "Available",
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
                        child: Container(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              /*Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const homepage()),
                              );*/
                            },
                            child: const Text(
                              "Back to Hompage ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
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
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
                        child: Row(
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Name: " + snapshot.data[index].name,
                                                style: const TextStyle(fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                "Specealist: " + snapshot.data[index].specialist,
                                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                              for (var i = 0; i < snapshot.data[index].schedule.length; i++)
                                                Text(snapshot.data[index].schedule[i].day + "," + " " + DateFormat('h:mm a')
                                                    .format(DateTime.parse("1900-01-01 " + snapshot.data[index].schedule[i].startingTime)) +
                                                      " " + "-" + DateFormat('h:mm a').format(DateTime.parse("1900-01-01 " + snapshot.data[index].schedule[i].endingTime)),
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                  textAlign: TextAlign.left,
                                                  softWrap: false,
                                                ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Center(
                                                  child: TextButton(
                                                      onPressed: () async {
                                                        for (var i = 0; i < snapshot.data[index].schedule.length; i++)
                                                          daysList.add(snapshot.data[index].schedule[i].day);
                                                          daysList.add("2023-04-21");
                                                          DateTime now = DateTime.now();
                                                          DateTime firstSelectableDate = now;

                                                        for (int i = 0; i < 7; i++)
                                                        {
                                                          if (daysList.contains(DateFormat('EEEE').format(firstSelectableDate)) ||
                                                              daysList.contains(DateFormat('yyyy-MM-dd').format(firstSelectableDate)))
                                                          {
                                                            break;
                                                          }
                                                          firstSelectableDate = firstSelectableDate.add(Duration(days: 1));
                                                        }
                                                        Sucesscontroller.DocName = RxString(snapshot.data[index].name);
                                                        String doctorID = snapshot.data[index].id.toString();
                                                        String SpecalistID = snapshot.data[index].specialistId.toString();

                                                        bool isDateSelectable(DateTime? date) {
                                                          if (date == null) {
                                                            return false;
                                                          }
                                                          final weekday = DateFormat('EEEE').format(date);
                                                          final formattedDate = DateFormat('yyyy-MM-dd').format(date);

                                                          final forbiddenDates = ['2023-04-23', '2023-05-02'];
                                                          // specify the dates you want to exclude here

                                                          if (forbiddenDates.contains(formattedDate)) {
                                                            return false;
                                                          }

                                                          return daysList.contains(weekday) || daysList.contains(formattedDate);
                                                        }

                                                        bookbutton(DateTime.now(), firstSelectableDate, doctorID, SpecalistID, isDateSelectable);
                                                      },
                                                      child: const Text(
                                                        "Book Appointment",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      )))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return Text("I dont know");
              }
            }));
  }

  bookbutton(DateTime firstSelectableDate, DateTime initialDate, String Docid,
      specalistid, bool Function(DateTime?) isDateSelectable) async {
    DateTime startDate = initialDate;
    if (!isDateSelectable(startDate)) {
      startDate = firstSelectableDate;
      while (!isDateSelectable(startDate)) {
        startDate = startDate.add(Duration(days: 1));
      }
    }

    await showDatePicker(
            context: context,
            initialDate: startDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 60)),
            selectableDayPredicate: isDateSelectable)
        .then((date) {
      Sucesscontroller.SelectDate =
          RxString(DateFormat("yyyy-MM-dd").format(date!).toString());
      Datetoappointment = DateFormat("yyyy-MM-dd").format(date);
      daynumber = date.weekday;
      Sucesscontroller.appointday = RxString(DateFormat('EEEE').format(date));
      Sucesscontroller.date = RxString(DateFormat("yyyy-MM-dd").format(date));
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Appointment Booked!'),
          content: Text(
              'Do you want to make an appointment on  $Datetoappointment with Dr. ${Sucesscontroller.DocName.toString()}'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('No'),
              onPressed: () {
                // Here you can add any code that should be executed when the user taps on the "Cancel" button

                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () {
                postappointment objtopost = new postappointment();
                objtopost.placeappointment(User["patient_key"].toString(),
                    Docid, specalistid, daynumber.toString());
                // Here you can add any code that should be executed when the user taps on the "ok" button
                print('User tapped on "ok" button');

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
