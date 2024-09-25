import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'Admin_Pannel/Admin_logIn/LoginScreen.dart';
import 'Controllers/availavldayscontroller.dart';
import 'HomePage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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

  late BuildContext dialogContext;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> initPlatformState(String extid) async {
    OneSignal.shared.setExternalUserId(extid);
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
        appBar: AppBar(
          title: const Center(child: Text("Majumdar Pharmacy")),
        ),
        body: Container(

          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.greenAccent, // Start color
                Colors.deepPurpleAccent, // End color
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
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
                      height: 20,
                    ),



                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey, Colors.blue], // Adjust colors as needed
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: continueWithGoogle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "lib/assets/Images/Doc.png", // Add the path to your Google icon
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 10), // Spacing between icon and text
                                const Text(
                                  "Continue with Google",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey, Colors.blue], // Adjust colors as needed
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextButton(
                          onPressed: signInWithGoogle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "lib/assets/Images/Doc.png", // Add the path to your Google icon
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 10), // Spacing between icon and text
                                const Text(
                                  "Sign In with Google",
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),




                    TextButton(onPressed: (){
                      Get.to(() => const AdminLogIn(),
                          transition: Transition.leftToRight);
                    }, child: Text("Use as a  Admin",
                    style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),))




                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    BuildContext? dialogContext;

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Center(child: CircularProgressIndicator());
      },
    );

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        Navigator.pop(dialogContext!); // Dismiss loading dialog
        return;
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

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw Exception('Failed to sign in with Google');
      }

      // User information
      String name = userCredential.user!.displayName ?? '';
      String email = userCredential.user!.email ?? '';
      String googleId = userCredential.user!.uid;

      // Check if the email already exists
      Map data = {'email': email};
      print(email);

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var url = Uri.parse("https://pharmacy.symbexbd.com/api/patientlogin");

      var response =
      await http.post(url, body: data).timeout(Duration(seconds: 30));
      print(response.body.toString());

      if (response.statusCode == 201) {
        await _googleSignIn.signOut();
        Fluttertoast.showToast(
          msg: 'This email already exists',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        Get.to(
              () => MyPhone(name: name, email: email, googleId: googleId),
          transition: Transition.leftToRight,
        );
      }
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
    } finally {
      // Ensure the loading dialog is closed in case of failure
      if (dialogContext != null) {
        Navigator.pop(dialogContext!);
      }
    }
  }

  Future<void> signIn(String mobile) async {
    Map data = {'email': mobile};

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
        msg:
        'Failed to connect to server. Please check your internet connection and try again.',
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


}
