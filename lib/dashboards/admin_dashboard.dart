// lib/dashboards/admin_dashboard.dart
import 'package:flutter/material.dart';
import '../children/children_page.dart';
import '../staff/staff_section_page.dart';
import '../donation/donation_page.dart';
import '../events/events_page.dart';
import '../projects/ongoing_projects.dart';
import '../adoptions/adoptions_page.dart';
import '../inventory/inventory_page.dart';
import '../reports/admin_report_page.dart';
import '../settings/admin_settings_page.dart';
import 'dashboard_content.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  /// Dashboard pages
  late final List<Widget> pages = [
    const DashboardContent(key: ValueKey("dashboard")),
    const ChildrenPage(key: ValueKey("children")),
    const StaffSectionPage(key: ValueKey("staff")),
    const DonationPage(key: ValueKey("donation")),
    const AdoptionPage(key: ValueKey("adoption")),
    const InventoryPage(key: ValueKey("inventory")),
    const EventsPage(key: ValueKey("events")),
    const OngoingProjectsPage(key: ValueKey("projects")),
    const AdminReportPage(key: ValueKey("reports")),
    const AdminSettingsPage(key: ValueKey("settings")),
  ];

  /// Sidebar navigation items
  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.grid_view, "label": "Dashboard"},
    {"icon": Icons.face, "label": "Children"},
    {"icon": Icons.people, "label": "Staff"},
    {"icon": Icons.favorite, "label": "Donors"},
    {"icon": Icons.accessibility, "label": "Adoptions"},
    {"icon": Icons.inventory, "label": "Inventory"},
    {"icon": Icons.event, "label": "Events"},
    {"icon": Icons.folder_special, "label": "Projects"},
    {"icon": Icons.bar_chart, "label": "Reports"},
    {"icon": Icons.settings, "label": "Settings"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3F8),
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: pages[selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// =========================
  /// Sidebar
  /// =========================
  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: const Color(0xFF6347EB),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "CareBridge",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(navItems.length, (i) {
                  final item = navItems[i];
                  return _navItem(i, item["icon"] as IconData, item["label"] as String);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final bool isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () => setState(() => selectedIndex = index),
        leading: Icon(icon, color: Colors.white.withOpacity(isSelected ? 1 : 0.7)),
        title: Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(isSelected ? 1 : 0.7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// =========================
  /// Header with Logout
  /// =========================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Admin Panel",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          /// Admin info and logout
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text(
                    "Administrator",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    "admin@carebridge.org",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  Text(
                    "Password: admin@",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF6347EB),
                child: Text(
                  "A",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 15),

              /// Logout Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // Navigate back to login by popping all routes
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}