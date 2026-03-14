// lib/dashboards/children_page.dart
import 'package:flutter/material.dart';

class Child {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String room;
  final String healthStatus;
  final bool isSponsored;

  Child({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.room,
    required this.healthStatus,
    required this.isSponsored,
  });
}

class ChildrenPage extends StatefulWidget {
  const ChildrenPage({super.key});

  @override
  State<ChildrenPage> createState() => _ChildrenPageState();
}

class _ChildrenPageState extends State<ChildrenPage> {
  final List<Child> _children = [
    Child(
        id: '1',
        name: 'Nasara Rayuwa',
        age: 7,
        gender: 'Male',
        room: 'A1',
        healthStatus: 'Healthy',
        isSponsored: true),
    Child(
        id: '2',
        name: 'Amara Kuate',
        age: 5,
        gender: 'Female',
        room: 'B2',
        healthStatus: 'Special Needs',
        isSponsored: false),
    // Add more mock children
  ];

  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredChildren = _children
        .where((child) =>
            child.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Children Management",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          // Search bar
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search by name',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Add button
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _showChildForm(context),
              icon: const Icon(Icons.add),
              label: const Text("Add Child"),
            ),
          ),
          const SizedBox(height: 16),

          // Children list
          filteredChildren.isEmpty
              ? const Center(child: Text('No children found'))
              : Column(
                  children: filteredChildren
                      .map((child) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text(child.name[0]),
                              ),
                              title: Text(child.name),
                              subtitle: Text(
                                  'Age: ${child.age}, Gender: ${child.gender}, Room: ${child.room}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility),
                                    onPressed: () =>
                                        _showChildDetails(context, child),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _showChildForm(context, child: child),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteChild(child),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }

  void _deleteChild(Child child) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Child'),
        content: Text('Are you sure you want to delete ${child.name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _children.removeWhere((c) => c.id == child.id);
                });
                Navigator.pop(context);
              },
              child: const Text('Delete')),
        ],
      ),
    );
  }

  void _showChildDetails(BuildContext context, Child child) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(child.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Age: ${child.age}'),
            Text('Gender: ${child.gender}'),
            Text('Room: ${child.room}'),
            Text('Health: ${child.healthStatus}'),
            Text('Sponsored: ${child.isSponsored ? "Yes" : "No"}'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showChildForm(BuildContext context, {Child? child}) {
    final nameController = TextEditingController(text: child?.name ?? '');
    final ageController =
        TextEditingController(text: child != null ? '${child.age}' : '');
    final roomController = TextEditingController(text: child?.room ?? '');
    final genderController = TextEditingController(text: child?.gender ?? '');
    final healthController = TextEditingController(text: child?.healthStatus ?? '');
    bool isSponsored = child?.isSponsored ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(child == null ? 'Add Child' : 'Edit Child'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: ageController, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number),
              TextField(controller: genderController, decoration: const InputDecoration(labelText: 'Gender')),
              TextField(controller: roomController, decoration: const InputDecoration(labelText: 'Room')),
              TextField(controller: healthController, decoration: const InputDecoration(labelText: 'Health Status')),
              Row(
                children: [
                  const Text('Sponsored: '),
                  Switch(
                    value: isSponsored,
                    onChanged: (value) {
                      setState(() {
                        isSponsored = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  if (child == null) {
                    _children.add(Child(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      age: int.tryParse(ageController.text) ?? 0,
                      gender: genderController.text,
                      room: roomController.text,
                      healthStatus: healthController.text,
                      isSponsored: isSponsored,
                    ));
                  } else {
                    final index = _children.indexWhere((c) => c.id == child.id);
                    if (index != -1) {
                      _children[index] = Child(
                        id: child.id,
                        name: nameController.text,
                        age: int.tryParse(ageController.text) ?? child.age,
                        gender: genderController.text,
                        room: roomController.text,
                        healthStatus: healthController.text,
                        isSponsored: isSponsored,
                      );
                    }
                  }
                });
                Navigator.pop(context);
              },
              child: Text(child == null ? 'Add' : 'Update')),
        ],
      ),
    );
  }
}