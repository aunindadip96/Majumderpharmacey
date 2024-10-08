import 'package:flutter/material.dart';
import 'Notice_Api.dart';
import 'Notice_details_Scren.dart';
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

  NoticeCall noticeCall = NoticeCall();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Notices",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: noticeCall.fetchNotice(),
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
                  elevation: 5, // Add elevation for a 3D effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigate to the details screen and pass the selected notice
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoticeDetailsScreen(
                            notice: notice,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0), // Add padding inside the card
                      child: Row(
                        children: [
                          // Leading icon or placeholder
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent, // Background color for icon
                            child: Icon(
                              Icons.notifications, // Notice icon
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 12.0), // Space between icon and text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notice.header,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold, // Bold header
                                    color: Colors.black87, // Slightly darker color
                                  ),
                                ),
                                SizedBox(height: 4), // Space between header and description
                                Text(
                                  notice.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700], // Slightly faded description color
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.0), // Space between text and trailing
                          Text(
                            notice.createdAt.toString().split(' ')[0], // Show date
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey, // Date in grey
                            ),
                          ),
                        ],
                      ),
                    ),
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
