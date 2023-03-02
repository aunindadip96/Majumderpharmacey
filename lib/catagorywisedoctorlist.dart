import 'dart:convert';
import 'package:doctorappointment/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'Modelclasses/creatappointmentmodelclass.dart';
import 'Modelclasses/modelclassfordoctorlist.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in.dart';

class catagoryisedoctorlist extends StatefulWidget {
  final String catagorwiseID;

  const catagoryisedoctorlist({super.key, required this.catagorwiseID});

  @override
  State<catagoryisedoctorlist> createState() => _catagoryisedoctorlistState();
}

class _catagoryisedoctorlistState extends State<catagoryisedoctorlist> {
  @override
  @override
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

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var dength;

    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: docinfo(widget.catagorwiseID),
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
                                                    onPressed: () {
                                                      Get.to(login(),
                                                          transition: Transition
                                                              .leftToRight);
                                                    },
                                                    child: Text("LogIn"))),
                                            Center(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      creatappointmentmodelclass
                                                          obj =
                                                          creatappointmentmodelclass(
                                                              p_id: User["Id"],
                                                              d_id: snapshot
                                                                  .data[index]
                                                                  .specialist,
                                                              s_id: snapshot
                                                                  .data[index]
                                                                  .specialistId
                                                                  .toString(),
                                                              appointment_date:
                                                                  "2023-2-23",
                                                              d_number: snapshot
                                                                  .data[index]
                                                                  .schedule
                                                                  .length
                                                                  .toString(),
                                                              token: " ");

                                                      print(jsonEncode(obj));
                                                    },
                                                    child: const Text(
                                                        "Book Appointment")))
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(onPressed: ()async{


                                        SharedPreferences sharedPreferences =
                                            await SharedPreferences.getInstance();
                                        sharedPreferences.remove("user");
                                        Get.to(login());


                                      }, child: Text("LogOut"))
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
