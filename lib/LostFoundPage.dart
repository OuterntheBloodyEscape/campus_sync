import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Welcome.dart';

class LostFoundPage extends StatefulWidget {
  const LostFoundPage({super.key});

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  final TextEditingController searchController = TextEditingController();

  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF42A5F5);

  final List<Map<String, dynamic>> _items = [
    {
      "title": "Calculator",
      "desc": "Casio fx-991EX, found in room no 7A04, blue sticker on the back.",
      "status": "Available",
      "date": "28-03-2026",
    },
    {
      "title": "Umbrella",
      "desc": "Shonkor brand, green color.",
      "status": "Available",
      "date": "29-03-2026",
    },
    {
      "title": "ID Card",
      "desc": "ID: 00724105101130, found near the library entrance.",
      "status": "Available",
      "date": "29-03-2026",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _items
        .where((item) => item["title"]
        .toLowerCase()
        .contains(searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Lost & Found",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [primaryBlue, lightBlue]),
          ),
        ),
        actions: [_profileMenu(context)],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryBlue,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      drawer: CustomDrawer(pageNo: 4),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text("No items found"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return _buildItemCard(filteredItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    bool isPending = item["status"] == "Pending";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("FOUND ITEM",
                    style: TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11)),
                Text(item["date"],
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Divider(height: 20),
            Text(item["title"],
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(item["desc"], style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: primaryBlue.withOpacity(0.1)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: primaryBlue, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Collect from: 7C07 (Lost & Found room)",
                      style: TextStyle(
                          color: Color(0xFF0D47A1),
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            if (!isPending)
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {
                    setState(() => item["status"] = "Pending");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Claim initiated. Please visit room 7C07."),
                        backgroundColor: primaryBlue,
                      ),
                    );
                  },
                  child: const Text("Request Claim",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: primaryBlue, width: 1.5),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.hourglass_empty, color: primaryBlue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Pending Handover in 7C07...",
                      style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
          ],
        ),
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
          prefixIcon: const Icon(Icons.search, color: primaryBlue),
          hintText: "Search reported items...",
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: primaryBlue.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: primaryBlue),
          ),
        ),
      ),
    );
  }

  Widget _profileMenu(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) async {
        if (value == "profile") {
          Navigator.push(context, MaterialPageRoute(builder: (_) => StudentProfile()));
        } else {
          await FirebaseAuth.instance.signOut();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => WelcomeScreen()), (route) => false);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: "profile", child: Text("Profile")),
        const PopupMenuItem(value: "signout", child: Text("Sign Out")),
      ],
    );
  }

  void _showAddDialog() {
    final t1 = TextEditingController();
    final t2 = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Log Found Item", style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: t1, decoration: const InputDecoration(labelText: "Item Name")),
            TextField(controller: t2, decoration: const InputDecoration(labelText: "Details/Room No")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: () {
              if (t1.text.isNotEmpty) {
                setState(() {
                  _items.insert(0, {
                    "title": t1.text,
                    "desc": t2.text,
                    "status": "Available",
                    "date": "Today"
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Submit", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}