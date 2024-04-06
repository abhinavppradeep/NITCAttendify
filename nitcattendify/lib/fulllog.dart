// admin_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'fulllog.dart'; // Import the FullLogPage.dart file

class Fulllog extends StatefulWidget {
  @override
  _FulllogState createState() => _FulllogState();
}

class _FulllogState extends State<Fulllog> {
  List<Map<String, dynamic>> _logs = [];

  @override
  void initState() {
    super.initState();
    _fetchLogs();
  }

  Future<void> _fetchLogs() async {
    final response = await http
        .get(Uri.parse('https://nitcattendify.onrender.com/api/tag-event'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _logs = data.sublist(0, 10).cast<Map<String, dynamic>>();
      });
    } else {
      print('Failed to load logs');
    }
  }

  Future<void> _fetchAllLogs() async {
    final response = await http
        .get(Uri.parse('https://nitcattendify.onrender.com/api/tag-event'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _logs = data.cast<Map<String, dynamic>>();
      });
    } else {
      print('Failed to load logs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Logs'),
      ),
      body: _logs.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _logs.length,
              itemBuilder: (context, index) {
                final log = _logs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfilePage(tagId: log['tag_id'])),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          'Tag ID: ${log['tag_id']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Event Type: ${log['event_type']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Timestamp: ${log['timestamp']}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  final String tagId;

  const ProfilePage({Key? key, required this.tagId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileData = _getProfileData(tagId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tag ID: ${profileData['tag_id']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Name: ${profileData['name']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Email: ${profileData['email']}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Course: ${profileData['course']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getProfileData(String tagId) {
    if (tagId == '13ED1D11') {
      return {
        'tag_id': '13ED1D11',
        'name': 'Abhinav P Pradeep',
        'email': 'abhinav_b220623ec',
        'course': 'ECE',
      };
    } else if (tagId == '8354E8D') {
      return {
        'tag_id': '8354E8D',
        'name': 'Abhay K',
        'email': 'abhay_b220618ec',
        'course': 'ECE',
      };
    }
    // Default data if tagId doesn't match known values
    return {
      'tag_id': tagId,
      'name': 'Unknown',
      'email': 'Unknown',
      'course': 'Unknown',
    };
  }
}
