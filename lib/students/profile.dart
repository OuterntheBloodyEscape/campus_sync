import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_sync/others/custom_drawer.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final User? _cu = FirebaseAuth.instance.currentUser;
  late Map<String, dynamic> _up = {};
  bool isLoding = true;

  void _getUserData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(_cu!.uid)
        .get();
    setState(() {
      _up = doc.data() as Map<String, dynamic>;
      isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoding) {
      _getUserData();
    }
    if (isLoding) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Center(
            child: Text(
              "CampusSync",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Loding...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Center(
            child: Text(
              "CampusSync",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(content: Text("Hello"));
                  },
                );
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.blue.shade300,
                          radius: 60,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _up["name"]!,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${_up["uni"]!} | ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  _up["dept"]!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Year: ${_up["year"]!} | ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  "Semester: ${_up["semester"]!}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              _up["uid"]!,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          value: 70,
                          color: Colors.blue.shade500,
                          backgroundColor: Colors.grey,
                          strokeWidth: 200,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: CustomDrawer(pageNo: 0),
      );
    }
  }
}
