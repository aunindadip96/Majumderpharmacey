import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Modelclasses/modelclassfordoctorlist.dart';

class catagoryisedoctorlist extends StatefulWidget {
  final String catagorwiseID;

  const catagoryisedoctorlist({super.key, required this.catagorwiseID});

  @override
  State<catagoryisedoctorlist> createState() => _catagoryisedoctorlistState();
}

class _catagoryisedoctorlistState extends State<catagoryisedoctorlist> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
            future: docinfo(widget.catagorwiseID),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
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
                                  const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 2),
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
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: const Image(
                                          image: AssetImage(
                                            "lib/assets/Images/pic2.jpg",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Name: " +
                                              snapshot.data[index].name),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text("Specealist: " +
                                              snapshot.data[index].specialist),
                                          /*Text(snapshot.data[index].appointmentSchedule[index].day)*/

                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              for (var i = 0;
                                                  i <
                                                      snapshot
                                                          .data[index]
                                                          .appointmentSchedule
                                                          .length;
                                                  i++)
                                                Text.rich(
                                                  TextSpan(
                                                    text: "Available days " + snapshot.data[index].appointmentSchedule[i].day,
                                                    style: TextStyle(fontSize: 16),
                                                    children: [
                                                      TextSpan(
                                                        text: "\n",
                                                        style: TextStyle(height: 1.5),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.left,
                                                  softWrap: false,
                                                )
                                            ],
                                          ),
                                        ],
                                      )
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
  var url = Uri.parse("https://dms.symbexit.com/api/doctorlist");
  var data = await http.get(url);
  var jsonData = json.decode(data.body);
  final list = jsonData as List<dynamic>;
  print(list.toString());
  return list
      .map((e) => modelclassfordoctor.fromJson(e))
      .where((element) => element.specialistId
          .toString()
          .toLowerCase()
          .contains(a.toString().toLowerCase()))
      .toList();
}
