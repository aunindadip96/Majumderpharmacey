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

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController repeatpasswordcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController patientName = TextEditingController();
  TextEditingController patientadress = TextEditingController();

  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Majumdar Pharmacy"),
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 35, top: 30),
                    child: const Text(
                      'Create\nAccount',
                      style: TextStyle(color: Colors.black, fontSize: 33),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: phonecontroller,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    hintText: "Mobile",
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: emailcontroller,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Email",
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: namecontroller,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Username ",
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: patientName,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Patient Name ",
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextField(
                                controller: patientadress,
                                style: const TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Address ",
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: passwordcontroller,
                                style: const TextStyle(color: Colors.black),
                                obscureText: true,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Password",
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.toString() != passwordcontroller) {}
                                },
                                style: const TextStyle(color: Colors.black),
                                obscureText: true,
                                controller: repeatpasswordcontroller,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: "Confirm Password",
                                    hintStyle:
                                        const TextStyle(color: Colors.black),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.blueAccent,
                                    child: IconButton(
                                        color: Colors.black,
                                        onPressed: () {
                                          if (phonecontroller.text.toString().isEmpty ||
                                              emailcontroller.text
                                                  .toString()
                                                  .isEmpty ||
                                              namecontroller.text
                                                  .toString()
                                                  .isEmpty ||
                                              patientName.text
                                                  .toString()
                                                  .isEmpty ||
                                              patientadress.text
                                                  .toString()
                                                  .isEmpty ||
                                              passwordcontroller.text
                                                  .toString()
                                                  .isEmpty ||
                                              repeatpasswordcontroller.text
                                                  .toString()
                                                  .isEmpty) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You have to  fill out the whole form",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          } else {
                                            /*SignUp(
                                                phonecontroller.text.toString(),
                                                emailcontroller.text.toString(),
                                                namecontroller.text.toString(),
                                                passwordcontroller.text
                                                    .toString(),
                                                patientName.text.toString(),
                                                patientadress.text.toString());*/

                                            otpstart(
                                                phonecontroller.text.toString(),
                                                emailcontroller.text.toString(),
                                                namecontroller.text.toString(),
                                                passwordcontroller.text
                                                    .toString(),
                                                patientName.text.toString(),
                                                patientadress.text.toString());
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    style: const ButtonStyle(),
                                    child: const Text(
                                      'Sign In',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          color: Colors.black,
                                          fontSize: 18),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  otpstart(String mobile, email, username, password, patient, address) async {
    if (passwordcontroller.text.toString() !=
        repeatpasswordcontroller.text.toString()) {
      Fluttertoast.showToast(
          msg: "Sorry your password didnot match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return const AbsorbPointer(
              absorbing: true,
              child: Center(child: CircularProgressIndicator()),
            );
          });

      var url = Uri.parse("https://dms.symbexit.com/api/checkPhone/$mobile");
      var data = await http.get(url);
      var jsonData = json.decode(data.body);

      if (jsonData.toString() == "401") {
        Fluttertoast.showToast(
            msg: "This number is already Registered".toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

      }

      if (jsonData.toString() == "201") {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+88 $mobile",
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            Fluttertoast.showToast(
                msg: " Your number is Not Correct".toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context).pop();
          },
          codeSent: (String verificationId, int? resendToken) {
            Get.to(
                MyVerify(
                  verification: verificationId.toString(),
                  email: email,
                  username: username,
                  password: password,
                  patient: patient,
                  address: address,
                  phone: phonecontroller.text.toString(),
                ),
                transition: Transition.leftToRight);
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      }
    }
  }
}
