import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_sync/Welcome.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/others/custom_snack_bar.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../others/custom_search_delagate.dart';
import '../../others/custom_pair.dart';

class Notes extends StatefulWidget {
  const Notes({super.key});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  late List<Pair<String, String>> l = [];
  bool isLoding = true;
  final User? _u = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _dn = TextEditingController(),
      _dl = TextEditingController();

  Future<void> _urlLaunch(int index) async {
    if (!await launchUrl(
      Uri.parse(l[index].second),
      mode: LaunchMode.inAppBrowserView,
    )) {
      throw Exception("cant run");
    }
  }

  void getNote() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("note")
        .get();
    setState(() {
      qs.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        for (MapEntry<String, dynamic> me in data.entries) {
          l.add(Pair(me.key, me.value));
        }
        return data;
      }).toList();
      isLoding = false;
    });
  }

  @override
  void dispose() {
    _dn.dispose();
    _dl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoding) {
      getNote();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Previous Year Notes",
          style: TextStyle(color: Colors.white),
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
      ),
      body: ListView.separated(
        itemCount: l.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.link, color: Colors.grey),
            title: Text(l[index].first, style: TextStyle(color: Colors.black)),
            style: ListTileStyle.list,
            subtitle: Text(l[index].second),
            onTap: () {
              _urlLaunch(index);
            },
            onLongPress: () {},
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 20, thickness: 2);
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelagate(si: l),
              );
            },
            backgroundColor: Colors.blue.shade300,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Icon(Icons.search, size: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Add Documents Link"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 1, 0, 3),
                            child: TextField(
                              autofocus: true,
                              controller: _dn,
                              keyboardType: .text,
                              decoration: InputDecoration(
                                labelText: "Document Title",
                                hintText: "Name of Document",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue.shade300,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 3, 0, 0),
                            child: TextField(
                              controller: _dl,
                              keyboardType: .url,
                              decoration: InputDecoration(
                                labelText: "Document link",
                                hintText: "https://Document.link",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue.shade300,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() async {
                              if (_dn.text.isEmpty || _dn.text.trim().isEmpty) {
                              } else if (_dl.text.isEmpty ||
                                  _dl.text.trim().isEmpty ||
                                  !_dl.text.startsWith("https://")) {
                              } else {
                                await FirebaseFirestore.instance
                                    .collection("submitedNote")
                                    .doc(_u!.uid)
                                    .set({
                                      _dn.text: _dl.text,
                                    }, SetOptions(merge: true));
                                Navigator.pop(context);
                                _dl.text = "";
                                _dn.text = "";
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.shade300,
                          ),
                          child: Text(
                            "ADD",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.blue.shade300,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.add, size: 30),
              ),
            ),
          ),
        ],
      ),

      drawer: CustomDrawer(pageNo: 5),
    );
  }
}
