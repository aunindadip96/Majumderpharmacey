
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'Apicalls/fetchcatagories.dart';
import 'catagorywisedoctorlist.dart';
import 'package:shimmer/shimmer.dart';

/*
class Futurebuilderforcatagory extends StatelessWidget {
  Futurebuilderforcatagory({
    Key? key,
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder(
        future: fetchCategories(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(.25),
              highlightColor: Colors.white.withOpacity(.6),
              period: const Duration(seconds: 1),
              child: SingleChildScrollView(
                child: Container(
                  height: screenHeight* .55,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    border: Border.all(
                      color: Colors.deepPurple,
                      width: 5.0,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemCount: 15,
                      itemBuilder: (BuildContext context, int index) {
                        return const GridTile(
                            child: Card(
                          elevation: 2,
                        ));
                      }),
                ),
              ),
            );
          }
          if (snapshot.data == null)
          {
            return Container(
              height: screenHeight * .55,

                child: Column(
                  children:[
                    Container(

                      child: Image.asset("lib/assets/Images/error.jpg",
                      fit: BoxFit.fill
                        ,),
                    ),
                    Expanded(
                      child: Text("Something Went Wrong ",style: TextStyle(
                        fontSize: 20
                      ),),
                    ),
                    Text("Pull to Refresh",style: TextStyle(
                        fontSize: 20
                    ),),


                  ]




                ),


            );

          }

          if (snapshot.hasData) {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                          catagoryisedoctorlist(
                            catagorwiseID: snapshot.data[index].id.toString(),
                            catagoryName:
                                snapshot.data[index].specialist.toString(),
                          ),
                          transition: Transition.rightToLeftWithFade);
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
*/
class Futurebuilderforcatagory extends StatelessWidget {
  Futurebuilderforcatagory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategories(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return Container(
            height: MediaQuery.of(context).size.height * .55,
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    "lib/assets/Images/error.jpg",
                    fit: BoxFit.fill,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Something Went Wrong",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  "Pull to Refresh",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          );
        }
        if (snapshot.hasData) {
          return Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GridTile(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        catagoryisedoctorlist(
                          catagorwiseID: snapshot.data[index].id.toString(),
                          catagoryName: snapshot.data[index].specialist.toString(),
                        ),
                        transition: Transition.rightToLeftWithFade,
                      );
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
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
