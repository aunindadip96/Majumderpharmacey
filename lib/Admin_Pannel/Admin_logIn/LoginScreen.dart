
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Controllers/availavldayscontroller.dart';
import '../../HomePage.dart';
import '../AdminHompage/AdminHompage.dart';

class AdminLogIn extends StatefulWidget {
  const AdminLogIn({Key? key}) : super(key: key);

  @override
  _AdminLogIn createState() => _AdminLogIn();
}

class _AdminLogIn extends State<AdminLogIn> {
  var mobilecontroller = TextEditingController();
  var passwordController = TextEditingController();
  final String oneSignalAppId = "6c073550-8001-433c-9fb3-b58d77189d6e";
  bool _isHidden = true;
  final sucesscontroller Sucesscontroller = Get.find<sucesscontroller>();

  late BuildContext dialogContext; //

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Add this line



  Future<bool?> showWarnig(BuildContext context) async => showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Do You Want To Exit "),
      actions: [
        ElevatedButton(
          child: const Text("No"),
          onPressed: () => Navigator.pop(context, false),
        ),
        ElevatedButton(
          child: const Text("Yes"),
          onPressed: () => SystemNavigator.pop(),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (Sucesscontroller.loginbool.value) {
            return false;
          }

          final shouldPop = await showWarnig(context);
          if (shouldPop ?? false) {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // Pop the current route
            } else {
              SystemNavigator.pop(); // Exit the app
            }
          }
          return false;
        },
        child: Scaffold(
            backgroundColor: Colors.grey[300],
            appBar: AppBar(
              title: Center(child: const Text("Majumdar Pharmacy")),
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.whatshot,
                        size: 70,
                        color: Colors.blueAccent,
                      ),

                      const Text(
                        " Welcome Back !!!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Text("You Have been Missed",
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(
                        height: 30,
                      ),
                      //PasswordTextfield

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12.00)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: mobilecontroller,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                border: InputBorder.none,
                                hintText: "Email Address",
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12.00)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: TextField(
                              obscureText: _isHidden,
                              controller: passwordController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.password_rounded),
                                border: InputBorder.none,
                                hintText: "Password",
                                suffix: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      _isHidden
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      InkWell(
                        onTap: () async {
                          if (mobilecontroller.text.isEmpty ) {
                            Fluttertoast.showToast(
                              msg: 'Please enter both mobile and password',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          } else {
                            Sucesscontroller.loginbool.value = true;


                            if (Sucesscontroller.loginbool.value) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  dialogContext =
                                      context; // Save the dialog context
                                  return AbsorbPointer(
                                    absorbing: true,
                                    child: GestureDetector(
                                      onTap: () {
                                        // Disable any tap events while the progress indicator is shown
                                      },
                                      child: Container(
                                        color: Colors
                                            .transparent, // Use a transparent color to cover the screen
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }


                            await Future.delayed(Duration(seconds: 2));


                            AdminsignIn();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            padding: const EdgeInsets.all(20.00),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: const Center(
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),





                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('For Account Contact With Proper Authority '),
                       

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }




  Future<void> AdminsignIn() async {
    Map data = {
      'username': mobilecontroller.text.toString(),
      'password': passwordController.text.toString()
    };

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse("https://pharmacy.symbexbd.com/api/userlogin");
    print(url.toString());
    bool hasNavigatedToHomePage = false; // Flag to track navigation

    try {
      var response = await http.post(url, body: data).timeout(Duration(seconds: 30));
      print(response.body.toString());

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Log in Is Successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        var body = json.decode(response.body);

        // Store the response in SharedPreferences under 'adminuserinfo'
        await sharedPreferences.setString('adminuserinfo', jsonEncode(body));

        // Retrieve and print the stored data
        var adminUserInfo = sharedPreferences.getString('adminuserinfo');
        if (adminUserInfo != null) {
          print('Stored adminuserinfo: $adminUserInfo');

          // Optionally, decode and print the JSON data
          var user = jsonDecode(adminUserInfo);
          print('Decoded adminuserinfo: $user');
        } else {
          print('No adminuserinfo found in SharedPreferences.');
        }

        Get.to(() => const AdminMyHomePage(), transition: Transition.leftToRight);
        Sucesscontroller.loginbool.value = false;

        hasNavigatedToHomePage = true; // Set the flag to true after navigation
      } else if (response.statusCode != 201) {
        Fluttertoast.showToast(
          msg: "Please Sign in Using google ID",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Sucesscontroller.loginbool.value = false;
      }
    } on TimeoutException catch (e) {
      Fluttertoast.showToast(
        msg: 'Request timed out. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Sucesscontroller.loginbool.value = false;
    } on SocketException catch (e) {
      print(e.toString());

      Fluttertoast.showToast(
        msg: 'Failed to connect to server. Please check your internet connection and try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Sucesscontroller.loginbool.value = false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      if (!hasNavigatedToHomePage && dialogContext != null) {
        Navigator.pop(dialogContext);
      }
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }






}
