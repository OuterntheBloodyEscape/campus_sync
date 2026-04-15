import 'package:campus_sync/Canteen.dart';
import 'package:campus_sync/LibraryManagement.dart';
import 'package:campus_sync/LostFoundPage.dart';
import 'package:campus_sync/Welcome.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/previous_year_notes/students_notes.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:flutter/material.dart';

class CampusHomePage extends StatefulWidget {
  const CampusHomePage({super.key});

  @override
  State<CampusHomePage> createState() => _CampusHomePageState();
}

class _CampusHomePageState extends State<CampusHomePage> {
  bool isDarkMode = false;
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> features = [
    {"title": "Smart Library ", "icon": Icons.local_library},
    {"title": "Canteen", "icon": Icons.restaurant},
    //{"title": "Smart Attendance", "icon": Icons.check_circle},
    //{"title": "Events & Academic Updates", "icon": Icons.event},
    //{"title": "Vacant Room Utilization", "icon": Icons.meeting_room},
    {"title": "Lost & Found", "icon": Icons.search},
    {"title": "Previous Year Notes", "icon": Icons.menu_book},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: _buildAppBar(),
        drawer: CustomDrawer(pageNo: 1),
        body: _buildBody(),
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
          onSelected: (value) {
            if (value == "profile") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentProfile()),
              );
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WelcomeScreen(),
                ),
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
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
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
              prefixIcon: const Icon(Icons.search),
              hintText: "Search features...",
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
                crossAxisCount = 4; // Web/Desktop
              } else if (constraints.maxWidth > 600) {
                crossAxisCount = 3; // Tablet
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
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 3),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  void _openPage(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          if (title == 'Smart Library ')
            return libraryManagement();
          else if (title == 'Canteen')
            return Canteen();
          else if (title == 'Lost & Found')
            return LostFoundPage();
          else
            return Notes();
        },
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final String title;
  const SimplePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
