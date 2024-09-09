import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'Admin_Pannel/Admin_logIn/LoginScreen.dart';
import 'Controllers/availavldayscontroller.dart';
import 'HomePage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'Modelclasses/SignUpModelclass.dart';
import 'SignUp/Phone_Number_Entry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class login extends StatefulWidget {
  const login({Key? key}) : super(key: key);

  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  var mobilecontroller = TextEditingController();
  var passwordController = TextEditingController();
  final String oneSignalAppId = "6c073550-8001-433c-9fb3-b58d77189d6e";
  bool _isHidden = true;
  var Userdata;
  final sucesscontroller Sucesscontroller = Get.find<sucesscontroller>();

  late BuildContext dialogContext; //

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Add this line

  Future<void> initPlatformState(String extid) async {
    OneSignal.shared.setExternalUserId(
        extid);
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
              title: Center(child: const Text("Majumdar Pharmacy")),
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
                              keyboardType: TextInputType.emailAddress,
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
                          if (mobilecontroller.text.isEmpty) {
                            Fluttertoast.showToast(
                              msg: 'Please enter both mobile and password',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            );
                          } else {
                            Sucesscontroller.loginbool.value = true;

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

                            await Future.delayed(Duration(seconds: 2));

                            signIn(
                              mobilecontroller.text.toString(),
                            );
                            print(mobilecontroller.text.toString());
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


                      ElevatedButton(
                        onPressed: (){

                          Get.to(() => const AdminLogIn(), transition: Transition.leftToRight);



                        },
                        child: const Text("Use As A Employee"),
                      ),

                      const SizedBox(
                        height: 2,
                      ),
                      ElevatedButton(
                        onPressed: continueWithGoogle,
                        child: const Text("Continue with Google"),
                      ),

                      ElevatedButton(
                          onPressed: () async {

                            signInWithGoogle();
                          },
                          child: const Text("Sign in with google ")),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Not a Member ?'),
                          InkWell(
                            onTap: () {
                              /* Get.to(const MyPhone(),
                                  transition: Transition.leftToRight);*/
                            },
                            child: const Text(
                              " Sign Up Now ",
                              style: TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        // Handle the case where authentication tokens are null
        throw Exception('Google authentication tokens are null');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw Exception('Failed to sign in with Google');
      }

      // User information
      String name = userCredential.user!.displayName ?? '';
      String email = userCredential.user!.email ?? '';
      String googleId = userCredential.user!.uid;

      // Now send this information to your backend


      Get.to(
        () => MyPhone(name: name, email: email, googleId: googleId),
        transition: Transition.leftToRight,
      );
    } catch (e) {
      print('Error signing in with Google: $e');
      Fluttertoast.showToast(
        msg: 'Error signing in with Google: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  Future<void> signIn(String mobile) async {
    Map data = {'email': mobile};
    print(mobile);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = Uri.parse("https://pharmacy.symbexbd.com/api/patientlogin");
    print(url.toString());

    bool hasNavigatedToHomePage = false;

    // Show loading dialog
    BuildContext? dialogContext;
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      var response =
      await http.post(url, body: data).timeout(Duration(seconds: 30));
      print(response.body.toString());

      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Log in Is Successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        var body = json.decode(response.body);

        sharedPreferences.setString('user', jsonEncode(body['patient']));
        var userJson = sharedPreferences.getString('user');
        var user = jsonDecode(userJson!);

        String Eid = (jsonEncode(body['patient']['external_id'].toString()));
        initPlatformState(Eid);
        Userdata = user;

        hasNavigatedToHomePage = true;

        // Dismiss the loading dialog before navigating
        if (dialogContext != null) {
          Navigator.pop(dialogContext!);
        }

        // Navigate to the home page
        Get.to(() => const MyHomePage(), transition: Transition.leftToRight);

        Sucesscontroller.loginbool.value = false;
      } else {
        Fluttertoast.showToast(
          msg: "Please Sign in Using Google ID",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Sucesscontroller.loginbool.value = false;
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
      Sucesscontroller.loginbool.value = false;
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
      Sucesscontroller.loginbool.value = false;
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
      // Ensure the loading dialog is closed in case of failure
      if (!hasNavigatedToHomePage && dialogContext != null) {
        Navigator.pop(dialogContext!);
      }
    }
  }
  Future<void> continueWithGoogle() async {
    try {
      // Google sign-in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        Fluttertoast.showToast(
          msg: 'Google sign-in was cancelled',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        return; // User cancelled sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Google authentication tokens are null');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw Exception('Failed to sign in with Google');
      }

      // Google user details
      String name = userCredential.user!.displayName ?? '';
      String email = userCredential.user!.email ?? '';
      String googleId = userCredential.user!.uid;

      await signIn(email);

      // Send Google user data to your backend

      // Navigate to the desired screen
    } catch (e) {
      print('Error during Google sign-in: $e');
      Fluttertoast.showToast(
        msg: 'Error signing in with Google: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }


}
