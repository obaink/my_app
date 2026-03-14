// lib/dashboards/staff_dashboard.dart
import 'package:flutter/material.dart';
import '../children/children_page.dart';
import '../donation/donation_page.dart';
import '../adoptions/adoptions_page.dart';
import '../tasks/tasks_page.dart';
import 'dashboard_overview_page.dart';

/// --------------------
/// Staff Dashboard
/// --------------------
class StaffDashboardPage extends StatefulWidget {
  const StaffDashboardPage({super.key});

  @override
  State<StaffDashboardPage> createState() => _StaffDashboardPageState();
}

class _StaffDashboardPageState extends State<StaffDashboardPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> navItems = [
    {"icon": Icons.dashboard, "label": "Dashboard"},
    {"icon": Icons.child_care, "label": "Children"},
    {"icon": Icons.task, "label": "Tasks"},
    {"icon": Icons.favorite, "label": "Donors"},
    {"icon": Icons.thumb_up, "label": "Adoptions"},
  ];

  // Pages to display for each tab
  late final List<Widget> pages = [
    const DashboardOverview(),
    const ChildrenPage(key: ValueKey("children")),
    const TasksPage(),
    const DonationPage(key: ValueKey("donors")), // Donors page
    const AdoptionPage(key: ValueKey("adoptions")), // Adoptions page
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
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      key: ValueKey(selectedIndex),
                      padding: const EdgeInsets.all(24),
                      color: Colors.transparent,
                      child: pages[selectedIndex],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------
  /// Sidebar
  /// --------------------
  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1C2331), Color(0xFF2A2F48)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "Staff Panel",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(navItems.length, (i) {
                  final item = navItems[i];
                  final bool isSelected = selectedIndex == i;

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin:
                          const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        onTap: () {
                          setState(() => selectedIndex = i);
                        },
                        leading: Icon(item["icon"],
                            color: Colors.white.withOpacity(isSelected ? 1 : 0.7)),
                        title: Text(
                          item["label"],
                          style: TextStyle(
                            color: Colors.white.withOpacity(isSelected ? 1 : 0.7),
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------
  /// Header
  /// --------------------
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
          Text(
            navItems[selectedIndex]["label"],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Text("Staff Member",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text("staff@carebridge.org",
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
              const SizedBox(width: 15),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF1C2331),
                child: Text(
                  "S",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}