import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Apicalls/fetchcatagories.dart';
import 'Ctagories.dart';
import 'NavbBar/UpperTopDrwaer.dart';
import 'NavbBar/bottompartnavbar.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _controller = ScrollController();

  bool _isRefreshing = false;

  Future<void> _onRefresh() async {
    setState(() {
      _isRefreshing = true;
    });
    await fetchCategories();
    setState(() {
      _isRefreshing = false;
    });
  }

  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            "Majumder Pharmacy",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),

      drawer: Drawer(
          child: ListView(

              children: [
                const myprofildrwaer(),
                myDrwaerlist(),
              ],
            ),

        ),

      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: WillPopScope(
          onWillPop: () async {
            // To disable the back button, simply return false
            return false;
          },
          child: DraggableScrollbar.rrect(heightScrollThumb: 100,
            alwaysVisibleScrollThumb: false,
            backgroundColor: Colors.blueAccent,
            controller: _controller,


            child: ListView(
              physics: BouncingScrollPhysics(),
              controller: _controller,


                children: [
                  Container(
                    height: screenHeight * 0.350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("lib/assets/Images/pic2.jpg"),
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Hello! ",
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
                  const Center(
                    child: Text(
                      "Categories",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Futurebuilderforcatagory(),


                  if (_isRefreshing) const SizedBox(height: 20),

                ],



        ),
          ),


      ),

      )
    );
  }
}
