// lib/staff/staff_roles_page.dart
import 'package:flutter/material.dart';

class StaffRolesPage extends StatefulWidget {
  const StaffRolesPage({super.key});

  @override
  State<StaffRolesPage> createState() => _StaffRolesPageState();
}

class _StaffRolesPageState extends State<StaffRolesPage> {
  final List<Map<String, dynamic>> roles = [
    {
      "role": "Administrator",
      "permissions": [
        "Manage Staff",
        "Manage Donations",
        "View Reports",
        "Manage Children"
      ]
    },
    {
      "role": "Caregiver",
      "permissions": ["View Children", "Update Child Records"]
    },
    {
      "role": "Teacher",
      "permissions": ["View Children", "Manage Education"]
    },
    {
      "role": "Volunteer",
      "permissions": ["View Children"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// PAGE TITLE
            const Text(
              "Staff Roles & Permissions",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// ADD ROLE BUTTON
            ElevatedButton.icon(
              onPressed: _showAddRoleDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add Role"),
            ),

            const SizedBox(height: 20),

            /// ROLE CARDS
            Column(
              children: roles.map((role) => _roleCard(role)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// ROLE CARD
  Widget _roleCard(Map<String, dynamic> role) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ROLE HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  role["role"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Row(
                  children: [

                    /// EDIT
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.orange,
                      ),
                      onPressed: () => _showEditRoleDialog(role),
                    ),

                    /// DELETE
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          roles.remove(role);
                        });
                      },
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 10),

            /// PERMISSIONS
            Wrap(
              spacing: 8,
              runSpacing: 5,
              children: role["permissions"]
                  .map<Widget>(
                    (permission) => Chip(
                      label: Text(permission),
                      backgroundColor: Colors.blue.shade50,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// ADD ROLE DIALOG
  void _showAddRoleDialog() {
    final roleController = TextEditingController();
    final permissionsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Role"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ROLE NAME
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: "Role Name",
              ),
            ),

            const SizedBox(height: 10),

            /// PERMISSIONS
            TextField(
              controller: permissionsController,
              decoration: const InputDecoration(
                labelText: "Permissions (comma separated)",
              ),
            ),
          ],
        ),

        actions: [

          /// CANCEL
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          /// SAVE
          ElevatedButton(
            onPressed: () {
              setState(() {
                roles.add({
                  "role": roleController.text,
                  "permissions": permissionsController.text.split(","),
                });
              });

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// EDIT ROLE DIALOG
  void _showEditRoleDialog(Map<String, dynamic> role) {
    final roleController = TextEditingController(text: role["role"]);
    final permissionsController =
        TextEditingController(text: role["permissions"].join(","));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Role"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ROLE NAME
            TextField(
              controller: roleController,
              decoration: const InputDecoration(
                labelText: "Role Name",
              ),
            ),

            const SizedBox(height: 10),

            /// PERMISSIONS
            TextField(
              controller: permissionsController,
              decoration: const InputDecoration(
                labelText: "Permissions",
              ),
            ),
          ],
        ),

        actions: [

          /// CANCEL
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          /// UPDATE
          ElevatedButton(
            onPressed: () {
              setState(() {
                role["role"] = roleController.text;
                role["permissions"] = permissionsController.text.split(",");
              });

              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}