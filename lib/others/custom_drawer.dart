import 'package:campus_sync/CampusHomePage.dart';
import 'package:campus_sync/Canteen.dart';
import 'package:campus_sync/LibraryManagement.dart';
import 'package:campus_sync/LostFoundPage.dart';
import 'package:campus_sync/events_updates_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_sync/students/previous_year_notes/admin.dart';
import 'package:campus_sync/students/previous_year_notes/students_notes.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomDrawer extends StatefulWidget {
  final int pageNo;

  const CustomDrawer({required this.pageNo, super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final User? _u = FirebaseAuth.instance.currentUser;
  late Map<String, dynamic> _up = {};
  bool isLoding = true;

  void _getUserData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(_u!.uid)
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
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: Image.asset('assets/Images/CampusSync.png')),
                const SizedBox(height: 10),
                const Flexible(
                  child: Text(
                    "CampusSync",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            splashColor: Colors.blue,
            leading: Icon(Icons.home_filled),
            title: Text("Home"),
            selected: (widget.pageNo == 1),
            selectedTileColor: Colors.blue.shade300,
            selectedColor: Colors.white,
            style: ListTileStyle.drawer,
            onTap: () {
              if (widget.pageNo != 1) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        CampusHomePage(),

                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: 800.ms,
                  ),
                );
              }
            },
          ),
          ListTile(
            splashColor: Colors.blue,
            leading: Icon(Icons.local_library),
            title: Text("Smart Library"),
            selected: (widget.pageNo == 2),
            selectedTileColor: Colors.blue.shade300,
            selectedColor: Colors.white,
            style: ListTileStyle.drawer,
            onTap: () {
              if (widget.pageNo != 2) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        libraryManagement(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: 800.ms,
                  ),
                );
              }
            },
          ),
          ListTile(
            splashColor: Colors.blue,
            leading: Icon(Icons.restaurant),
            title: Text("Canteen"),
            selected: (widget.pageNo == 3),
            selectedTileColor: Colors.blue.shade300,
            selectedColor: Colors.white,
            style: ListTileStyle.drawer,
            onTap: () {
              if (widget.pageNo != 3) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Canteen(),

                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: 800.ms,
                  ),
                );
              }
            },
          ),
          ListTile(
            splashColor: Colors.blue,
            leading: Icon(Icons.search),
            title: Text("Lost & Found"),
            selected: (widget.pageNo == 4),
            selectedTileColor: Colors.blue.shade300,
            selectedColor: Colors.white,
            style: ListTileStyle.drawer,
            onTap: () {
              if (widget.pageNo != 4) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        LostFoundPage(),

                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: 800.ms,
                  ),
                );
              }
            },
          ),
          ListTile(
            splashColor: Colors.blue,
            leading: Icon(Icons.event),
            title: Text("Events & Academic Updates"),
            selected: (widget.pageNo == 5),
            selectedTileColor: Colors.blue.shade300,
            selectedColor: Colors.white,
            style: ListTileStyle.drawer,
            onTap: () {
              if (widget.pageNo != 5) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        EventsUpdatesPage(),

                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: 800.ms,
                  ),
                );
              }
            },
          ),
          ListTile(
            splashColor: Colors.blue,
            leading: Icon(Icons.menu_book),
            title: Text("Previous Year Notes"),
            selected: (widget.pageNo == 6),
            selectedTileColor: Colors.blue.shade300,
            selectedColor: Colors.white,
            style: ListTileStyle.drawer,
            onTap: () {
              if (widget.pageNo != 6) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Notes(),

                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: 800.ms,
                  ),
                );
              }
            },
          ),
          ListTile(
            splashColor: Colors.blue,
            leading: Icon(Icons.admin_panel_settings),
            title: Text("Previous Year Notes Admin"),
            selected: (widget.pageNo == 7),
            selectedTileColor: Colors.blue.shade300,
            selectedColor: Colors.white,
            style: ListTileStyle.drawer,
            enabled: (_up["role"] == "admin"),
            onTap: () {
              if (widget.pageNo != 7) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        NotesAdmin(),

                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    transitionDuration: 800.ms,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
