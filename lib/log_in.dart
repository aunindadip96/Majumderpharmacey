import 'dart:convert';
import 'dart:math';
import 'package:doctorappointment/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'HomePage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Otp_Verfiy.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future<void> initPlatformState(String extid) async {
    OneSignal.shared.setExternalUserId(extid);
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
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
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        SignIn(mobilecontroller.text.toString(),
                            passwordController.text.toString());
                        // I am connected to a mobile or Wifi network.
                      } else if (connectivityResult ==
                          ConnectivityResult.none) {
                        // No Internet
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
        ));
  }

  SignIn(String mobile, String password) async {
    if (mobilecontroller.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return const AbsorbPointer(
              absorbing: true,
              child: Center(child: CircularProgressIndicator()),
            );
          });

      Map data = {'username': mobile, 'password': password};

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      var url = Uri.parse("https://dms.symbexit.com/api/patientlogin");
      var response = await http.post(url, body: data);
      if (response.statusCode == 201) {
        int otp2 = Random().nextInt(999999);
        int noOfOtpDigit = 6;
        while (otp2.toString().length != noOfOtpDigit) {
          otp2 = Random().nextInt(999999);
        }


        /*print(response.body);
        print(response.statusCode);*/
        var body = json.decode(response.body);
        setState(() {
          sharedPreferences.setString('user', jsonEncode(body['patient']));
          var userJson = sharedPreferences.getString('user');
          var user = jsonDecode(userJson!);
          print(user);


          initPlatformState(jsonEncode(body['patient']['external_id']
              .toString()
              .replaceAll(RegExp(r'[^\d]+'),"").replaceAll('"', '')));


          Userdata = user;

          Get.to(() => MyHomePage(), transition: Transition.leftToRight);

        });
      } else if (response.statusCode != 201) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(
            msg: response.body,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
    if (mobilecontroller.text.isEmpty || passwordController.text.isEmpty) {}
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
}
