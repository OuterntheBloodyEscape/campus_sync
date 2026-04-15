import 'package:campus_sync/Welcome.dart';
import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:flutter/material.dart';

class LostFoundPage extends StatefulWidget {

  const LostFoundPage({
    super.key,
  });

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  final String currentUserId = "user_1";

  final List<Map<String, dynamic>> items = [];
  String searchQuery = "";

  void _addItem() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final contactController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Found Item"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Item Name"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: "Short Description",
                  ),
                ),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: "Contact Info"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    contactController.text.isNotEmpty) {
                  setState(() {
                    items.add({
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "contact": contactController.text,
                      "addedBy": currentUserId,
                      "isClaimRequested": false,
                      "isClaimed": false,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _requestClaim(int index) {
    setState(() {
      items[index]["isClaimRequested"] = true;
    });
  }

  void _confirmClaim(int index) {
    setState(() {
      items[index]["isClaimed"] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = items.where((item) {
      final matchesSearch =
          item["title"].toLowerCase().contains(searchQuery.toLowerCase()) ||
          item["description"].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch && item["isClaimed"] == false;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Lost & Found",style: TextStyle(color: Colors.white),),
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
                  MaterialPageRoute(
                    builder: (context) => StudentProfile(
                    ),
                  ),
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
      ),

      drawer: CustomDrawer(
        pageNo: 4,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search items...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Text(
                      "No matching items",
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final originalIndex = items.indexOf(item);

                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["title"],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(item["description"]),
                              const SizedBox(height: 6),
                              Text(
                                "Contact: ${item["contact"]}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),

                              if (!item["isClaimRequested"])
                                ElevatedButton(
                                  onPressed: () => _requestClaim(originalIndex),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                  ),
                                  child: const Text("Request Claim"),
                                ),

                              if (item["isClaimRequested"] &&
                                  item["addedBy"] == currentUserId)
                                ElevatedButton(
                                  onPressed: () => _confirmClaim(originalIndex),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text("Confirm Claimed"),
                                ),

                              if (item["isClaimRequested"] &&
                                  item["addedBy"] != currentUserId)
                                const Text(
                                  "Claim requested. Waiting for confirmation.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
