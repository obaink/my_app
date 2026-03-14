import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// --------------------
/// ENTITIES
/// --------------------
class Donor {
  final String id;
  final String name;
  final String email;
  final String phone;

  Donor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });
}

enum PaymentMethod { mtn, orange, paypal }

class Donation {
  final String donorName;
  final double amount;
  final PaymentMethod method;
  final DateTime date;

  Donation({
    required this.donorName,
    required this.amount,
    required this.method,
    required this.date,
  });
}

String paymentLabel(PaymentMethod m) {
  switch (m) {
    case PaymentMethod.mtn:
      return "MTN Mobile Money";
    case PaymentMethod.orange:
      return "Orange Money";
    case PaymentMethod.paypal:
      return "PayPal";
  }
}

/// --------------------
/// PROVIDER
/// --------------------
class DonorProvider extends ChangeNotifier {
  final List<Donor> _donors = [];
  final List<Donation> _donations = [];

  List<Donor> get donors => _donors;
  List<Donation> get donations => _donations;

  int get donorCount => _donors.length;

  double get totalDonations =>
      _donations.fold(0.0, (sum, d) => sum + d.amount);

  void addDonor(Donor donor) {
    _donors.insert(0, donor);
    notifyListeners();
  }

  void addDonation(Donation donation) {
    _donations.insert(0, donation);
    notifyListeners();
  }

  final currencyFmt = NumberFormat.currency(symbol: "\$", decimalDigits: 0);
  final dateFmt = DateFormat("dd/MM/yyyy");
}