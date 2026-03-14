import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Ensure this is imported
import 'package:intl/intl.dart';
import '../models/adoption_model.dart'; 

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({super.key});

  @override
  State<AdoptionPage> createState() => _AdoptionPageState();
}

class _AdoptionPageState extends State<AdoptionPage> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    // FIX: Using standard Provider to access the model defined in main.dart
    final model = Provider.of<AdoptionModel>(context);

    final apps = model.applications
        .where((a) =>
            a.childName.toLowerCase().contains(search.toLowerCase()) ||
            a.applicantName.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          const Text(
            "Adoption Management",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 25),

          // Search & Info Bar
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Color(0xFF6347EB)),
                      hintText: "Search child or applicant...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onChanged: (v) => setState(() => search = v),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              _miniStat("Pending", model.pending.toString(), Colors.orange),
              const SizedBox(width: 10),
              _miniStat("Approved", model.approved.toString(), Colors.green),
            ],
          ),
          
          const SizedBox(height: 30),

          // Table Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(flex: 3, child: Text("CHILD & APPLICANT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                Expanded(flex: 2, child: Text("DATE APPLIED", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                Expanded(flex: 1, child: Text("STATUS", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
                SizedBox(width: 50), 
              ],
            ),
          ),
          const Divider(),

          // Applications List
          if (apps.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 50),
              child: Center(child: Text("No applications found", style: TextStyle(color: Colors.grey))),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: apps.length,
              itemBuilder: (_, index) => _applicationTile(apps[index], model),
            ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _applicationTile(AdoptionApplication app, AdoptionModel model) {
    final date = DateFormat("dd MMM yyyy").format(app.appliedOn);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(app.childName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("By: ${app.applicantName}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(date, style: const TextStyle(color: Colors.black87)),
            ),
            Expanded(
              flex: 1,
              child: _statusBadge(app.status),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => _showApproveDialog(app, model),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(AdoptionStatus status) {
    Color color;
    switch (status) {
      case AdoptionStatus.pending: color = Colors.orange; break;
      case AdoptionStatus.approved: color = Colors.green; break;
      case AdoptionStatus.rejected: color = Colors.red; break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          statusLabel(status),
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showApproveDialog(AdoptionApplication app, AdoptionModel model) {
    if (app.status != AdoptionStatus.pending) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Finalize Adoption"),
        content: Text("Do you wish to approve the adoption application for ${app.childName}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              model.approve(app.id);
              Navigator.pop(context);
              // notifyListeners in the model will handle the rebuild
            },
            child: const Text("Approve"),
          )
        ],
      ),
    );
  }
}