import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'Apicalls/fetchcatagories.dart';
import 'catagorywisedoctorlist.dart';


class Futurebuilderforcatagory extends StatelessWidget {
  Futurebuilderforcatagory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategories(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .55,
            child: Column(
              children: [
                Image.asset(
                  "lib/assets/Images/error.jpg",
                  fit: BoxFit.fill,
                ),
                const Expanded(


                  child:
                  Text(
                    "Something Went Wrong",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const Text(
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
          return GridView.builder(
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
