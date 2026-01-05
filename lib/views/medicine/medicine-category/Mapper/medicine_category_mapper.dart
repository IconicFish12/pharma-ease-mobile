import '../..//medicine-category/Model/medicine_category_model.dart';
import '../../../../data/model/medicine_category_model.dart';
import 'package:flutter/material.dart';

extension JSONToMedicineCategory on Datum {
  Category toDomain() {
    final String categoryName = this.categoryName ?? "-";

    return Category(
      id: id ?? "0",
      name: categoryName,
      icon: _getIconManual(categoryName),
    );
  }
}

IconData _getIconManual(String name) {
    final normalizedName = name.toLowerCase().trim();
    if (normalizedName == 'accusantium') {
      return Icons.medication; 
    } else if (normalizedName == 'rerum') {
      return Icons.local_hospital; 
    } else if (normalizedName == 'perferendis') {
      return Icons.vaccines; 
    } else if (normalizedName == 'repellat') {
      return Icons.monitor_heart; 
    } else if (normalizedName == 'et') {
      return Icons.local_pharmacy;
    } else if (normalizedName == 'repudiandae') {
      return Icons.healing; 
    } else if (normalizedName == 'dolorem') {
      return Icons.bloodtype; 
    } else if (normalizedName == 'enim') {
      return Icons.medical_services; 
    } else if (normalizedName == 'qui') {
      return Icons.health_and_safety; 
    } else if (normalizedName == 'nulla') {
      return Icons.science; 
    } else if (normalizedName == 'suscipit') {
      return Icons.thermostat; 
    } else if (normalizedName == 'fuga') {
      return Icons.sick; 
    } else if (normalizedName == 'incidunt') {
      return Icons.biotech; 
    } else {
      return Icons.bug_report_outlined; 
    }
}
