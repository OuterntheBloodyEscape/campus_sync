import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campus_sync/others/custom_snack_bar.dart';
import 'package:campus_sync/others/layout_clip.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _fa = FirebaseAuth.instance;
  final TextEditingController _em = TextEditingController(),
      _pass = TextEditingController(),
      _CPass = TextEditingController(),
      _name = TextEditingController();
  double aeh = 1000, aop = 0;
  bool hidePass = true, hidePass_c = true;
  Color embc = Colors.black,
      pbc = Colors.black,
      cpbc = Colors.black,
      sc = Colors.black,
      nbc = Colors.black;

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
    _CPass.dispose();
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
                expandedHeight: aeh,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
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
                            keyboardType: TextInputType.name,
                            controller: _name,
                            decoration: InputDecoration(
                              labelText: "Full-Name",
                              hintText: "Name",
                              labelStyle: TextStyle(color: nbc),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(color: nbc, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: nbc, width: 2),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
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
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: TextFormField(
                            controller: _CPass,
                            keyboardType: .visiblePassword,
                            obscureText: hidePass_c,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePass_c = !hidePass_c;
                                  });
                                },
                                icon: Icon(
                                  ((hidePass_c)
                                      ? (CupertinoIcons.eye_fill)
                                      : (CupertinoIcons.eye_slash_fill)),
                                ),
                              ),
                              labelStyle: TextStyle(color: cpbc),
                              labelText: "Confirm Password",
                              hintText: "Same Password Again",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(color: cpbc, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: cpbc, width: 2),
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
                            onPressed: () {
                              setState(() async {
                                if (_name.text.isEmpty ||
                                    _name.text.trim().isEmpty) {
                                  nbc = Colors.red.shade800;
                                  CustomSnackBar().snackBarMessage(
                                    context: context,
                                    message: "Full-Name should be fill",
                                    goodMessage: false,
                                  );
                                }
                                else if (_em.text.isEmpty ||
                                    _em.text.trim().isEmpty) {
                                  embc = Colors.red.shade800;
                                  CustomSnackBar().snackBarMessage(
                                    context: context,
                                    message: "E-Mail should be fill",
                                    goodMessage: false,
                                  );
                                } else if (_pass.text.isEmpty ||
                                    _pass.text.trim().isEmpty) {
                                  embc = Colors.black;
                                  pbc = Colors.red.shade800;
                                  CustomSnackBar().snackBarMessage(
                                    context: context,
                                    message: "Password should be fill",
                                    goodMessage: false,
                                  );
                                } else if (_CPass.text.isEmpty ||
                                    _CPass.text.trim().isEmpty) {
                                  embc = pbc = Colors.black;
                                  cpbc = Colors.red.shade800;
                                  CustomSnackBar().snackBarMessage(
                                    context: context,
                                    message: "Confirm Password should be fill",
                                    goodMessage: false,
                                  );
                                } else if (_CPass.text != _pass.text) {
                                  embc = pbc = Colors.black;
                                  cpbc = Colors.red.shade800;
                                  CustomSnackBar().snackBarMessage(
                                    context: context,
                                    message:
                                        "Confirm Password should be equel to Password\nyou enter before",
                                    goodMessage: false,
                                  );
                                } else {
                                  String message = "Registration Successful";
                                  User? u;

                                  try {
                                    UserCredential uc = await _fa
                                        .createUserWithEmailAndPassword(
                                          email: _em.text,
                                          password: _pass.text,
                                        );
                                    u = uc.user;
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      message =
                                          'The password provided is too weak. (Needs at least 6 characters)';
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      message =
                                          'An account already exists for that email.';
                                    } else if (e.code == 'invalid-email') {
                                      message =
                                          'The email address is not formatted correctly.';
                                    } else {
                                      message = "$e";
                                    }
                                    u = null;
                                  } catch (e) {
                                    message =
                                        "An unexpected error occurred: $e";
                                    u = null;
                                  }

                                  if (u != null) {
                                    await FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(u.uid)
                                        .set({
                                          "name": _name.text,
                                          "uni": "University",
                                          "dept": "Dept",
                                          "year": "Year",
                                          "semester": "Semester",
                                          "uid": u.uid,
                                          "email": _em.text,
                                          "role": "students",
                                        });
                                    await _fa.signOut();
                                    Navigator.pop(context);
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
                              });
                            },
                            child: Text(
                              "Sign up",
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
