import 'package:flutter/material.dart';

enum AdoptionStatus { pending, approved, rejected }

String statusLabel(AdoptionStatus status) {
  switch (status) {
    case AdoptionStatus.pending: return "Pending";
    case AdoptionStatus.approved: return "Approved";
    case AdoptionStatus.rejected: return "Rejected";
  }
}

class AdoptionApplication {
  String id;
  String childId;
  String childName;
  String applicantName;
  String applicantEmail;
  String applicantPhone;
  DateTime appliedOn;
  AdoptionStatus status;

  AdoptionApplication({
    required this.id,
    required this.childId,
    required this.childName,
    required this.applicantName,
    required this.applicantEmail,
    required this.applicantPhone,
    required this.appliedOn,
    this.status = AdoptionStatus.pending,
  });
}

class AdoptionModel extends ChangeNotifier {
  final List<AdoptionApplication> applications = [
    AdoptionApplication(
      id: "A001",
      childId: "C001",
      childName: "Emma Williams",
      applicantName: "Williams Family",
      applicantEmail: "williams@email.com",
      applicantPhone: "+1 555 0401",
      appliedOn: DateTime(2026, 1, 15),
    ),
    AdoptionApplication(
      id: "A002",
      childId: "C002",
      childName: "Liam Johnson",
      applicantName: "Garcia Family",
      applicantEmail: "garcia@email.com",
      applicantPhone: "+1 555 0410",
      appliedOn: DateTime(2026, 2, 2),
      status: AdoptionStatus.approved,
    ),
  ];

  int get total => applications.length;
  int get pending => applications.where((e) => e.status == AdoptionStatus.pending).length;
  int get approved => applications.where((e) => e.status == AdoptionStatus.approved).length;

  void approve(String id) {
    final index = applications.indexWhere((e) => e.id == id);
    if (index != -1) {
      applications[index].status = AdoptionStatus.approved;
      notifyListeners();
    }
  }

  void reject(String id) {
    final index = applications.indexWhere((e) => e.id == id);
    if (index != -1) {
      applications[index].status = AdoptionStatus.rejected;
      notifyListeners();
    }
  }
}