import 'package:flutter/material.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6347EB), Color(0xFF8A72F1)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: const [
                Icon(Icons.grid_view, color: Colors.white, size: 45),
                SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Administrator",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Orphanage Management Dashboard",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          /// STAT CARDS
          Row(
            children: [
              _statCard("Children", "125", const Color(0xFF3F6ED3), Icons.face),
              const SizedBox(width: 20),
              _statCard("Staff", "18", const Color(0xFF3CB371), Icons.people),
              const SizedBox(width: 20),
              _statCard("Donors", "42", const Color(0xFFF14B5D), Icons.favorite),
              const SizedBox(width: 20),
              _statCard(
                  "Adoptions", "3", const Color(0xFFFFA500), Icons.accessibility),
            ],
          ),

          const SizedBox(height: 40),

          /// QUICK ACTIONS
          const Text(
            "Quick Actions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          Wrap(
            spacing: 15,
            runSpacing: 10,
            children: [
              _actionBtn("Add Child", const Color(0xFF3F6ED3), Icons.face),
              _actionBtn("Add Staff", const Color(0xFF3CB371), Icons.people),
              _actionBtn("Add Donor", const Color(0xFFF14B5D), Icons.favorite),
              _actionBtn("Create Event", const Color(0xFFFFA500), Icons.event),
              _actionBtn("Add Project", const Color(0xFF00CED1), Icons.work),
            ],
          ),

          const SizedBox(height: 40),

          /// RECENT DONATIONS PANEL
          const Text(
            "Recent Donations",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          Container(
            width: 450,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Donor",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Text(
                      "Amount",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Text(
                      "Date",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                  ],
                ),

                const Divider(height: 30),

                /// Example rows
                _donationRow("John Smith", "\$200", "Today"),
                _donationRow("Maria Lopez", "\$150", "Yesterday"),
                _donationRow("David Kim", "\$500", "2 days ago"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// STAT CARD
  Widget _statCard(String title, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              count,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(icon, color: Colors.white, size: 20),
            )
          ],
        ),
      ),
    );
  }

  /// ACTION BUTTON
  Widget _actionBtn(String label, Color color, IconData icon) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  /// DONATION ROW
  Widget _donationRow(String donor, String amount, String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(donor),
          Text(amount),
          Text(date),
        ],
      ),
    );
  }
}