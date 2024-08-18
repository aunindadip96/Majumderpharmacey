import 'package:doctorappointment/push_notifiaction.dart';
import 'package:doctorappointment/splasscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'Controllers/availavldayscontroller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(sucesscontroller());
  EasyLoading.init(); // Add this line


  OneSignal.shared.setAppId("330cb2d5-55cf-4d23-baa5-08a3a3fae33708a3a3fae337");

  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    final notification = result.notification;
    final title = notification.title;
    final body = notification.body;
    Get.to(() => NotificationModal(title: title, body: body));
  });

/*  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    final notification = result.notification;
    final title = notification.title;
    final body = notification.body;

    // Show dialog with notification title and body
    Get.dialog(
      AlertDialog(
        title: Text(title ?? "No Title"),
        content: Text(body ?? "No Body"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: const Text("Close"),
          ),
        ],
      ),
      barrierDismissible: true, // Allows user to close dialog by tapping outside
    );
  });*/


  runApp(const MyApp());

  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  //..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: splashscreeen(),
        builder: EasyLoading.init()
    );
  }
}
