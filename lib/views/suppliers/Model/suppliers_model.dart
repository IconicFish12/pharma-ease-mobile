import 'package:flutter/material.dart';


// model
class Supplier {
  final String id;
  String suppliersName;
  String contactPerson;
  String email;
  String phoneNumber;
  String whatsappNumber;
  String address;
  int medicineQuantity;
  SupplierStatus status;

  Supplier({
    required this.id,
    required this.suppliersName,
    required this.contactPerson,
    required this.email,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.address,
    required this.medicineQuantity,
    this.status = SupplierStatus.active,
  });

  Color get statusColor {
    switch (status) {
      case SupplierStatus.active:
        return Colors.green;
      case SupplierStatus.nonActive:
        return Colors.red;
    }
  }

  String get statusText {
    switch (status) {
      case SupplierStatus.active:
        return 'Ready to Stock';
      case SupplierStatus.nonActive:
        return 'Supplier is Unavailable';
    }
  }
}

enum SupplierStatus { active, nonActive }
