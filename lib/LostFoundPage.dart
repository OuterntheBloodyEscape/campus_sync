/*import 'package:campus_sync/others/custom_drawer.dart';
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

  bool isAdmin = true;

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
      "status": "Pending",
      "date": "29-03-2026",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _items.where((item) =>
        item["title"].toLowerCase().contains(searchController.text.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Lost & Found", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF1976D2), Color(0xFF42A5F5)]),
          ),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) async{
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      drawer: CustomDrawer(pageNo: 4),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (v) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                hintText: "Search reported items...",
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text("No items found"))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _buildItemCard(item);
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
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("FOUND", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
                Text(item["date"], style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Divider(),
            Text(item["title"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(item["desc"], style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Collect from room no: 7C07 (Lost & Found room)",
                      style: TextStyle(color: Color(0xFF1565C0), fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            if (!isPending && !isAdmin)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                  onPressed: () => setState(() => item["status"] = "Pending"),
                  child: const Text("Request Claim"),
                ),
              ),

            if (isAdmin && isPending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                  onPressed: () {
                    setState(() => _items.remove(item));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Handover Verified. Post Deleted.")));
                  },
                  icon: const Icon(Icons.delete_forever),
                  label: const Text("Verify Handover & Delete"),
                ),
              ),

            if (!isAdmin && isPending)
              const Center(child: Text("Pending Handover in 7C07...", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  void _showAddDialog() {
    final t1 = TextEditingController();
    final t2 = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Log Found Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: t1, decoration: const InputDecoration(labelText: "Item Name")),
            TextField(controller: t2, decoration: const InputDecoration(labelText: "Found Location/Details")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _items.insert(0, {
                  "title": t1.text,
                  "desc": t2.text,
                  "status": "Available",
                  "date": "Today"
                });
              });
              Navigator.pop(ctx);
            },
            child: const Text("FOUND"),
          ),
        ],
      ),
    );
  }
} */

/*import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Welcome.dart';

class LostFoundPage extends StatefulWidget {
  final bool isAdmin;

  const LostFoundPage({super.key, this.isAdmin = false}); // default: normal student

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> {
  final TextEditingController searchController = TextEditingController();

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
      "status": "Pending",
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
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Lost & Found",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
            ),
          ),
        ),
        actions: [
          // Admin badge indicator
          if (widget.isAdmin)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.shield, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text("Admin",
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
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
            itemBuilder: (context) => [
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
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Report Found", style: TextStyle(color: Colors.white)),
      ),

      drawer: CustomDrawer(pageNo: 4),

      body: Column(
        children: [
          // Stats banner (admin only)
          if (widget.isAdmin)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip(
                    "Total",
                    "${_items.length}",
                    Icons.inventory_2,
                  ),
                  _buildStatChip(
                    "Available",
                    "${_items.where((i) => i['status'] == 'Available').length}",
                    Icons.check_circle,
                  ),
                  _buildStatChip(
                    "Pending",
                    "${_items.where((i) => i['status'] == 'Pending').length}",
                    Icons.pending_actions,
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: (v) => setState(() {}),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                hintText: "Search reported items...",
                filled: true,
                fillColor: Colors.blue.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: filteredItems.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    "No items found",
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _buildItemCard(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    bool isPending = item["status"] == "Pending";

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "FOUND",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                ),
                Row(
                  children: [
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isPending
                            ? Colors.orange.shade50
                            : Colors.green.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPending ? "Pending" : "Available",
                        style: TextStyle(
                          color: isPending ? Colors.orange : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(item["date"],
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),

            const Divider(),

            Text(item["title"],
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(item["desc"],
                style: const TextStyle(color: Colors.black87)),
            const SizedBox(height: 12),

            // Collection location
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Collect from room no: 7C07 (Lost & Found room)",
                      style: TextStyle(
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // ─── NORMAL STUDENT: can request claim if Available ───
            if (!widget.isAdmin && !isPending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () =>
                      setState(() => item["status"] = "Pending"),
                  icon: const Icon(Icons.pan_tool),
                  label: const Text("Request Claim"),
                ),
              ),

            // ─── NORMAL STUDENT: pending message ───
            if (!widget.isAdmin && isPending)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pending_actions,
                        color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Pending Handover in 7C07...",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

            // ─── ADMIN ONLY: verify handover & delete (only when Pending) ───
            if (widget.isAdmin && isPending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    _showVerifyDialog(item);
                  },
                  icon: const Icon(Icons.verified),
                  label: const Text("Verify Handover & Delete"),
                ),
              ),

            // ─── ADMIN: delete any item anytime ───
            if (widget.isAdmin && !isPending)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showDeleteDialog(item),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text("Remove Post"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showVerifyDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.verified, color: Colors.green),
            SizedBox(width: 8),
            Text("Confirm Handover"),
          ],
        ),
        content: Text(
            "Confirm that \"${item['title']}\" has been handed over to the owner?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              setState(() => _items.remove(item));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("✅ Handover Verified. Post Deleted."),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Confirm",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.redAccent),
            SizedBox(width: 8),
            Text("Remove Post"),
          ],
        ),
        content:
        Text("Are you sure you want to remove \"${item['title']}\"?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              setState(() => _items.remove(item));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Post removed."),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text("Remove",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    final t1 = TextEditingController();
    final t2 = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.add_box, color: Colors.blue),
            SizedBox(width: 8),
            Text("Log Found Item"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: t1,
              decoration: InputDecoration(
                labelText: "Item Name",
                prefixIcon: const Icon(Icons.label),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: t2,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Found Location / Details",
                prefixIcon: const Icon(Icons.description),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: () {
              if (t1.text.trim().isEmpty) return;
              setState(() {
                _items.insert(0, {
                  "title": t1.text.trim(),
                  "desc": t2.text.trim(),
                  "status": "Available",
                  "date": "Today",
                });
              });
              Navigator.pop(ctx);
            },
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text("Submit",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
} */

/*import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Welcome.dart';

class LostFoundPage extends StatefulWidget {
  final bool isAdmin;
  const LostFoundPage({super.key, this.isAdmin = false});

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  late TabController _tabController;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Admins see 2 tabs: Approved items + Pending submissions
    // Normal students see only 1 tab: Approved items
    _tabController = TabController(
      length: widget.isAdmin ? 2 : 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchController.dispose();
    super.dispose();
  }

  // ─── THEME COLORS ──────────────────────────────────────────────
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color surfaceBlue = Color(0xFFE3F2FD);
  static const Color deepBlue = Color(0xFF0D47A1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F7FF),
      appBar: _buildAppBar(),
      floatingActionButton: _buildFAB(),
      drawer: CustomDrawer(pageNo: 4),
      body: Column(
        children: [
          _buildSearchBar(),
          if (widget.isAdmin) _buildAdminTabBar(),
          Expanded(
            child: widget.isAdmin
                ? TabBarView(
              controller: _tabController,
              children: [
                _buildApprovedList(),
                _buildPendingSubmissions(),
              ],
            )
                : _buildApprovedList(),
          ),
        ],
      ),
    );
  }

  // ─── APP BAR ───────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        "Lost & Found",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [deepBlue, primaryBlue, lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      bottom: widget.isAdmin
          ? TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white60,
        tabs: const [
          Tab(icon: Icon(Icons.inventory_2), text: "Approved"),
          Tab(icon: Icon(Icons.pending_actions), text: "Pending Review"),
        ],
      )
          : null,
      actions: [
        if (widget.isAdmin)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield, color: Colors.white, size: 14),
                SizedBox(width: 4),
                Text("Admin",
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        PopupMenuButton(
          color: Colors.white,
          onSelected: (value) async {
            if (value == "profile") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => StudentProfile()));
            } else {
              await _auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => WelcomeScreen()),
                    (route) => false,
              );
            }
          },
          itemBuilder: (_) => [
            PopupMenuItem(
              value: "profile",
              child: Row(children: [
                const Icon(Icons.account_circle, color: primaryBlue),
                const SizedBox(width: 10),
                const Text("Profile"),
              ]),
            ),
            PopupMenuItem(
              value: "signout",
              child: Row(children: [
                const Icon(Icons.logout, color: primaryBlue),
                const SizedBox(width: 10),
                const Text("Sign Out"),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  // ─── FAB ───────────────────────────────────────────────────────
  Widget _buildFAB() {
    return FloatingActionButton.extended(
      backgroundColor: primaryBlue,
      onPressed: _showAddDialog,
      icon: const Icon(Icons.add, color: Colors.white),
      label: const Text("Report Found",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      elevation: 4,
    );
  }

  // ─── SEARCH BAR ────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        onChanged: (v) => setState(() {}),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: primaryBlue),
          hintText: "Search reported items...",
          hintStyle: TextStyle(color: Colors.blue.shade200),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.blue.shade100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.blue.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
        ),
      ),
    );
  }

  // ─── ADMIN TAB BAR STATS ───────────────────────────────────────
  Widget _buildAdminTabBar() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('lost_found_items').snapshots(),
      builder: (context, approvedSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('found_submissions')
              .where('approved', isEqualTo: false)
              .snapshots(),
          builder: (context, pendingSnap) {
            final approved = approvedSnap.data?.docs.length ?? 0;
            final pending = pendingSnap.data?.docs.length ?? 0;
            return Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              padding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [deepBlue, primaryBlue],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statChip("Approved", "$approved", Icons.check_circle),
                  _statChip("Pending", "$pending", Icons.pending_actions),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _statChip(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  // ─── APPROVED ITEMS LIST (visible to all) ─────────────────────
  Widget _buildApprovedList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('lost_found_items')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: primaryBlue));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _emptyState("No items posted yet", Icons.inventory_2_outlined);
        }

        final query = searchController.text.toLowerCase();
        final docs = snapshot.data!.docs.where((doc) {
          final title = (doc['title'] as String).toLowerCase();
          return title.contains(query);
        }).toList();

        if (docs.isEmpty) {
          return _emptyState("No items match your search", Icons.search_off);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            return _buildApprovedCard(doc);
          },
        );
      },
    );
  }

  // ─── PENDING SUBMISSIONS (admin only) ─────────────────────────
  Widget _buildPendingSubmissions() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('found_submissions')
          .where('approved', isEqualTo: false)
          .orderBy('submittedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: primaryBlue));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _emptyState(
              "No pending submissions", Icons.check_circle_outline);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            return _buildSubmissionCard(doc);
          },
        );
      },
    );
  }

  // ─── APPROVED ITEM CARD ────────────────────────────────────────
  Widget _buildApprovedCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final isPending = data['status'] == 'Pending';
    final currentUid = _auth.currentUser?.uid ?? '';

    // Check if current user already has a pending claim
    final claimantId = data['claimantId'] ?? '';
    final userAlreadyClaimed = claimantId == currentUid;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [deepBlue, primaryBlue]),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("FOUND",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ),
                Row(
                  children: [
                    _statusBadge(isPending ? "Pending" : "Available",
                        isPending ? Colors.orange : Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      data['date'] ?? '',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),

            // ── Title & Description ──
            Text(data['title'] ?? '',
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B2A))),
            const SizedBox(height: 6),
            Text(data['desc'] ?? '',
                style: TextStyle(
                    color: Colors.grey.shade700, fontSize: 13)),
            const SizedBox(height: 10),

            // ── Location chip ──
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: surfaceBlue,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: const Row(
                children: [
                  Icon(Icons.location_on, color: primaryBlue, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Collect from room no: 7C07 (Lost & Found room)",
                      style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ── Action buttons ──

            // NORMAL STUDENT: Request Claim
            if (!widget.isAdmin && !isPending)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                  ),
                  onPressed: () => _requestClaim(doc.id, data),
                  icon: const Icon(Icons.pan_tool_alt, size: 18),
                  label: const Text("Request Claim",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),

            // NORMAL STUDENT: Already claimed / pending
            if (!widget.isAdmin && isPending && userAlreadyClaimed)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: surfaceBlue,
                  borderRadius: BorderRadius.circular(10),
                  border:
                  Border.all(color: Colors.blue.shade200),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pending_actions,
                        color: primaryBlue, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Claim Submitted – Pending Handover in 7C07",
                      style: TextStyle(
                          color: primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),

            // NORMAL STUDENT: Someone else claimed
            if (!widget.isAdmin && isPending && !userAlreadyClaimed)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Text(
                      "Claim under review by admin",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),

            // ADMIN: Pending claim — verify or reject
            if (widget.isAdmin && isPending) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Text(
                  "Claim by: ${data['claimantName'] ?? 'Unknown'}\nID: ${data['claimantId'] ?? ''}",
                  style: TextStyle(
                      color: Colors.orange.shade800, fontSize: 13),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () =>
                          _showVerifyHandoverDialog(doc.id, data),
                      icon: const Icon(Icons.verified, size: 18),
                      label: const Text("Verify & Delete",
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () =>
                          _rejectClaim(doc.id),
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text("Reject Claim",
                          style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ],

            // ADMIN: No claim yet — just delete option
            if (widget.isAdmin && !isPending)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => _showDeleteDialog(doc.id, data['title']),
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text("Remove Post"),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─── SUBMISSION CARD (admin review) ───────────────────────────
  Widget _buildSubmissionCard(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Text("PENDING REVIEW",
                      style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 11)),
                ),
                Text(data['date'] ?? '',
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 12)),
              ],
            ),
            const Divider(height: 20),
            Text(data['title'] ?? '',
                style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B2A))),
            const SizedBox(height: 6),
            Text(data['desc'] ?? '',
                style:
                TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            const SizedBox(height: 6),
            Text(
              "Submitted by: ${data['submitterName'] ?? 'Unknown'}",
              style: TextStyle(
                  color: Colors.blue.shade600,
                  fontSize: 12,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => _approveSubmission(doc.id, data),
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text("Approve"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () =>
                        _rejectSubmission(doc.id),
                    icon: const Icon(Icons.cancel, size: 18),
                    label: const Text("Reject"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── FIREBASE ACTIONS ──────────────────────────────────────────

  /// Student submits a found item → goes to found_submissions (pending)
  Future<void> _submitFoundItem(String title, String desc) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final now = DateTime.now();
    final dateStr =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";

    await _firestore.collection('found_submissions').add({
      'title': title,
      'desc': desc,
      'status': 'Available',
      'date': dateStr,
      'submitterId': user.uid,
      'submitterName': user.displayName ?? user.email ?? 'Unknown',
      'approved': false,
      'submittedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Admin approves submission → moves to lost_found_items
  Future<void> _approveSubmission(
      String submissionId, Map<String, dynamic> data) async {
    final batch = _firestore.batch();

    // Add to approved collection
    final approvedRef = _firestore.collection('lost_found_items').doc();
    batch.set(approvedRef, {
      'title': data['title'],
      'desc': data['desc'],
      'status': 'Available',
      'date': data['date'],
      'submitterId': data['submitterId'],
      'submitterName': data['submitterName'],
      'claimantId': '',
      'claimantName': '',
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Remove from submissions
    final subRef =
    _firestore.collection('found_submissions').doc(submissionId);
    batch.delete(subRef);

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Post approved and published!"),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Admin rejects submission → deletes from found_submissions
  Future<void> _rejectSubmission(String submissionId) async {
    await _firestore
        .collection('found_submissions')
        .doc(submissionId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Submission rejected and removed."),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  /// Student requests claim on an item
  Future<void> _requestClaim(
      String docId, Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('lost_found_items').doc(docId).update({
      'status': 'Pending',
      'claimantId': user.uid,
      'claimantName': user.displayName ?? user.email ?? 'Unknown',
      'claimedAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:
        Text("Claim submitted! Visit room 7C07 with your proof."),
        backgroundColor: primaryBlue,
      ),
    );
  }

  /// Admin rejects a claim → resets item to Available
  Future<void> _rejectClaim(String docId) async {
    await _firestore.collection('lost_found_items').doc(docId).update({
      'status': 'Available',
      'claimantId': '',
      'claimantName': '',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Claim rejected. Item set back to Available."),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Admin verifies handover → deletes from Firestore entirely
  Future<void> _verifyAndDelete(String docId) async {
    await _firestore
        .collection('lost_found_items')
        .doc(docId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("✅ Handover verified. Post deleted."),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Admin deletes any item directly
  Future<void> _deleteItem(String docId) async {
    await _firestore
        .collection('lost_found_items')
        .doc(docId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Post removed."),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // ─── DIALOGS ───────────────────────────────────────────────────

  void _showVerifyHandoverDialog(
      String docId, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.verified, color: Colors.green),
            SizedBox(width: 8),
            Text("Confirm Handover"),
          ],
        ),
        content: Text(
          "Confirm \"${data['title']}\" has been handed over to ${data['claimantName']}?\n\nThis will permanently delete the post from Firebase.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () async {
              Navigator.pop(ctx);
              await _verifyAndDelete(docId);
            },
            child: const Text("Confirm",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String docId, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.delete_forever, color: Colors.redAccent),
            SizedBox(width: 8),
            Text("Remove Post"),
          ],
        ),
        content: Text(
            "Remove \"$title\"? This will also delete it from Firebase."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style:
            ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () async {
              Navigator.pop(ctx);
              await _deleteItem(docId);
            },
            child: const Text("Remove",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddDialog() {
    final t1 = TextEditingController();
    final t2 = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.add_box, color: primaryBlue),
            SizedBox(width: 8),
            Text("Report Found Item"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Your submission will be reviewed by an admin before being published.",
              style: TextStyle(
                  color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: t1,
              decoration: InputDecoration(
                labelText: "Item Name",
                prefixIcon:
                const Icon(Icons.label, color: primaryBlue),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: primaryBlue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: t2,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Details / Where Found",
                prefixIcon:
                const Icon(Icons.description, color: primaryBlue),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: primaryBlue, width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue),
            onPressed: () async {
              if (t1.text.trim().isEmpty) return;
              await _submitFoundItem(
                  t1.text.trim(), t2.text.trim());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "Submitted! Waiting for admin approval."),
                  backgroundColor: primaryBlue,
                ),
              );
            },
            icon:
            const Icon(Icons.send, color: Colors.white, size: 18),
            label: const Text("Submit",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── HELPERS ───────────────────────────────────────────────────

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11)),
    );
  }

  Widget _emptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.blue.shade100),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(
                  color: Colors.blue.shade200, fontSize: 16)),
        ],
      ),
    );
  }
} */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LostFoundPage extends StatefulWidget {
  const LostFoundPage({super.key});

  @override
  State<LostFoundPage> createState() => _LostFoundPageState();
}

class _LostFoundPageState extends State<LostFoundPage> with TickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;

  // Theme Constants
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color deepBlue = Color(0xFF0D47A1);

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Access Denied. Please Login.")));
    }

    // --- STEP 1: Listen to User Role from 'users' collection ---
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(user.uid).snapshots(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
        final String role = userData?['role'] ?? 'students';
        final String userName = userData?['name'] ?? 'User';
        final bool isAdmin = (role == 'students-admin');

        // Dynamically manage TabController length
        int tabCount = isAdmin ? 2 : 1;
        if (_tabController == null || _tabController!.length != tabCount) {
          _tabController = TabController(length: tabCount, vsync: this);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF0F4F8),
          appBar: AppBar(
            backgroundColor: primaryBlue,
            elevation: 0,
            title: const Text("Lost & Found",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: isAdmin
                ? TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: "Public Feed", icon: Icon(Icons.grid_view)),
                Tab(text: "Approval Queue", icon: Icon(Icons.admin_panel_settings)),
              ],
            )
                : null,
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: primaryBlue,
            onPressed: () => _showAddDialog(userName),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Report Found", style: TextStyle(color: Colors.white)),
          ),
          body: Column(
            children: [
              _buildSearchBar(),
              Expanded(
                child: isAdmin
                    ? TabBarView(
                  controller: _tabController,
                  children: [
                    _buildItemsList(collection: 'lost_found_items', isAdmin: true),
                    _buildItemsList(collection: 'found_submissions', isApprovalTab: true),
                  ],
                )
                    : _buildItemsList(collection: 'lost_found_items', isAdmin: false),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: primaryBlue,
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() {}),
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: "Search items...",
          prefixIcon: const Icon(Icons.search, color: primaryBlue),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildItemsList({required String collection, bool isApprovalTab = false, bool isAdmin = false}) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection(collection).orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs.where((doc) {
          final title = doc['title'].toString().toLowerCase();
          return title.contains(_searchController.text.toLowerCase());
        }).toList();

        if (docs.isEmpty) {
          return Center(child: Text(isApprovalTab ? "No pending approvals" : "No items listed yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final String docId = docs[index].id;
            final String status = data['status'] ?? 'Available';

            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statusBadge(isApprovalTab ? "PENDING REVIEW" : status),
                        Text(data['date'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(data['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(data['desc'], style: TextStyle(color: Colors.grey.shade800)),
                    const Divider(height: 30),

                    // CASE 1: Approval Queue (Only Admins see this)
                    if (isApprovalTab) ...[
                      Text("Found by: ${data['finderName']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () => _approveItem(docId, data),
                              child: const Text("Approve Post", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.red),
                            onPressed: () => _firestore.collection('found_submissions').doc(docId).delete(),
                          )
                        ],
                      )
                    ]
                    // CASE 2: Public Feed
                    else ...[
                      // Admin controls for claimed items
                      if (isAdmin && status == 'Claimed') ...[
                        _infoBox("Claimed by: ${data['claimantName']}"),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                            icon: const Icon(Icons.verified, color: Colors.white),
                            label: const Text("Verify Handover & Delete", style: TextStyle(color: Colors.white)),
                            onPressed: () => _firestore.collection('lost_found_items').doc(docId).delete(),
                          ),
                        )
                      ]
                      // Student controls to claim
                      else if (!isAdmin && status == 'Available') ...[
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _claimItem(docId),
                            child: const Text("Claim this Item"),
                          ),
                        )
                      ]
                      // Verification message for students
                      else if (status == 'Claimed') ...[
                          const Center(child: Text("Wait for Admin Handover...", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.orange))),
                        ]
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- DATABASE LOGIC ---

  Future<void> _approveItem(String id, Map<String, dynamic> data) async {
    await _firestore.collection('lost_found_items').add({
      ...data,
      'status': 'Available',
      'timestamp': FieldValue.serverTimestamp(), // Update to current time
    });
    await _firestore.collection('found_submissions').doc(id).delete();
  }

  Future<void> _claimItem(String id) async {
    final user = _auth.currentUser;
    await _firestore.collection('lost_found_items').doc(id).update({
      'status': 'Claimed',
      'claimantId': user?.uid,
      'claimantName': user?.displayName ?? 'Anonymous Student',
    });
  }

  void _showAddDialog(String userName) {
    final t1 = TextEditingController();
    final t2 = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Report Found Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: t1, decoration: const InputDecoration(labelText: "What did you find?")),
            const SizedBox(height: 8),
            TextField(controller: t2, decoration: const InputDecoration(labelText: "Details / Location")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              if (t1.text.trim().isEmpty) return;
              await _firestore.collection('found_submissions').add({
                'title': t1.text,
                'desc': t2.text,
                'finderName': userName,
                'status': 'Pending',
                'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                'timestamp': FieldValue.serverTimestamp(),
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Submitted! Waiting for Admin Approval.")));
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }

  // --- SMALL UI HELPERS ---

  Widget _statusBadge(String status) {
    Color color = (status == 'Available') ? Colors.green : Colors.orange;
    if (status == 'PENDING REVIEW') color = Colors.blue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _infoBox(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
    );
  }
}