import 'package:flutter/material.dart';
import 'Nptice_Model.dart'; // Import your notice model

class NoticeDetailsScreen extends StatelessWidget {
  final Notice notice;

  NoticeDetailsScreen({required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title:  Text(
         notice.header,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice.header,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Published on: ${notice.createdAt.toString().split(' ')[0]}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12.0), // Internal padding
              decoration: BoxDecoration(
                color: Colors.white70, // Background color
                borderRadius: BorderRadius.circular(8.0), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12, // Shadow color
                    blurRadius: 6.0, // Soft blur for shadow
                    offset: Offset(0, 3), // Shadow position
                  ),
                ],
              ),
              child: Text(
                notice.description,
                style: TextStyle(fontSize: 16,color: Colors.black,fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),

            // You can add more details here if needed
          ],
        ),
      ),
    );
  }
}
