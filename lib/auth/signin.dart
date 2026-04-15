import 'dart:async';
import 'package:campus_sync/CampusHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campus_sync/others/custom_snack_bar.dart';
import 'package:campus_sync/others/layout_clip.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _fa = FirebaseAuth.instance;
  final TextEditingController _em = TextEditingController(),
      _pass = TextEditingController();
  double aeh = 1000, aop = 0;
  bool hidePass = true;
  Color embc = Colors.black, pbc = Colors.black;
  @override
  void initState() {
    Timer.periodic(Duration(microseconds: 1), (t) {
      if (aeh > 300) {
        setState(() {
          aeh -= 50;
        });
      } else {
        setState(() {
          aop = 1;
        });
        t.cancel();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _em.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                expandedHeight: aeh,
                flexibleSpace: ClipPath(
                  clipper: ((aeh > 300) ? (DefaultClip()) : (CustomClip())),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: aop,
                        curve: Curves.decelerate,
                        duration: Duration(seconds: 1),
                        child: Text(
                          "CampusSync",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 70, 20, 0),
                          child: TextFormField(
                            keyboardType: .emailAddress,
                            controller: _em,
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintText: "example@email.edu",
                              labelStyle: TextStyle(color: embc),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(color: embc, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: embc, width: 2),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextFormField(
                            controller: _pass,
                            keyboardType: .visiblePassword,
                            obscureText: hidePass,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePass = !hidePass;
                                  });
                                },
                                icon: Icon(
                                  ((hidePass)
                                      ? (CupertinoIcons.eye_fill)
                                      : (CupertinoIcons.eye_slash_fill)),
                                ),
                              ),
                              labelStyle: TextStyle(color: pbc),
                              labelText: "Password",
                              hintText: "Enter Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(color: pbc, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: pbc, width: 2),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(300, 50),
                              backgroundColor: Colors.blue.shade300,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () async {
                              if (_em.text.isEmpty || _em.text.trim().isEmpty) {
                                setState(() {
                                  embc = Colors.red.shade800;
                                  CustomSnackBar().snackBarMessage(
                                    context: context,
                                    message: "E-Mail should be fill",
                                    goodMessage: false,
                                  );
                                });
                              } else if (_pass.text.isEmpty ||
                                  _pass.text.trim().isEmpty) {
                                setState(() {
                                  embc = Colors.black;
                                  pbc = Colors.red.shade800;
                                  CustomSnackBar().snackBarMessage(
                                    context: context,
                                    message: "Password should be fill",
                                    goodMessage: false,
                                  );
                                });
                              } else {
                                User? u;
                                String message = "SignIn Successful";
                                try {
                                  UserCredential uc = await _fa
                                      .signInWithEmailAndPassword(
                                        email: _em.text,
                                        password: _pass.text,
                                      );
                                  u = uc.user;
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    message = 'No user found for that email.';
                                  } else if (e.code == 'wrong-password') {
                                    message =
                                        'Wrong password provided for that user.';
                                  } else if (e.code == 'invalid-email') {
                                    message = 'The email address is not valid.';
                                  } else {
                                    message = "$e";
                                  }
                                  u = null;
                                } catch (e) {
                                  message = "Error: $e";
                                  u = null;
                                }

                                if (u != null) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CampusHomePage(),
                                    ),
                                    (route) => false,
                                  );
                                  CustomSnackBar().snackBarMessage(
                                    context: context,
                                    message: message,
                                    goodMessage: true,
                                  );
                                } else {
                                  CustomSnackBar().snackBarMessage(
                                    context: context,
                                    message: message,
                                    goodMessage: false,
                                  );
                                }
                              }
                            },
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
