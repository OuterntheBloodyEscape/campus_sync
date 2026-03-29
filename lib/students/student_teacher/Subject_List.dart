import 'package:flutter/material.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:campus_sync/students/student_teacher/student_class_room.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({super.key});

  @override
  State<SubjectList> createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  late List<String> sl = ["CSE 2100", "CSE 2101"], tnl = ["abc", "xyz"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Class Room",
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
        actions: [
          IconButton(
            onPressed: () {
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentProfile()),
              );*/
            },
            icon: Icon(Icons.account_circle_outlined),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: sl.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              sl[index],
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ListTileStyle.list,
            subtitle: Text(tnl[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentClassRoom(pageName: sl[index]),
                ),
              );
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
