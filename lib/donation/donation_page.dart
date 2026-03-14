// lib/donation/donation_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/donor_provider.dart'; // <-- global provider

final currencyFmt = NumberFormat.currency(symbol: "\$", decimalDigits: 0);
final dateFmt = DateFormat("dd/MM/yyyy");

/// ------------------------------------------------
/// DONATION PAGE
/// ------------------------------------------------
class DonationPage extends StatelessWidget {
  const DonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DonationPageContent();
  }
}

/// ------------------------------------------------
/// MAIN PAGE CONTENT
/// ------------------------------------------------
class _DonationPageContent extends StatefulWidget {
  const _DonationPageContent();

  @override
  State<_DonationPageContent> createState() => _DonationPageContentState();
}

class _DonationPageContentState extends State<_DonationPageContent> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DonorProvider>(); // reactive updates

    final filteredDonors = model.donors.where((d) {
      final s = search.toLowerCase();
      return d.name.toLowerCase().contains(s) ||
          d.email.toLowerCase().contains(s);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Donors & Donations")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// SUMMARY
            Row(
              children: [
                _SummaryBox(
                  title: "Donors",
                  value: model.donorCount.toString(),
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 10),
                _SummaryBox(
                  title: "Total Donations",
                  value: currencyFmt.format(model.totalDonations),
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// SEARCH
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search donors...",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) {
                setState(() => search = v);
              },
            ),

            const SizedBox(height: 20),

            /// ACTION BUTTONS
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text("Add Donor"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddDonorPage()),
                    );
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.volunteer_activism),
                  label: const Text("Add Donation"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddDonationPage()),
                    );
                  },
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text("History"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const DonationHistoryPage()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(child: _buildDonorList(filteredDonors)),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorList(List<Donor> donors) {
    if (donors.isEmpty) return const Center(child: Text("No donors found."));

    return Card(
      child: ListView.builder(
        itemCount: donors.length,
        itemBuilder: (context, index) {
          final donor = donors[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple,
              child: Text(donor.name.isNotEmpty ? donor.name[0] : "?"),
            ),
            title: Text(donor.name),
            subtitle: Text(donor.email),
          );
        },
      ),
    );
  }
}

/// ------------------------------------------------
/// SUMMARY BOX
/// ------------------------------------------------
class _SummaryBox extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _SummaryBox({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------
/// ADD DONOR PAGE
/// ------------------------------------------------
class AddDonorPage extends StatefulWidget {
  const AddDonorPage({super.key});

  @override
  State<AddDonorPage> createState() => _AddDonorPageState();
}

class _AddDonorPageState extends State<AddDonorPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<DonorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Donor")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: email, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: phone, decoration: const InputDecoration(labelText: "Phone")),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {
                if (name.text.isEmpty) return;

                model.addDonor(Donor(
                  id: DateTime.now().toString(),
                  name: name.text,
                  email: email.text,
                  phone: phone.text,
                ));

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------
/// ADD DONATION PAGE
/// ------------------------------------------------
class AddDonationPage extends StatefulWidget {
  const AddDonationPage({super.key});

  @override
  State<AddDonationPage> createState() => _AddDonationPageState();
}

class _AddDonationPageState extends State<AddDonationPage> {
  final donorName = TextEditingController();
  final amount = TextEditingController();
  PaymentMethod method = PaymentMethod.mtn;

  @override
  void dispose() {
    donorName.dispose();
    amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.read<DonorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Donation")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: donorName, decoration: const InputDecoration(labelText: "Donor Name")),
            TextField(
              controller: amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<PaymentMethod>(
              value: method,
              decoration: const InputDecoration(labelText: "Payment Method"),
              items: PaymentMethod.values.map((m) {
                return DropdownMenuItem(
                  value: m,
                  child: Text(paymentLabel(m)),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) setState(() => method = v);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Donate"),
              onPressed: () {
                final parsedAmount = double.tryParse(amount.text);
                if (parsedAmount == null) return;

                model.addDonation(Donation(
                  donorName: donorName.text,
                  amount: parsedAmount,
                  method: method,
                  date: DateTime.now(),
                ));

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------
/// DONATION HISTORY PAGE
/// ------------------------------------------------
class DonationHistoryPage extends StatelessWidget {
  const DonationHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DonorProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Donation History")),
      body: ListView.builder(
        itemCount: model.donations.length,
        itemBuilder: (context, index) {
          final donation = model.donations[index];
          return ListTile(
            leading: const Icon(Icons.volunteer_activism),
            title: Text(donation.donorName),
            subtitle: Text(paymentLabel(donation.method)),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(currencyFmt.format(donation.amount)),
                Text(dateFmt.format(donation.date)),
              ],
            ),
          );
        },
      ),
    );
  }
}