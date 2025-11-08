import 'package:flutter/material.dart';

class Medicine {
  final String id;
  String name;
  String code;
  String category;
  int quantity;
  String unit;
  DateTime expiryDate;
  MedicineStatus status;

  Medicine({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    this.status = MedicineStatus.inStock,
  });

  Color get statusColor {
    switch (status) {
      case MedicineStatus.inStock:
        return Colors.green;
      case MedicineStatus.mediumStock:
        return Colors.orange;
      case MedicineStatus.lowStock:
        return Colors.red;
    }
  }

  String get statusText {
    switch (status) {
      case MedicineStatus.inStock:
        return 'In Stock';
      case MedicineStatus.mediumStock:
        return 'Medium Stock';
      case MedicineStatus.lowStock:
        return 'Low Stock';
    }
  }

  void updateStatus() {
    if (quantity <= 10) {
      status = MedicineStatus.lowStock;
    } else if (quantity <= 50) {
      status = MedicineStatus.mediumStock;
    } else {
      status = MedicineStatus.inStock;
    }
  }
}

enum MedicineStatus { inStock, mediumStock, lowStock }

class Category {
  final String id;
  final String name;
  final IconData icon;

  Category({required this.id, required this.name, required this.icon});
}
