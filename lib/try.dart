import 'package:flutter/material.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool _isProgressIndicatorShown = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isProgressIndicatorShown) {
          // Disable back button when progress indicator is shown
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Screen'),
        ),
        body: AbsorbPointer(
          absorbing: _isProgressIndicatorShown,
          child: Stack(
            children: [
              // Your screen content here
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Show progress indicator
                    setState(() {
                      _isProgressIndicatorShown = true;
                    });

                    // Simulate some asynchronous task
                    Future.delayed(const Duration(seconds: 2), () {
                      // Hide progress indicator
                      setState(() {
                        _isProgressIndicatorShown = false;
                      });
                    });
                  },
                  child: const Text('Show Progress Indicator'),
                ),
              ),

              // Progress indicator
              if (_isProgressIndicatorShown)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
