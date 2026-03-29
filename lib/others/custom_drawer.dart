import 'package:campus_sync/campus_home_page.dart';
import 'package:campus_sync/Canteen.dart';
import 'package:campus_sync/LibraryManagement.dart';
import 'package:campus_sync/lost_found_page.dart';
import 'package:flutter/material.dart';
import 'package:campus_sync/others/basic_custom_data_base.dart';
import 'package:campus_sync/students/previous_year_notes/admin.dart';
import 'package:campus_sync/students/previous_year_notes/students_notes.dart';
import 'package:campus_sync/students/student_teacher/Subject_List.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomDrawer extends StatefulWidget {
  final int pageNo;
  final String logInUser;
  final Map<String, User> ul;
  final List<Note> nl;
  const CustomDrawer({
    required this.ul,
    required this.logInUser,
    required this.nl,
    required this.pageNo,
    super.key,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
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
                        CampusHomePage(
                          ul: widget.ul,
                          logInUser: widget.logInUser,
                          nl: widget.nl,
                        ),

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
                        libraryManagement(
                          ul: widget.ul,
                          logInUser: widget.logInUser,
                          nl: widget.nl,
                        ),
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
                        Canteen(
                          ul: widget.ul,
                          logInUser: widget.logInUser,
                          nl: widget.nl,
                        ),

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
                        LostFoundPage(ul: widget.ul,
                          logInUser: widget.logInUser,
                          nl: widget.nl,),

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
                        Notes(
                          ul: widget.ul,
                          logInUser: widget.logInUser,
                          nl: widget.nl,
                        ),

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
            selected: (widget.pageNo == 6),
            selectedTileColor: Colors.blue.shade300,
            selectedColor: Colors.white,
            style: ListTileStyle.drawer,
            enabled: (widget.ul[widget.logInUser]!.admin),
            onTap: () {
              if (widget.pageNo != 6) {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        NotesAdmin(
                          ul: widget.ul,
                          logInUser: widget.logInUser,
                          nl: widget.nl,
                        ),

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
