import 'package:flutter/material.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/others/custom_pair.dart';
import 'package:campus_sync/students/student_teacher/qr_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentClassRoom extends StatefulWidget {
  final String pageName;
  const StudentClassRoom({required this.pageName,super.key});

  @override
  State<StudentClassRoom> createState() => _StudentClassRoomState();
}

class _StudentClassRoomState extends State<StudentClassRoom> {
  late List<Pair<String,String>> list = [Pair("Present section", "QR"),Pair("C++ book", "link")];

  Future<void> _urlLaunch(int index) async {
    if (!await launchUrl(
      Uri.parse(""),
      mode: LaunchMode.inAppBrowserView,
    )) {
      throw Exception("cant run");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.pageName,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.account_circle_outlined))],
      ),
      body: ListView.separated(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.link, color: Colors.grey),
            title: Text(list[index].first, style: TextStyle(color: Colors.black)),
            style: ListTileStyle.list,
            subtitle: Text(list[index].second),
            onTap: () {
              if(list[index].second == "QR")
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>QrScanner()));
                }
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 20, thickness: 2);
        },
      ),
      drawer: Drawer(),
    );
  }
}
