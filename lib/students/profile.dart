import 'dart:io';
import 'package:campus_sync/others/custom_snack_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:image_picker/image_picker.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  final User? _cu = FirebaseAuth.instance.currentUser;
  late Map<String, dynamic> _up = {};
  bool isLoding = true;
  String? imageUrl;
  final TextEditingController _name = TextEditingController(),
      _uni = TextEditingController(),
      _dep = TextEditingController(),
      _y = TextEditingController(),
      _s = TextEditingController();

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);

      String fileName =
          'user_profile_${DateTime.now().millisecondsSinceEpoch}.png';
      Reference ref = FirebaseStorage.instance.ref().child(
        'profiles/$fileName',
      );

      await ref.putFile(file);

      String downloadUrl = await ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    }
  }

  void _getUserData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(_cu!.uid)
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
    if (isLoding) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Center(
            child: Text(
              "CampusSync",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Loding...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          title: Center(
            child: Text(
              "CampusSync",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
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
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("Set profile info"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 1, 0, 3),
                            child: TextField(
                              autofocus: true,
                              controller: _name,
                              keyboardType: .name,
                              decoration: InputDecoration(
                                labelText: "Full-Name",
                                hintText: "Set Full Name",
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
                              controller: _uni,
                              keyboardType: .name,
                              decoration: InputDecoration(
                                labelText: "University",
                                hintText: "Name of University",
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
                              controller: _dep,
                              keyboardType: .name,
                              decoration: InputDecoration(
                                labelText: "Department",
                                hintText: "Name of Department",
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
                              controller: _y,
                              keyboardType: .number,
                              decoration: InputDecoration(
                                labelText: "Year",
                                hintText: "Running Year",
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
                              controller: _s,
                              keyboardType: .number,
                              decoration: InputDecoration(
                                labelText: "Semester",
                                hintText: "Running Semester",
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
                              try {
                                if (_name.text.trim().isNotEmpty) {await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(_cu!.uid)
                                    .update({
                                  "name": _name.text.trim()
                                });
                                _name.text = "";}
                                if (_uni.text.trim().isNotEmpty) { await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(_cu!.uid)
                                    .update({
                                  "uni": _uni.text.trim(),
                                });
                                _uni.text = "";}
                                if (_dep.text.trim().isNotEmpty) {await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(_cu!.uid)
                                    .update({

                                  "dept": _dep.text.trim(),

                                });
                                _dep.text = "";}
                                if (_y.text.trim().isNotEmpty) {await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(_cu!.uid)
                                    .update({

                                  "year": _y.text.trim(),

                                });
                                _y.text = "";}
                                if (_s.text.trim().isNotEmpty) {await FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(_cu!.uid)
                                    .update({
                                  "semester": _s.text.trim(),
                                });
                                _s.text = "";}

                                _getUserData();

                                Navigator.pop(context);

                                CustomSnackBar().snackBarMessage(
                                  context: context,
                                  message: "Profile Updated Successfully",
                                  goodMessage: true,
                                );
                              } catch (e) {
                                CustomSnackBar().snackBarMessage(
                                  context: context,
                                  message: "Error updating profile: $e",
                                  goodMessage: false,
                                );
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.shade300,
                          ),
                          child: Text(
                            "SET",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.edit),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                          onTap: uploadImage,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade300,
                            radius: 60,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl!)
                                : null,
                            child: imageUrl == null
                                ? const Icon(
                                    Icons.add_a_photo,
                                    size: 40,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _up["name"]!,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "${_up["uni"]!} | ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  _up["dept"]!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Year: ${_up["year"]!} | ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  "Semester: ${_up["semester"]!}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),

                            Text(
                              "UID: ${_up["uid"]!}",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: CustomDrawer(pageNo: 0),
      );
    }
  }
}
