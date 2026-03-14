// lib/dashboards/donor_dashboard.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../donation/donation_page.dart';
import '../events/events_page.dart';
import '../projects/ongoing_projects.dart';
import '../messages/donor_messages_page.dart';
import '../settings/donor_settings_page.dart';
import '../orphans/orphans_sponsored_page.dart';
import '../providers/donor_provider.dart';

/// ------------------- DONOR DASHBOARD -------------------
class DonorDashboardPage extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const DonorDashboardPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<DonorDashboardPage> createState() => _DonorDashboardPageState();
}

class _DonorDashboardPageState extends State<DonorDashboardPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;

  final List<_NavItem> navItems = const [
    _NavItem(Icons.dashboard, "Dashboard"),
    _NavItem(Icons.favorite, "My Donations"),
    _NavItem(Icons.child_care, "Orphans Sponsored"),
    _NavItem(Icons.volunteer_activism, "Ongoing Projects"),
    _NavItem(Icons.event, "Events"),
    _NavItem(Icons.message, "Messages"),
    _NavItem(Icons.settings, "Settings"),
  ];

  late final List<Widget> pages;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    pages = [
      const DonorDashboardContent(),
      const DonationPage(),
      const OrphansSponsoredPage(),
      const OngoingProjectsPage(),
      const EventsPage(),
      const DonorMessagesPage(),
      DonorSettingsPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onNavTap(int index) {
    setState(() => selectedIndex = index);
  }

  Widget sidebar(bool isWide) {
    return Container(
      width: 260,
      color: const Color(0xFF1C2331),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4361EE), Color(0xFF6A7FF8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.favorite, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 10),
                if (isWide)
                  const Text(
                    "CareBridge",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: navItems.length,
              itemBuilder: (context, i) {
                final item = navItems[i];
                final selected = selectedIndex == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF4361EE) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: selected ? Colors.white : const Color(0xFFB0BEC5),
                      size: 20,
                    ),
                    title: isWide
                        ? Text(
                            item.label,
                            style: TextStyle(
                              color: selected ? Colors.white : const Color(0xFFECEFF1),
                              fontWeight:
                                  selected ? FontWeight.w500 : FontWeight.normal,
                            ),
                          )
                        : null,
                    dense: true,
                    onTap: () => onNavTap(i),
                  ),
                );
              },
            ),
          ),
          if (isWide)
            const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isWide = width > 900;

    return Scaffold(
      drawer: isWide ? null : Drawer(child: sidebar(isWide)),
      body: Row(
        children: [
          if (isWide) sidebar(isWide),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: pages[selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------- DONOR DASHBOARD CONTENT -------------------
class DonorDashboardContent extends StatelessWidget {
  const DonorDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> donations = const [
      {"date": "2026-03-01", "child": "John Doe", "amount": "\$200", "status": "Completed"},
      {"date": "2026-02-20", "child": "Jane Smith", "amount": "\$150", "status": "Completed"},
      {"date": "2026-02-05", "child": "Orphanage Project A", "amount": "\$300", "status": "Pending"},
    ];

    final List<Map<String, Object>> sponsoredChildren = const [
      {"name": "Alice", "age": 8},
      {"name": "David", "age": 10},
      {"name": "Fatima", "age": 7},
    ];

    Widget overviewCard(String title, String value, IconData icon, Color startColor, Color endColor) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [startColor, endColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: endColor.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      );
    }

    Widget donationRow(String date, String child, String amount, String status) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
          ),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(date)),
              Expanded(flex: 3, child: Text(child)),
              Expanded(flex: 2, child: Text(amount)),
              Expanded(
                  flex: 2,
                  child: Text(status,
                      style: TextStyle(
                          color: status == "Completed" ? Colors.green : Colors.orange))),
            ],
          ),
        ),
      );
    }

    Widget sponsoredChildCard(String name, int age) {
      return TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Container(
          width: 150,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 4)],
          ),
          child: Column(
            children: [
              const CircleAvatar(radius: 35, backgroundColor: Colors.deepPurple),
              const SizedBox(height: 8),
              Text(name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Age $age", style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final bool isWide = width > 900;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 28 : 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Donor Dashboard",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text("Track your donations and impact",
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: isWide ? 4 : 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              overviewCard("Total Donations", "\$5,400", Icons.attach_money, Colors.purpleAccent, Colors.deepPurple),
              overviewCard("Monthly Donations", "\$400", Icons.calendar_today, Colors.orangeAccent, Colors.deepOrange),
              overviewCard("Children Sponsored", "${sponsoredChildren.length}", Icons.child_care, Colors.pinkAccent, Colors.red),
              overviewCard("Upcoming Pledges", "2", Icons.schedule, Colors.tealAccent, Colors.teal),
            ],
          ),
          const SizedBox(height: 25),
          const Text("Donation History",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Column(
            children: donations
                .map((d) => donationRow(d["date"]!, d["child"]!, d["amount"]!, d["status"]!))
                .toList(),
          ),
          const SizedBox(height: 25),
          const Text("Children Sponsored",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: sponsoredChildren
                  .map((c) => sponsoredChildCard(c["name"] as String, c["age"] as int))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// ------------------- NAV ITEM -------------------
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}