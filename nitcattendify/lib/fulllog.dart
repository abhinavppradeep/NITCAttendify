import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        _logs = List<Map<String, dynamic>>.from(responseData['events']);
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
                return Padding(
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
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
