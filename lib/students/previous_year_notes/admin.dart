import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:campus_sync/Welcome.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../others/custom_search_delagate.dart';
import '../../others/custom_pair.dart';

class NotesAdmin extends StatefulWidget {
  const NotesAdmin({super.key});

  @override
  State<NotesAdmin> createState() => _NotesAdminState();
}

class _NotesAdminState extends State<NotesAdmin> {
  final User? _cu = FirebaseAuth.instance.currentUser;
  late List<Pair<String, String>> l = [];
  late List<String> ali = [];
  bool isLoding = true;

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

  void _getSubmitedNote() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("submitedNote")
        .get();
    setState(() {
      qs.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        for (MapEntry<String, dynamic> me in data.entries) {
          l.add(Pair(me.key, me.value));
          ali.add(doc.id);
        }
        return data;
      }).toList();
      isLoding = false;
    });
  }

  @override
  void dispose() {
    _dl.dispose();
    _dn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoding) {
      _getSubmitedNote();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Center(
          child: Text("Admin", style: TextStyle(color: Colors.white)),
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("submitedNote")
                        .doc(ali[index])
                        .update({l[index].first: FieldValue.delete()});
                    setState(() {
                      l.removeAt(index);
                      ali.removeAt(index);
                    });
                  },
                  icon: Icon(Icons.close, color: Colors.red),
                ),
                IconButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection("note")
                        .doc(ali[index])
                        .set({
                          l[index].first: l[index].second,
                        }, SetOptions(merge: true));
                    await FirebaseFirestore.instance
                        .collection("submitedNote")
                        .doc(ali[index])
                        .update({l[index].first: FieldValue.delete()});
                    setState(() {
                      l.removeAt(index);
                      ali.removeAt(index);
                    });
                  },
                  icon: Icon(Icons.check, color: Colors.green),
                ),
              ],
            ),
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
      floatingActionButton: FloatingActionButton(
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
      drawer: CustomDrawer(pageNo: 6),
    );
  }
}
