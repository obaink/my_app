// lib/dashboards/orphans_sponsored_page.dart
import 'package:flutter/material.dart';

class OrphansSponsoredPage extends StatelessWidget {
  const OrphansSponsoredPage({super.key});

  // Dummy data for sponsored orphans
  final List<Map<String, String>> sponsoredOrphans = const [
    {
      'name': 'Amina Nwosu',
      'age': '8',
      'country': 'Cameroon',
      'status': 'Active'
    },
    {
      'name': 'Samuel Taye',
      'age': '10',
      'country': 'Nigeria',
      'status': 'Active'
    },
    {
      'name': 'Fatima Idris',
      'age': '7',
      'country': 'Cameroon',
      'status': 'Active'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orphans Sponsored'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: sponsoredOrphans.length,
        itemBuilder: (context, index) {
          final orphan = sponsoredOrphans[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blueAccent,
                child: Text(orphan['name']![0]),
              ),
              title: Text(orphan['name'] ?? ''),
              subtitle: Text(
                  'Age: ${orphan['age']} • Country: ${orphan['country']}'),
              trailing: Text(
                orphan['status'] ?? '',
                style: const TextStyle(
                    color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // TODO: Navigate to orphan details page if needed
              },
            ),
          );
        },
      ),
    );
  }
}