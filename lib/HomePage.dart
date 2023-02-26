import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'Modelclasses/viewSpecialistModel.dart';
import 'catagorywisedoctorlist.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;


    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.350,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage("lib/assets/Images/pic2.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[

                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        "Hello! " ,
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Center(
                        child: Text(
                          "Let's Find Your Doctor",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Categories",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              SizedBox(height: 20),
              Futurebuilderforcatagory()
            ],
          ),
        ),
      ),
    );
  }
}
class Futurebuilderforcatagory extends StatelessWidget {
   Futurebuilderforcatagory({Key? key,}) : super(key: key);


  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
        future: fetchCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){

            return const Center(child: CircularProgressIndicator());

          }
          if (snapshot.data == null) {
            return const Center(child: Text("dad"));
            
          }

          if (snapshot.hasData) {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: GestureDetector(
                    onTap: (){
                      Get.to(catagoryisedoctorlist(catagorwiseID: snapshot.data[index].id.toString()), transition: Transition.rightToLeftWithFade);
                      print(snapshot.data[index].id.toString());
                      },
                    child: Card(
                      elevation: 2,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Image.asset(
                                "lib/assets/Images/catagory.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                snapshot.data[index].specialist,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}



Future<List<catagoryModel>> fetchCategories() async {
  return Future.delayed(Duration(seconds: 2), () async {
    var url = Uri.parse("https://dms.symbexit.com/api/viewSpecialist");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);
    final list = jsonData as List<dynamic>;

    return list.map((e) => catagoryModel.fromJson(e)).toList();
  });
}

