// lib/dashboards/dashboard_overview_page.dart
import 'package:flutter/material.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome Back", style: TextStyle(fontSize: 16, color: Colors.grey)),
          const Text("Staff Dashboard", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 25),
          
          // Top 4 Colored Cards
          Row(
            children: [
              _buildStatCard("Children", "3", Colors.deepPurple, Icons.child_care),
              _buildStatCard("Tasks", "3", Colors.green, Icons.task),
              _buildStatCard("Events", "2", Colors.orange, Icons.calendar_today),
              _buildStatCard("Adoptions", "2", Colors.redAccent, Icons.favorite),
            ],
          ),
          const SizedBox(height: 30),
          
          // Bottom 3 Sections
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection("Recent Children", [
                _buildInfoItem("Aisha K.", "Age 6", Icons.child_care),
                _buildInfoItem("Samuel R.", "Age 8", Icons.child_care),
                _buildInfoItem("Maria G.", "Age 7", Icons.child_care),
              ]),
              const SizedBox(width: 20),
              _buildSection("Staff Tasks", [
                _buildInfoItem("Daily Handover", "Assigned: Nurse Amy", Icons.check_circle_outline, color: Colors.green),
                _buildInfoItem("Meal Preparation", "Assigned: Cook Sam", Icons.check_circle_outline, color: Colors.green),
                _buildInfoItem("Attendance Check", "Assigned: Coordinator Ben", Icons.check_circle_outline, color: Colors.green),
              ]),
              const SizedBox(width: 20),
              _buildSection("Upcoming Events", [
                _buildInfoItem("Health Check", "15 Mar", Icons.calendar_today),
                _buildInfoItem("Birthday Party", "17 Mar", Icons.calendar_today),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(count, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                Icon(icon, color: Colors.white.withOpacity(0.4), size: 40),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String subtitle, IconData icon, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: (color ?? Colors.blue).withOpacity(0.1), child: Icon(icon, color: color ?? Colors.blue)),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }
}