import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../Apicalls/Mobilenumbercheck.dart';
import '../Controllers/availavldayscontroller.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  final sucesscontroller mobilecheck = Get.find<sucesscontroller>();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
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
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      controller: phonecontroller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                      enabled: mobilecheck.mobilenumcheck.value == false,
                    ))
                  ],
                ),
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
                    onPressed: mobilecheck.mobilenumcheck.value
                        ? null
                        : () async {
                            if (phonecontroller.text.toString().isEmpty) {
                              Fluttertoast.showToast(
                                msg:
                                    "Please enter your phone number to get started",
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
                                await sendOtp(phonecontroller.text.toString());

                                // Show loading indicator or any UI indication of checking


                              }
                            }
                          },
                    child: Obx(() {
                      return mobilecheck.mobilenumcheck.value ?
                      Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                      color: Colors.white),
                                ),
                                SizedBox(width: 8),
                                Text("Validating you Number")
                              ],
                            )
                          : Text("Send OTP");
                    }),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
