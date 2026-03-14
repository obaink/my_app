// lib/staff/staff_page.dart
import 'package:flutter/material.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {

  final List<Map<String, String>> staffList = [
    {
      "name": "Mary Johnson",
      "role": "Caregiver",
      "phone": "670000000",
      "status": "Active"
    },
    {
      "name": "Peter King",
      "role": "Teacher",
      "phone": "651000000",
      "status": "Active"
    },
    {
      "name": "Sarah Paul",
      "role": "Nurse",
      "phone": "680000000",
      "status": "On Leave"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Staff Management",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text("Add Staff"),
                )
              ],
            ),

            const SizedBox(height: 20),

            /// SEARCH
            TextField(
              decoration: InputDecoration(
                hintText: "Search staff...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// STATS
            Row(
              children: [
                _statCard("Total Staff", staffList.length.toString(), Icons.people),
                const SizedBox(width: 20),
                _statCard(
                  "Active",
                  staffList.where((s) => s["status"] == "Active").length.toString(),
                  Icons.check_circle,
                ),
                const SizedBox(width: 20),
                _statCard(
                  "On Leave",
                  staffList.where((s) => s["status"] == "On Leave").length.toString(),
                  Icons.access_time,
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Staff List",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            /// TABLE
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 5,
                    color: Colors.grey.shade300,
                  )
                ],
              ),
              child: Column(
                children: [

                  /// HEADER
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade200,
                    child: Row(
                      children: const [
                        Expanded(flex: 2, child: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text("Role", style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text("Phone", style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
                        Expanded(flex: 2, child: Text("Actions", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),

                  /// ROWS
                  ...staffList.map((staff) => _staffRow(staff)).toList(),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  /// STAFF ROW
  Widget _staffRow(Map<String, String> staff) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(staff["name"]!)),
          Expanded(flex: 2, child: Text(staff["role"]!)),
          Expanded(flex: 2, child: Text(staff["phone"]!)),
          Expanded(
            flex: 2,
            child: Text(
              staff["status"]!,
              style: TextStyle(
                color: staff["status"] == "Active"
                    ? Colors.green
                    : Colors.orange,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, color: Colors.blue),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.orange),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// STAT CARD
  Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(title)
              ],
            )
          ],
        ),
      ),
    );
  }
}