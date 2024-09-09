import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Apicalls/Mobilenumbercheck.dart';
import '../Controllers/availavldayscontroller.dart';
import '../HomePage.dart';
import 'dart:async';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../Modelclasses/SignUpModelclass.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../log_in.dart';


class MyPhone extends StatefulWidget {
  final String name;
  final String email;
  final String googleId;

  const MyPhone({
    Key? key,
    required this.name,
    required this.email,
    required this.googleId,
  }) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  final sucesscontroller mobilecheck = Get.find<sucesscontroller>();
  final String oneSignalAppId = "6c073550-8001-433c-9fb3-b58d77189d6e";
  var Userdata;





  Future<void> initPlatformState(String extid) async {

    OneSignal.shared.setExternalUserId(
        extid);
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();

    // Access the passed values using widget.name, widget.email, widget.googleId
    print("Name: ${widget.name}, Email: ${widget.email}, Google ID: ${widget.googleId}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/Images/otp.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 25),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "We need to register your phone before getting started!",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phonecontroller,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                        enabled: !mobilecheck.mobilenumcheck.value,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: mobilecheck.mobilenumcheck.value
                      ? null
                      : () async {
                    if (phonecontroller.text.toString().isEmpty) {
                      Fluttertoast.showToast(
                        msg: "Please enter your phone number to get started",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else if (mobilecheck.mobilenumcheck.value) {
                      Fluttertoast.showToast(
                        msg: "Number checking is already in progress",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    } else {
                      mobilecheck.mobilenumcheck.value = true;

                      if (mobilecheck.mobilenumcheck.value) {
                        await sendGoogleUserToBackend(widget.name,widget.email,widget.googleId,phonecontroller.text);
                      }
                    }
                  },
                  child: Obx(() {
                    return mobilecheck.mobilenumcheck.value
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                              color: Colors.white),
                        ),
                        SizedBox(width: 8),
                        Text("Validating your Number")
                      ],
                    )
                        : const Text("Send OTP");
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future<void> sendGoogleUserToBackend(String name, String email, String googleId,String mobile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Signup signup = Signup(
      patient_id: googleId,
      patient: name,
      address: 'Kolkata,India', // You can prompt the user for this later or set a default value
      phone:mobile, // You can prompt the user for this later or set a default value
      email: email,
      username:name,
      password:mobile, // Since it's a Google sign-in, you might not need this
      external_id: googleId,
    );

    print(signup.toJson());

    var url = Uri.parse("https://pharmacy.symbexbd.com/api/createpatientlist");

    try {
      var response = await http.post(
        url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(signup.toJson()),
      );

      if (response.statusCode == 201|| response.statusCode ==200) {
        var body = json.decode(response.body);
        sharedPreferences.setString('user', jsonEncode(body['patientLogin']));
        Userdata = jsonDecode(sharedPreferences.getString('user')!);

        initPlatformState(googleId);
        mobilecheck.mobilenumcheck.value = false;


        Get.to(() => const MyHomePage(), transition: Transition.leftToRight);

        Fluttertoast.showToast(
          msg: "Signed in and data sent successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {

        final GoogleSignIn _googleSignIn = GoogleSignIn();
        await _googleSignIn.signOut();
        print('User signed out from Google');

        // Remove external user ID from OneSignal
        OneSignal.shared.removeExternalUserId();

        // Clear user data from SharedPreferences
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.remove("user");
        mobilecheck.mobilenumcheck.value = false;

        // Navigate to the login screen
        Get.offAll(const login());

        print(response.body);

        Fluttertoast.showToast(
          msg:"This account is already in use",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );



      }
    } catch (error) {


      mobilecheck.mobilenumcheck.value = false;

      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


}