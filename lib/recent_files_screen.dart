import 'package:flutter/material.dart';
//import 'package:open_file/open_file.dart';

class RecentFilesScreen extends StatefulWidget {
  @override
  _RecentFilesScreenState createState() => _RecentFilesScreenState();
}

class _RecentFilesScreenState extends State<RecentFilesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recent Files'),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.picture_as_pdf),
                    SizedBox(width: 20),
                    Text('Filename.pdf'),
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
