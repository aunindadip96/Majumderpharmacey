import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Controllers/availavldayscontroller.dart';
import '../SignUp/OtpInput.dart';

Future<void> sendOtp(String mobile) async {
  final sucesscontroller vailditaionoftext = Get.find<sucesscontroller>();



  try {
    var url = Uri.parse("https://pharmacy.symbexbd.com/api/checkPhone/$mobile");
    var data = await http.get(url);
    var jsonData = json.decode(data.body);

    if (jsonData.toString() == "401") {
      Fluttertoast.showToast(
        msg: "This number is already registered",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      vailditaionoftext.mobilenumcheck.value=false;
    }




    if (jsonData.toString() == "201") {
      await FirebaseAuth.instance.verifyPhoneNumber(

        phoneNumber: "+91 $mobile",


    /*  phoneNumber: "+8801675758519",*/
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {


          Fluttertoast.showToast(
            msg: "Your number is not correct",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,

          );


          vailditaionoftext.mobilenumcheck.value=false;



        },
        codeSent: (String verificationId, int? resendToken) {
          Get.to(Otpverify(verification: verificationId.toString(), mobile: mobile.toString(),),
            transition: Transition.leftToRight,);
          vailditaionoftext.mobilenumcheck.value=false;

        },
        codeAutoRetrievalTimeout: (String verificationId) {


        },
      );



    }
  } catch (e) {
    // Exception handling
    Fluttertoast.showToast
      (
      msg: 'An error occurred. Please try again later.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    vailditaionoftext.mobilenumcheck.value=false;

  }
}
