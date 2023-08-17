import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doctorappointment/Modelclasses/SignUpModelclass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import '../Controllers/availavldayscontroller.dart';
import '../HomePage.dart';


class CreatPatient extends StatefulWidget {
  final String mobile;
  const CreatPatient({super.key, required this.mobile});
  @override
  State<CreatPatient> createState() => _CreatPatientState();
}

class _CreatPatientState extends State<CreatPatient> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController Emailcontroller = TextEditingController();
  TextEditingController Addresscontroller = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repetpasswordcontroller = TextEditingController();
  bool _isHidden = true;
  bool _Repeatishidden=true;
  var Userdata;
  final sucesscontroller Signpubool = Get.find<sucesscontroller>();





  final String oneSignalAppId = "330cb2d5-55cf-4d23-baa5-08a3a3fae337";

  Future<void> initPlatformState(String extid) async
  {
    OneSignal.shared.setExternalUserId(extid);
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Please fill up this form to SignUp",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 30),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(

                    controller: namecontroller,
                    decoration: InputDecoration(
                        hintText: "Please Enter your Name",
                        labelText: "Name",
                        icon: const Icon(Icons.person),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: Emailcontroller,
                    decoration: InputDecoration(
                        hintText: "Please enter your Email(optional)",
                        labelText: "Email(optional)",
                        icon: const Icon(Icons.email),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: Addresscontroller,
                    decoration: InputDecoration(
                        hintText: "Please enter your Address",
                        labelText: "Address",
                        icon: const Icon(Icons.home),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    obscureText: _isHidden,
                    controller: password,
                    decoration: InputDecoration(
                        hintText: "Please enter your Password",
                        labelText: "Password",
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


                        icon: const Icon(Icons.password_rounded),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    obscureText: _Repeatishidden,
                    controller: repetpasswordcontroller,
                    decoration: InputDecoration(
                        hintText: "Please Repeat Your Password",
                        labelText: "Repeat Password  ",

                        suffix: InkWell(
                          onTap:_RtogglePasswordView,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              _Repeatishidden
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),

                        icon: const Icon(Icons.password),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: Signpubool.SignUpbool.value
                          ? null
                          : ()async {
                        if (namecontroller.text.toString().isEmpty ||
                            Addresscontroller.text.toString().isEmpty ||
                            password.text.toString().isEmpty ||
                            repetpasswordcontroller.text.toString().isEmpty) {
                          Fluttertoast.showToast(
                              msg:
                                  "You have to  fill out the whole form Except Email",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        else if (Signpubool.SignUpbool.value) {
                          Fluttertoast.showToast(
                            msg: "Creating Account is already in progress",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else
                        {
                         await  sendtosignup();
                        }
                        },
                      child: Obx(() {
                        return Signpubool.SignUpbool.value ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                  color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Text("Creating Your Account  ")
                          ],
                        )
                            : Text("Sign UP");
                      }),)
                ],
              ),
            ),
          ),
        ));



  }
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _RtogglePasswordView() {
    setState(() {
      _Repeatishidden = !_Repeatishidden;
    });
  }

  Future<void> sendtosignup() async {

    if (password.text.toString()!=repetpasswordcontroller.text.toString())
    {
      Fluttertoast.showToast
        (
          msg: "Your Passwords did not Matched ",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );

    }
     else{
      Signpubool.SignUpbool.value=true;
      int otp = Random().nextInt(999999999);
      int noOfOtpDigit = 9;
      while (otp.toString().length != noOfOtpDigit)
      {
        otp = Random().nextInt(999999999);
      }
      String otpString = otp.toString();

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      Signup signup=Signup(
         patient_id: otpString,
         patient: namecontroller.text.toString(),
         address: Addresscontroller.text.toString(),
         phone: widget.mobile,
         email: Emailcontroller.text.toString().isEmpty?" ":Emailcontroller.text.toString(),
         username: namecontroller.text.toString(),
         password: password.text.toString(),
         external_id: otpString,

       );
      var url = Uri.parse("https://pharmacy.symbexbd.com/api/createpatientlist");


      try {
        var response = await Future.delayed(Duration(seconds: 2), () {
          return http.post(
            url,
            headers: {"Content-type": "application/json"},
            body: jsonEncode(signup.toJson()),
          );
        });

        var body = json.decode(response.body);

        if (response.statusCode == 201) {
          setState(() {
            sharedPreferences.setString('user', jsonEncode(body['patientLogin']));
            var userJson = sharedPreferences.getString('user');
            var user = jsonDecode(userJson!);
            Userdata = user;

            initPlatformState(otp.toString());


            Future.delayed(const Duration(seconds: 2), () {
              Get.to(() => const MyHomePage(), transition: Transition.leftToRight);
            });
          });
          Fluttertoast.showToast(
            msg: "Your account created Successfully  ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );


          Signpubool.SignUpbool.value=false;

        } else if (response.statusCode != 201) {

          Fluttertoast.showToast(
            msg: "Something went wrong ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Signpubool.SignUpbool.value=false;
        }
      } catch (error) {
        if (error is TimeoutException) {
          Fluttertoast.showToast(
            msg: "Server not responding, please try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Signpubool.SignUpbool.value=false;

        } else {
          Fluttertoast.showToast(
            msg: error.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        Signpubool.SignUpbool.value=false;

      } finally
      {
        Signpubool.SignUpbool.value=false;
      }
    }




  }
}


