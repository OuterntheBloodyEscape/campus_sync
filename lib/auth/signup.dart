import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campus_sync/others/custom_snack_bar.dart';
import 'package:campus_sync/others/layout_clip.dart';
import 'package:campus_sync/others/basic_custom_data_base.dart';

class SignUp extends StatefulWidget {
  final Map<String, User> ul;
  const SignUp({required this.ul, super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _em = TextEditingController(),
      _pass = TextEditingController(),
      _CPass = TextEditingController();
  double aeh = 1000, aop = 0;
  String dropValue = "Select";
  bool hidePass = true, hidePass_c = true;
  Color embc = Colors.black,
      pbc = Colors.black,
      cpbc = Colors.black,
      sc = Colors.black;
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 40, 0),
                            child: Text(
                              "Identity:",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: BoxBorder.all(width: 1, color: sc),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                              child: DropdownButton<String>(
                                dropdownColor: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                icon: Icon(Icons.keyboard_arrow_down),
                                value: dropValue,
                                underline: Container(color: Colors.transparent),
                                items: [
                                  DropdownMenuItem<String>(
                                    value: "Select",
                                    enabled: false,
                                    child: Text("Select"),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "students",
                                    child: Text("students"),
                                  ),
                                  DropdownMenuItem<String>(
                                    value: "Teacher",
                                    child: Text("Teacher"),
                                  ),
                                ],
                                onChanged: (String? V) {
                                  setState(() {
                                    dropValue = V!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
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
                          setState(() {
                            if (_em.text.isEmpty || _em.text.trim().isEmpty) {
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
                            } else if (dropValue == "Select") {
                              embc = pbc = cpbc = Colors.black;
                              sc = Colors.red.shade800;
                              CustomSnackBar().snackBarMessage(
                                context: context,
                                message: "Confirm your identity",
                                goodMessage: false,
                              );
                            } else {
                              embc = pbc = cpbc = sc = Colors.black;
                              if (widget.ul.containsKey(_em.text)) {
                                CustomSnackBar().snackBarMessage(
                                  context: context,
                                  message: "E-Mail is already used",
                                  goodMessage: false,
                                );
                              } else {
                                User u = User();
                                u.pass = _pass.text;
                                widget.ul[_em.text] = u;
                                Navigator.pop(context);
                                CustomSnackBar().snackBarMessage(
                                  context: context,
                                  message: "Registration Successful",
                                  goodMessage: true,
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
    );
  }
}
