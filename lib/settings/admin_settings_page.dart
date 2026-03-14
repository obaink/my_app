// lib/dashboards/admin_settings_page.dart
import 'package:flutter/material.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  // Toggles
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool moduleChildrenEnabled = true;
  bool moduleInventoryEnabled = true;

  // Organization Info
  final TextEditingController orgNameController =
      TextEditingController(text: "Sunshine Orphanage");
  final TextEditingController orgAddressController =
      TextEditingController(text: "123 Hope Street, Yaounde, Cameroon");
  final TextEditingController orgContactController =
      TextEditingController(text: "+237 699 123 456");

  // Password Policy
  final TextEditingController passwordMinLengthController =
      TextEditingController(text: "8");
  bool requireSpecialChars = true;
  bool requireNumbers = true;

  @override
  void dispose() {
    orgNameController.dispose();
    orgAddressController.dispose();
    orgContactController.dispose();
    passwordMinLengthController.dispose();
    super.dispose();
  }

  void showEditOrganizationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Organization Info"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: orgNameController,
                decoration: const InputDecoration(labelText: "Organization Name"),
              ),
              TextField(
                controller: orgAddressController,
                decoration: const InputDecoration(labelText: "Address"),
              ),
              TextField(
                controller: orgContactController,
                decoration: const InputDecoration(labelText: "Contact Number"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void showEditPasswordPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Password Policy"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordMinLengthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Minimum Length"),
              ),
              CheckboxListTile(
                title: const Text("Require Special Characters"),
                value: requireSpecialChars,
                onChanged: (val) {
                  setState(() {
                    requireSpecialChars = val ?? true;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Require Numbers"),
                value: requireNumbers,
                onChanged: (val) {
                  setState(() {
                    requireNumbers = val ?? true;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ==========================
          // User Management Section
          // ==========================
          ExpansionTile(
            leading: const Icon(Icons.people),
            title: const Text('User Management'),
            children: [
              ListTile(
                leading: const Icon(Icons.admin_panel_settings),
                title: const Text('Manage Roles & Permissions'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: navigate to roles management page
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Manage Staff Accounts'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: navigate to staff management page
                },
              ),
            ],
          ),

          const Divider(),

          // ==========================
          // System Configuration
          // ==========================
          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text('System Configuration'),
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Organization Info'),
                subtitle: Text(orgNameController.text),
                trailing: const Icon(Icons.edit),
                onTap: showEditOrganizationDialog,
              ),
              SwitchListTile(
                title: const Text('Dark Mode'),
                value: darkModeEnabled,
                onChanged: (val) {
                  setState(() {
                    darkModeEnabled = val;
                  });
                },
              ),
            ],
          ),

          const Divider(),

          // ==========================
          // Module Settings
          // ==========================
          ExpansionTile(
            leading: const Icon(Icons.extension),
            title: const Text('Module Settings'),
            children: [
              SwitchListTile(
                title: const Text('Children Module'),
                value: moduleChildrenEnabled,
                onChanged: (val) {
                  setState(() {
                    moduleChildrenEnabled = val;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Inventory Module'),
                value: moduleInventoryEnabled,
                onChanged: (val) {
                  setState(() {
                    moduleInventoryEnabled = val;
                  });
                },
              ),
            ],
          ),

          const Divider(),

          // ==========================
          // Notifications
          // ==========================
          ExpansionTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            children: [
              SwitchListTile(
                title: const Text('Enable Notifications'),
                value: notificationsEnabled,
                onChanged: (val) {
                  setState(() {
                    notificationsEnabled = val;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.sms),
                title: const Text('Configure Channels'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: navigate to notification channels page
                },
              ),
            ],
          ),

          const Divider(),

          // ==========================
          // Security & Privacy
          // ==========================
          ExpansionTile(
            leading: const Icon(Icons.lock),
            title: const Text('Security & Privacy'),
            children: [
              ListTile(
                leading: const Icon(Icons.password),
                title: const Text('Password Policy'),
                subtitle: Text(
                    'Min Length: ${passwordMinLengthController.text}, Special Chars: ${requireSpecialChars ? "Yes" : "No"}, Numbers: ${requireNumbers ? "Yes" : "No"}'),
                trailing: const Icon(Icons.edit),
                onTap: showEditPasswordPolicyDialog,
              ),
              ListTile(
                leading: const Icon(Icons.shield),
                title: const Text('Two-Factor Authentication'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // TODO: navigate to 2FA settings
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}