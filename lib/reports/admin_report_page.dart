// lib/reports/admin_report_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminReportPage extends StatefulWidget {
  const AdminReportPage({super.key});

  @override
  State<AdminReportPage> createState() => _AdminReportPageState();
}

class _AdminReportPageState extends State<AdminReportPage> {
  DateTimeRange? selectedDateRange;

  // Dummy data for KPIs
  final Map<String, int> kpis = {
    "Total Children": 120,
    "New Adoptions": 15,
    "Donations Received": 5400,
    "Pending Applications": 8,
  };

  // Dummy data for tables
  final List<Map<String, String>> childrenData = [
    {"Name": "John Doe", "Age": "8", "Status": "Active"},
    {"Name": "Mary Smith", "Age": "5", "Status": "Pending"},
    {"Name": "Ali Kouate", "Age": "10", "Status": "Active"},
  ];

  final List<Map<String, String>> donationsData = [
    {"Donor": "Alice Johnson", "Amount": "\$100", "Date": "2026-03-01"},
    {"Donor": "Bob Martin", "Amount": "\$250", "Date": "2026-03-05"},
  ];

  // Date range picker
  Future<void> pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
      initialDateRange: selectedDateRange ??
          DateTimeRange(start: now.subtract(const Duration(days: 30)), end: now),
    );
    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateRangeText = selectedDateRange == null
        ? "Select Date Range"
        : "${DateFormat.yMMMd().format(selectedDateRange!.start)} - ${DateFormat.yMMMd().format(selectedDateRange!.end)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Reports"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Implement export PDF/Excel
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date range selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateRangeText,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ElevatedButton.icon(
                  onPressed: pickDateRange,
                  icon: const Icon(Icons.date_range),
                  label: const Text("Filter"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // KPI cards
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: kpis.entries.map((entry) {
                return SizedBox(
                  width: 160,
                  child: Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text(
                            entry.value.toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Placeholder for charts
            Card(
              child: Container(
                height: 200,
                alignment: Alignment.center,
                child: const Text("Chart Placeholder (Donations / Adoptions Trend)"),
              ),
            ),
            const SizedBox(height: 30),

            // Children Table
            const Text("Children Records",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Age")),
                DataColumn(label: Text("Status")),
              ],
              rows: childrenData.map((child) {
                return DataRow(cells: [
                  DataCell(Text(child["Name"]!)),
                  DataCell(Text(child["Age"]!)),
                  DataCell(Text(child["Status"]!)),
                ]);
              }).toList(),
            ),
            const SizedBox(height: 30),

            // Donations Table
            const Text("Donations Records",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DataTable(
              columns: const [
                DataColumn(label: Text("Donor")),
                DataColumn(label: Text("Amount")),
                DataColumn(label: Text("Date")),
              ],
              rows: donationsData.map((donation) {
                return DataRow(cells: [
                  DataCell(Text(donation["Donor"]!)),
                  DataCell(Text(donation["Amount"]!)),
                  DataCell(Text(donation["Date"]!)),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}