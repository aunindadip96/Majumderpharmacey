import 'package:flutter/material.dart';

import 'Notice_Api.dart';
import 'Nptice_Model.dart';


class NoticeListScreen extends StatefulWidget {
  @override
  _NoticeListScreenState createState() => _NoticeListScreenState();
}

class _NoticeListScreenState extends State<NoticeListScreen> {

  @override
  void initState() {
    super.initState();
    // Fetch notices when the screen is initialized
  }
  NoticeCall Notice= NoticeCall();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notices'),
      ),
      body: FutureBuilder(
        future: Notice.fetchNotice(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading spinner
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message
            return Center(child: Text('Failed to load notices'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show empty state message
            return Center(child: Text('No notices available'));
          } else {
            // Show list of notices
            final notices = snapshot.data!;
            return ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(notice.header),
                    subtitle: Text(
                      notice.description, // Shorten if needed
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      notice.createdAt.toString().split(' ')[0], // Show date
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      // Handle on tap (e.g., navigate to details screen)
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
