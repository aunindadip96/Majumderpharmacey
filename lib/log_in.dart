import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:doctorappointment/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'Controllers/availavldayscontroller.dart';
import 'HomePage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  var mobilecontroller = TextEditingController();
  var passwordController = TextEditingController();
  final String oneSignalAppId = "330cb2d5-55cf-4d23-baa5-08a3a3fae337";
  bool _isHidden = true;
  var Userdata;
  final sucesscontroller Sucesscontroller = Get.find<sucesscontroller>();

  late BuildContext dialogContext; // Add this line

  Future<void> initPlatformState(String extid) async {
    print(extid);

    OneSignal.shared.setExternalUserId(
        extid.replaceAll(RegExp(r'[^\d]+'), "").replaceAll('"', ''));
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }

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
              title: const Text("Majumdar Pharmacy"),
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
                              keyboardType: TextInputType.number,
                              controller: mobilecontroller,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                border: InputBorder.none,
                                hintText: "Phone Number",
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
                          if (mobilecontroller.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Please enter both mobile and password',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          } else {
                            Sucesscontroller.loginbool.value = true;

                            print(Sucesscontroller.loginbool.value.toString());

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

                            await signIn(
                              mobilecontroller.text.toString(),
                              passwordController.text.toString(),
                            );
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
                          const Text('Not a Member ?'),
                          InkWell(
                            onTap: () {
                              Get.to(const MyRegister(),
                                  transition: Transition.leftToRight);
                            },
                            child: const Text(
                              " Sign Up Now ",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Future<void> signIn(String mobile, String password) async {
    Map data = {'username': mobile, 'password': password};

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse("https://dms.symbexit.com/api/patientlogin");

    bool hasNavigatedToHomePage = false; // Flag to track navigation

    try {
      var response = await http.post(url, body: data).timeout(Duration(seconds: 30));

      if (response.statusCode == 201) {
        var body = json.decode(response.body);

        sharedPreferences.setString('user', jsonEncode(body['patient']));
        var userJson = sharedPreferences.getString('user');
        var user = jsonDecode(userJson!);
        print("Done");

        String Eid = (jsonEncode(body['patient']['external_id'].toString()));
        initPlatformState(Eid);
        print("Done" + "2");
        Userdata = user;
        Get.to(() => const MyHomePage(), transition: Transition.leftToRight);
        print("What the ");

        hasNavigatedToHomePage = true; // Set the flag to true after navigation
      } else if (response.statusCode != 201) {
        Fluttertoast.showToast(
          msg: response.body,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } on TimeoutException catch (e) {
      Fluttertoast.showToast(
        msg: 'Request timed out. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } on SocketException catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to connect to server. Please check your internet connection and try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      // Handle the cleanup or navigation logic here
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
