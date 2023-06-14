import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Controllers/availavldayscontroller.dart';
import 'FillupformtocreatPatient.dart';

class Otpverify extends StatefulWidget {
  final String verification, mobile;
  const Otpverify(
      {super.key, required this.verification, required this.mobile});
  @override
  State<Otpverify> createState() => _OtpverifyState();
}

class _OtpverifyState extends State<Otpverify> {
  var code = " ";
  final FirebaseAuth auth = FirebaseAuth.instance;
  final sucesscontroller Otpcheckbool = Get.find<sucesscontroller>();

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
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your Number for getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,

                showCursor: true,

                onChanged: (value) {
                  code = value;
                },
              ),
              const SizedBox(
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
                    Otpcheckbool.otpinput.value = true;

                    try {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                              verificationId: widget.verification,
                              smsCode: code);

                      // Sign the user in (or link) with the credential
                      await auth.signInWithCredential(credential);

                      await Future.delayed(Duration(seconds: 2));

                      Get.to(
                          () => CreatPatient(mobile: widget.mobile,) ,
                          transition: Transition.leftToRight
                      );
                      Otpcheckbool.otpinput.value = false;
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

                    Otpcheckbool.otpinput.value = false;
                  },
                  child: Obx(() {
                    return Otpcheckbool.otpinput.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                    color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Text("Validating your OTP")
                            ],
                          )
                        : const Text("Verify Your OTP");
                  }),
                ),
              ),
              Row(
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const Text(
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
}
