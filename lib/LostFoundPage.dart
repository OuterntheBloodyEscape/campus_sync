import 'package:campus_sync/others/custom_drawer.dart';
import 'package:campus_sync/students/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Theme Constants
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color deepBlue = Color(0xFF0D47A1);
  static const Color lightBlue = Color(0xFF42A5F5);

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Please login again.")));
    }

    // ─── THE "BULLETPROOF" ROLE CHECK ────────────────────────────
    return StreamBuilder<DocumentSnapshot>(
      stream: _firestore.collection('users').doc(user.uid).snapshots(),
      builder: (context, snapshot) {
        // 1. Show loading while fetching role
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 2. Extract role precisely
        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final String role = data?['role']?.toString().trim() ?? 'students';
        final bool isAdmin = (role == 'admin');

        // 3. Build the UI with the correct number of tabs (1 for student, 2 for admin)
        return DefaultTabController(
          length: isAdmin ? 2 : 1,
          child: Scaffold(
            backgroundColor: const Color(0xFFF0F7FF),
            drawer: CustomDrawer(pageNo: 4),
            appBar: AppBar(
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.white),
              elevation: 0,
              title: const Text("Lost & Found",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [deepBlue, primaryBlue, lightBlue]),
                ),
              ),
              // ─── THIS IS THE APPROVAL QUEUE LOCATION ───
              bottom: isAdmin
                  ? const TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 4,
                tabs: [
                  Tab(text: "PUBLIC FEED", icon: Icon(Icons.public)),
                  Tab(text: "APPROVAL QUEUE", icon: Icon(Icons.admin_panel_settings)),
                ],
              )
                  : null,
              actions: [
                if (isAdmin) _adminBadge(),
                _profileMenu(context),
              ],
            ),
            floatingActionButton: _floatingButton(data?['name'] ?? 'User'),
            body: Column(
              children: [
                _searchBar(),
                Expanded(
                  child: isAdmin
                      ? TabBarView(
                    children: [
                      _itemsList(collection: 'lost_found_items', isAdmin: true),
                      _itemsList(collection: 'found_submissions', isApprovalTab: true),
                    ],
                  )
                      : _itemsList(collection: 'lost_found_items', isAdmin: false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── THE LIST LOGIC (Handles Both Tabs) ────────────────────────
  Widget _itemsList({required String collection, bool isApprovalTab = false, bool isAdmin = false}) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection(collection).orderBy('timestamp', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final docs = snapshot.data!.docs.where((doc) {
          final title = doc['title'].toString().toLowerCase();
          return title.contains(searchController.text.toLowerCase());
        }).toList();

        if (docs.isEmpty) {
          return Center(child: Text(isApprovalTab ? "Queue is empty!" : "No items found."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final item = docs[index].data() as Map<String, dynamic>;
            final String docId = docs[index].id;
            final String status = item['status'] ?? 'Available';

            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _badge(isApprovalTab ? "PENDING REVIEW" : status),
                        Text(item['date'] ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(item['title'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(item['desc'], style: TextStyle(color: Colors.grey.shade700)),
                    const Divider(height: 30),

                    // --- ADMIN ACTIONS (IN APPROVAL QUEUE) ---
                    if (isApprovalTab)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                              onPressed: () => _handleApprove(docId, item),
                              child: const Text("Approve & Publish", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _firestore.collection('found_submissions').doc(docId).delete(),
                          )
                        ],
                      )

                    // --- PUBLIC FEED ACTIONS ---
                    else ...[
                      if (isAdmin && status == 'Claimed')
                        Column(
                          children: [
                            Text("Claimed by: ${item['claimantName']}", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                                onPressed: () => _firestore.collection('lost_found_items').doc(docId).delete(),
                                child: const Text("Verify Handover & Delete", style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        )
                      else if (!isAdmin && status == 'Available')
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _handleClaim(docId),
                            child: const Text("This is My Item (Claim)"),
                          ),
                        )
                    ]
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ─── DATABASE HELPERS ──────────────────────────────────────────
  Future<void> _handleApprove(String id, Map<String, dynamic> data) async {
    await _firestore.collection('lost_found_items').add({
      ...data,
      'status': 'Available',
      'timestamp': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('found_submissions').doc(id).delete();
  }

  Future<void> _handleClaim(String id) async {
    final user = _auth.currentUser;
    await _firestore.collection('lost_found_items').doc(id).update({
      'status': 'Claimed',
      'claimantId': user?.uid,
      'claimantName': user?.displayName ?? 'Anonymous Student',
    });
  }

  // ─── UI COMPONENTS (DIALOGS & BUTTONS) ─────────────────────────
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
            TextField(controller: t1, decoration: const InputDecoration(labelText: "Item Name")),
            TextField(controller: t2, decoration: const InputDecoration(labelText: "Location/Details")),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (t1.text.isEmpty) return;
              await _firestore.collection('found_submissions').add({
                'title': t1.text,
                'desc': t2.text,
                'finderName': userName,
                'status': 'Pending',
                'date': "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                'timestamp': FieldValue.serverTimestamp(),
              });
              Navigator.pop(ctx);
            },
            child: const Text("Submit for Review"),
          )
        ],
      ),
    );
  }

  Widget _searchBar() => Padding(
    padding: const EdgeInsets.all(15),
    child: TextField(
      controller: searchController,
      onChanged: (v) => setState(() {}),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "Search items...",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    ),
  );

  Widget _adminBadge() => Container(
    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10)),
    child: const Center(child: Text("ADMIN", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
  );

  Widget _profileMenu(BuildContext context) => PopupMenuButton(
    icon: const Icon(Icons.more_vert, color: Colors.white),
    onSelected: (val) async {
      if (val == 'p') Navigator.push(context, MaterialPageRoute(builder: (_) => StudentProfile()));
      else { await _auth.signOut(); Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WelcomeScreen())); }
    },
    itemBuilder: (ctx) => [
      const PopupMenuItem(value: 'p', child: Text("Profile")),
      const PopupMenuItem(value: 's', child: Text("Sign Out")),
    ],
  );

  Widget _floatingButton(String name) => FloatingActionButton.extended(
    backgroundColor: primaryBlue,
    onPressed: () => _showAddDialog(name),
    label: const Text("Report Found", style: TextStyle(color: Colors.white)),
    icon: const Icon(Icons.add, color: Colors.white),
  );

  Widget _badge(String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
    child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryBlue)),
  );
}