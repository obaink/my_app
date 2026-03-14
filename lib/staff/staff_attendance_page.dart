// lib/staff/staff_attendance_page.dart
import 'package:flutter/material.dart';

class StaffAttendancePage extends StatefulWidget {
  const StaffAttendancePage({super.key});

  @override
  State<StaffAttendancePage> createState() => _StaffAttendancePageState();
}

class _StaffAttendancePageState extends State<StaffAttendancePage> {
  final List<Map<String, String>> attendanceList = [
    {"name": "Mary Johnson", "date": "12 Mar 2026", "status": "Present"},
    {"name": "Peter King", "date": "12 Mar 2026", "status": "Absent"},
    {"name": "Sarah Paul", "date": "12 Mar 2026", "status": "On Leave"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE
            const Text(
              "Staff Attendance",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// MARK ATTENDANCE BUTTON
            ElevatedButton.icon(
              onPressed: _showMarkAttendanceDialog,
              icon: const Icon(Icons.add),
              label: const Text("Mark Attendance"),
            ),

            const SizedBox(height: 20),

            /// TABLE CONTAINER
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.grey.shade300,
                  )
                ],
              ),
              child: Column(
                children: [

                  /// TABLE HEADER
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade200,
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Staff Name",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Status",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ATTENDANCE ROWS
                  Column(
                    children: attendanceList
                        .map((record) => _attendanceRow(record))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ATTENDANCE ROW
  Widget _attendanceRow(Map<String, String> record) {
    Color statusColor;

    switch (record["status"]) {
      case "Absent":
        statusColor = Colors.red;
        break;
      case "On Leave":
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(record["name"]!)),
          Expanded(child: Text(record["date"]!)),
          Expanded(
            child: Text(
              record["status"]!,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// MARK ATTENDANCE DIALOG
  void _showMarkAttendanceDialog() {
    String selectedStatus = "Present";
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Mark Attendance"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// STAFF NAME
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Staff Name",
              ),
            ),

            const SizedBox(height: 10),

            /// STATUS
            DropdownButtonFormField<String>(
              value: selectedStatus,
              items: const [
                DropdownMenuItem(
                  value: "Present",
                  child: Text("Present"),
                ),
                DropdownMenuItem(
                  value: "Absent",
                  child: Text("Absent"),
                ),
                DropdownMenuItem(
                  value: "On Leave",
                  child: Text("On Leave"),
                ),
              ],
              onChanged: (value) {
                selectedStatus = value!;
              },
              decoration: const InputDecoration(
                labelText: "Attendance Status",
              ),
            ),
          ],
        ),

        actions: [

          /// CANCEL
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          /// SAVE
          ElevatedButton(
            onPressed: () {
              setState(() {
                attendanceList.add({
                  "name": nameController.text,
                  "date": "Today",
                  "status": selectedStatus,
                });
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}