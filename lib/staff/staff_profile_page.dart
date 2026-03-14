// lib/staff/staff_profile_page.dart
import 'package:flutter/material.dart';

class StaffProfilePage extends StatelessWidget {
  const StaffProfilePage({super.key});

  // Sample staff list
  final List<Map<String, String>> staffList = const [
    {
      "name": "Mary Johnson",
      "role": "Caregiver",
      "phone": "670000000",
      "status": "Active",
    },
    {
      "name": "Peter King",
      "role": "Teacher",
      "phone": "651000000",
      "status": "Active",
    },
    {
      "name": "Sarah Paul",
      "role": "Nurse",
      "phone": "680000000",
      "status": "On Leave",
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

            /// PAGE TITLE
            const Text(
              "Staff Profiles",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            /// STAFF CARDS
            Column(
              children: staffList
                  .map((staff) => _staffCard(staff))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// STAFF CARD
  Widget _staffCard(Map<String, String> staff) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.blue.shade400,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff["name"] ?? "",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      staff["role"] ?? "",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const Spacer(),

                Text(
                  staff["status"] ?? "",
                  style: TextStyle(
                    color: staff["status"] == "Active"
                        ? Colors.green
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// CONTACT INFO
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Phone: ${staff["phone"]}"),
                Text(
                  "Email: ${staff["name"]?.toLowerCase().replaceAll(" ", ".")}@carebridge.org",
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// ACTION BUTTONS
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                ),

                const SizedBox(width: 12),

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}