// 1. Add these two imports at the top
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:campus_sync/Welcome.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splashScreen.dart';
import 'LibraryManagement.dart';
import 'Canteen.dart';
import 'package:flutter_animate/flutter_animate.dart';


void main() async {
  // 3. Add these two lines before runApp
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp()); // (This line will look whatever your app's main widget is)
}

/*PreferredSizeWidget APPBAR(String title) => AppBar(
  iconTheme: IconThemeData(color: Colors.white),
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
    PopupMenuButton(
      onSelected: (value) {
        if (value == "profile") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentProfile(
                ul: widget.ul,
                nl: widget.nl,
                logInUser: widget.logInUser,
              ),
            ),
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  WelcomeScreen(ul: widget.ul, nl: widget.nl),
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
  backgroundColor: Colors.blue,
  title: Text(title, style: TextStyle(color: Colors.white)),
  centerTitle: true,
);*/

/*Widget DRAWER(BuildContext context, String title, int trigger) => Drawer(
  backgroundColor: Colors.white,
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
        internalAddSemanticForOnTap: true,
        selected: (trigger == 1),
        selectedTileColor: Colors.blue.shade300,
        selectedColor: Colors.white,
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  libraryManagement(),

              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: 800.ms,
            ),
          );
        },
      ),
      ListTile(
        splashColor: Colors.blue,
        internalAddSemanticForOnTap: true,
        selected: (trigger == 1),
        selectedTileColor: Colors.blue.shade300,
        selectedColor: Colors.white,
        leading: Icon(Icons.restaurant),
        title: Text('Canteen'),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  libraryManagement(),

              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: 800.ms,
            ),
          );
        },
      ),
      ListTile(
        splashColor: Colors.blue,
        internalAddSemanticForOnTap: true,
        selected: (trigger == 1),
        selectedTileColor: Colors.blue.shade300,
        selectedColor: Colors.white,
        leading: Icon(Icons.local_library),
        title: Text('Smart Library'),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  libraryManagement(),

              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: 800.ms,
            ),
          );
        },
      ),
    ],
  ),
);*/

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //scaffoldBackgroundColor: Colors.white,
        colorSchemeSeed: Colors.white,
        //brightness: Brightness.dark,
      ),
      home: splashScreen(),
    );
  }
}
