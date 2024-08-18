import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../Controllers/availavldayscontroller.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final sucesscontroller mobilecheck = Get.find<sucesscontroller>();

  // Declare the EmailAuth object
  late EmailAuth emailAuth;

  @override
  void initState() {
    super.initState();

    emailAuth = EmailAuth(
      sessionName: "Dev Session",
    );


    // Initialize the EmailAuth instance
    emailAuth.config(remoteServerConfiguration);

    // Optionally configure with remote server settings if needed
    // emailAuth.config(remoteServerConfiguration);

    countryController.text = "+880";
  }

  void sendOtp() async {
    if (emailController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email to get started",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    bool result = await emailAuth.sendOtp(
      recipientMail: emailController.text,
      otpLength: 5,
    );

    if (result) {
      setState(() {
        mobilecheck.mobilenumcheck.value = true;
      });
      Fluttertoast.showToast(
        msg: "OTP sent successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Failed to send OTP. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                        ),
                        enabled: !mobilecheck.mobilenumcheck.value,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: mobilecheck.mobilenumcheck.value ? null : sendOtp,
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
                      Text("Validating your Number"),
                    ],
                  )
                      : const Text("Send OTP");
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }


  final Map<String, String> remoteServerConfiguration = {
    "server": "smtp.gmail.com",
    "port": "465", // You can also use 465 for SSL
    "username": "Majumder",
    "password": "Majumder1234",
    "senderEmail": "majuderpharmacyapp@gmail.com",
    "secure": "true", // This ensures SSL/TLS is used
  };


}
