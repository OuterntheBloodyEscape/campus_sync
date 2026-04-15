import 'package:campus_sync/Canteen.dart';
import 'package:campus_sync/LibraryManagement.dart';
import 'package:campus_sync/events_updates_page.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/previous_year_notes/admin.dart';
import 'package:campus_sync/students/previous_year_notes/students_notes.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'LostFoundPage.dart';
import 'Welcome.dart';

class CampusHomePage extends StatefulWidget {
  const CampusHomePage({super.key});

  @override
  State<CampusHomePage> createState() => _CampusHomePageState();
}

class _CampusHomePageState extends State<CampusHomePage> {
  final User? _u = FirebaseAuth.instance.currentUser;
  late Map<String, dynamic> _up = {};
  bool isLoding = true;
  bool isDarkMode = false;
  final TextEditingController searchController = TextEditingController();

  late final List<Map<String, dynamic>> features = [
    {"title": "Smart Library", "icon": Icons.local_library},
    {"title": "Canteen", "icon": Icons.restaurant},
    {"title": "Lost & Found", "icon": Icons.search},
    {"title": "Events & Academic Updates", "icon": Icons.event},
    {"title": "Previous Year Notes", "icon": Icons.menu_book},
    if (_up["role"] == "students-admin")
      {
        "title": "Previous Year Notes Admin",
        "icon": Icons.admin_panel_settings,
      },
  ];

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        drawer: CustomDrawer(pageNo: 1),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        "CampusSync",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      actions: [
        PopupMenuButton(
          onSelected: (value) async {
            if (value == "profile") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentProfile()),
              );
            } else {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
                (route) => false,
              );
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: "profile",
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.account_circle, color: Colors.black),
                    ),
                    Text("Profile"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "signout",
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.logout, color: Colors.black),
                    ),
                    Text("Sign Out"),
                  ],
                ),
              ),
            ];
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    final filteredFeatures = features
        .where(
          (feature) => feature["title"].toLowerCase().contains(
            searchController.text.toLowerCase(),
          ),
        )
        .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome to CampusSync!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Stay connected with your campus life.",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search features...",
              hintStyle: TextStyle(),
              filled: true,
              fillColor: Colors.blue.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),

        const SizedBox(height: 20),

        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              if (constraints.maxWidth > 900) {
                crossAxisCount = 4;
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 3;
              }

              return GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredFeatures.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final feature = filteredFeatures[index];
                  return _featureCard(feature["title"], feature["icon"]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _featureCard(String title, IconData icon) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => _openPage(title),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPage(String title) {
    if (title == "Smart Library") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              libraryManagement(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: 800.ms,
        ),
      );
    } else if (title == "Canteen") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Canteen(),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: 800.ms,
        ),
      );
    } else if (title == "Lost & Found") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LostFoundPage(),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: 800.ms,
        ),
      );
    } else if (title == "Events & Academic Updates") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              EventsUpdatesPage(),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: 800.ms,
        ),
      );
    } else if (title == "Previous Year Notes") {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => Notes(),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: 800.ms,
        ),
      );
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => NotesAdmin(),

          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: 800.ms,
        ),
      );
    }
  }
}
