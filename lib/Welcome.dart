import 'package:flutter/material.dart';
import 'package:campus_sync/auth/signin.dart';
import 'package:campus_sync/auth/signup.dart';

class WelcomeScreen extends StatefulWidget {

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool hidePass = true, enterLog = false, hideConfirmPass = true;
  double fy = 150.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          children: [
            Expanded(flex: 4, child: Image.asset("assets/Images/p1.png")),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignIn()),
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(300, 50),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: Colors.black),
                      ),
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(300, 50),
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.blue,
                        side: BorderSide(color: Colors.black),
                      ),
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
