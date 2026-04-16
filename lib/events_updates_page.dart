import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Welcome.dart';

class EventsUpdatesPage extends StatefulWidget {
  const EventsUpdatesPage({super.key});

  @override
  State<EventsUpdatesPage> createState() => _EventsUpdatesPageState();
}

class _EventsUpdatesPageState extends State<EventsUpdatesPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = "All";

  final List<Map<String, dynamic>> updates = [
    {
      "title": "Final Examination Routine Published",
      "description": "Final exams will start from 15th May.",
      "date": "20-2-2026",
      "category": "Academic",
    },
    {
      "title": "AUST CSE Carnival 7.0",
      "description": "Join if u are interested in IAPC, GameJam, CTF, Hackathon, Chess competitions etc.",
      "date": "05-4-2026",
      "category": "Event",
    },
    {
      "title": "Semester Registration Notice",
      "description": "Registration for Spring 25 semester starts from March 10.",
      "date": "18-2-2026",
      "category": "Academic",
    },
  ];

  void _addUpdate(String title, String description, String category) {
    setState(() {
      updates.insert(0, {
        "title": title,
        "description": description,
        "date": "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",
        "category": category,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredUpdates = updates.where((update) {
      final matchesSearch = update["title"]
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
      final matchesCategory =
          selectedCategory == "All" || update["category"] == selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Events & Academic Updates",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
          ),
        ),
        actions: [
          _buildProfileMenu(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showAddDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      drawer: CustomDrawer(pageNo: 5),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategorySelector(),
          const SizedBox(height: 10),
          Expanded(
            child: filteredUpdates.isEmpty
                ? const Center(child: Text("No Updates Found"))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredUpdates.length,
              itemBuilder: (context, index) {
                return _updateCard(filteredUpdates[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        onChanged: (v) => setState(() {}),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "Search updates...",
          filled: true,
          fillColor: Colors.blue.shade50,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: ["All", "Event", "Academic"].map((category) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ChoiceChip(
            label: Text(category),
            selected: selectedCategory == category,
            selectedColor: Colors.blue.shade100,
            onSelected: (val) => setState(() => selectedCategory = category),
          ),
        );
      }).toList(),
    );
  }

  Widget _updateCard(Map<String, dynamic> update) {
    final isEvent = update["category"] == "Event";

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isEvent ? Icons.event : Icons.school, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  update["category"],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
            const Divider(),
            Text(update["title"],
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            const SizedBox(height: 8),
            Text(update["description"],
                style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 12),
            Text("Posted: ${update["date"]}",
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return PopupMenuButton(
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
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: "profile",
          child: Row(
            children: [
              Icon(Icons.account_circle, color: Colors.black),
              SizedBox(width: 8),
              Text("Profile"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: "signout",
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.black),
              SizedBox(width: 8),
              Text("Sign Out"),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String category = "Event";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("New Update"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: "Title")),
            TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: "Description")),
            DropdownButtonFormField(
              value: category,
              items: ["Event", "Academic"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => category = val.toString(),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isNotEmpty) {
                _addUpdate(titleCtrl.text, descCtrl.text, category);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}