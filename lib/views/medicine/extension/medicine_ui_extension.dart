import 'package:flutter/material.dart';
import 'package:mobile_course_fp/data/model/medicine_model.dart';
import 'package:intl/intl.dart';

enum MedicineStatus { inStock, mediumStock, lowStock }

extension MedicineUiExtension on Datum {
  String get displayName => medicineName ?? 'Unknown';
  String get displayCode => sku ?? '-';
  String get displayCategory => category?.categoryName ?? 'Uncategorized';
  String get displayUnit => 'Unit'; // Field unit tidak ada di API model Datum Anda, saya set default
  int get displayStock => stock ?? 0;

  MedicineStatus get status {
    if (displayStock <= 10) return MedicineStatus.lowStock;
    if (displayStock <= 50) return MedicineStatus.mediumStock;
    return MedicineStatus.inStock;
  }

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

  // Helper Format Currency
  String get formattedPrice {
    final amount = double.tryParse(price ?? '0') ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID', 
      symbol: 'Rp ', 
      decimalDigits: 0
    ).format(amount);
  }
}