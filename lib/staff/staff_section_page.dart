// lib/staff/staff_section_page.dart
import 'package:flutter/material.dart';
import 'staff_page.dart';
import 'staff_profile_page.dart';
import 'staff_attendance_page.dart';
import 'staff_roles_page.dart';

class StaffSectionPage extends StatelessWidget {
  const StaffSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // four tabs
      child: Column(
        children: [
          // TAB BAR
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: Color(0xFF4361EE),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF4361EE),
              isScrollable: true, // scrollable on small screens
              tabs: [
                Tab(text: "Staff List"),
                Tab(text: "Profiles"),
                Tab(text: "Attendance"),
                Tab(text: "Roles"),
              ],
            ),
          ),

          // TAB VIEWS
          Expanded(
            child: TabBarView(
              children: [
                // Wrap each tab in SingleChildScrollView to avoid overflow
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: StaffPage(),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: StaffProfilePage(),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: StaffAttendancePage(),
                  ),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: StaffRolesPage(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}