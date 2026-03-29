import 'package:flutter/material.dart';

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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
}