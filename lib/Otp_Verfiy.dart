import 'dart:convert';
import 'dart:math';

import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Modelclasses/SignUpModelclass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Otp_Verfiy.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:doctorappointment/Modelclasses/SignUpModelclass.dart';
import 'package:doctorappointment/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'HomePage.dart';

class MyVerify extends StatefulWidget {
  final String verification, email, username, password, patient, address, phone;
  const MyVerify(
      {super.key,
      required this.verification,
      required this.email,
      required this.username,
      required this.password,
      required this.patient,
      required this.address,
      required this.phone});
  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  var Userdata;

  final String oneSignalAppId = "330cb2d5-55cf-4d23-baa5-08a3a3fae337";

  Future<void> initPlatformState(String extid) async {
    OneSignal.shared.setExternalUserId(extid);
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }

  var code = " ";
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
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
              SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone without getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,
                /*onCompleted: (pin) => print(pin)*/
                onChanged: (value) {
                  code = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () async {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: widget.verification,
                                smsCode: code);

                        // Sign the user in (or link) with the credential
                        await auth.signInWithCredential(credential);

                        registration(
                            widget.phone,
                            widget.email,
                            widget.username,
                            widget.password,
                            widget.patient,
                            widget.address);
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: e.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("Verify Phone Number")),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Edit Phone Number ?",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  registration(
      String phone, email, username, password, patient, address) async {
    showDialog(
        context: context,
        builder: (context) {
          return const AbsorbPointer(
              child: Center(child: CircularProgressIndicator()));
        });

    int otp = Random().nextInt(999999);
    int noOfOtpDigit = 6;
    while (otp.toString().length != noOfOtpDigit) {
      otp = Random().nextInt(999999);
    }
    String otpString = otp.toString();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    Signup signup = Signup(
        address: widget.address,
        phone: widget.phone,
        email: widget.email,
        username: widget.username,
        password: widget.password,
        patient_id: otpString,
        patient: widget.patient,
        external_id: otpString);

    var url = Uri.parse("https://dms.symbexit.com/api/createpatientlist");

    print(jsonEncode(signup.toJson()));

    var response = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: jsonEncode(signup.toJson()));


    var body = json.decode(response.body);


    if (response.statusCode == 201) {
      setState(() {
        sharedPreferences.setString('user', jsonEncode(body['patientLogin']));
        var userJson = sharedPreferences.getString('user');
        var user = jsonDecode(userJson!);
        Userdata = user;

        initPlatformState(otp.toString());

        Future.delayed(Duration(seconds: 2), () {

          Get.to(() => MyHomePage(), transition: Transition.leftToRight);


          // code to be executed after 1 second delay
        });
      });
    } else if (response.statusCode != 201) {

      Fluttertoast.showToast(
          msg: "Something went wrong ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.of(context).pop();

    }
  }
}
