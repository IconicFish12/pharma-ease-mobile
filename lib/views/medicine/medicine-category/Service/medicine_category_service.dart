import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../data/model/medicine_category_model.dart'; 

import '../Model/medicine_category_model.dart'; 
import 'package:mobile_course_fp/utils/endpoint.dart';

class MedicineCategoryService {
  final Dio _dio = Dio();

  Future<List<Category>> getCategories() async {
    try {
      final String url = Endpoints.medicineCategory.url;

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'bearer '
          },
        ),
      );

      if (response.statusCode == 200) {
        final apiResponse = MedicineCategoryModel.fromJson(response.data);
        
        final List<Datum> rawData = apiResponse.data ?? [];

        return rawData.map((e) => e.toDomain()).toList();
      } else {
        throw Exception('Failed to load categories. Status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

extension JSONToMedicineCategory on Datum {
  Category toDomain() {
    final String catName = categoryName ?? "Unknown";
    final String catId = id != null ? id.toString() : "0";

    return Category(
      id: catId,
      name: catName,
      icon: _getIconFromName(catName),
    );
  }
}

IconData _getIconFromName(String name) {
  final List<IconData> medicalIcons = [
    Icons.medication,
    Icons.local_hospital,
    Icons.vaccines,
    Icons.monitor_heart,
    Icons.local_pharmacy,
    Icons.healing,
    Icons.bloodtype,
    Icons.medical_services,
    Icons.health_and_safety,
    Icons.science,
    Icons.thermostat,
    Icons.sick,
    Icons.biotech,
    Icons.medication_liquid,
    Icons.sanitizer,
    Icons.masks,
    Icons.medical_information,
    Icons.spa,
    Icons.emergency,
    Icons.pregnant_woman,
  ];

  int hash = name.toLowerCase().trim().hashCode;
  int index = hash.abs() % medicalIcons.length;

  return medicalIcons[index];
}