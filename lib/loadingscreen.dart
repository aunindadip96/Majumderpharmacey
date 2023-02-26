/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class loadingscreen extends StatelessWidget {  @override
  Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Demo')),
      body: AbsorbPointer(
        absorbing: EasyLoading.isShow,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  EasyLoading.show(status: 'Loading...');
                  // perform some async task
                  Future.delayed(Duration(seconds: 2), () {
                    EasyLoading.dismiss();
                  });
                },
                child: Text('Show Loading'),
              ),
              SizedBox(height: 20),
              Text('Tap the button to show loading'),
            ],
          ),
        ),
      ),
      // register EasyLoading configuration
      builder: EasyLoading.init(),
    ),
  );
  }
}
*/
