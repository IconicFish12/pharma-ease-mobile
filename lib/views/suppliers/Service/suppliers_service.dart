import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import '../../../utils/endpoint.dart'; 
import '../../../data/model/supplier_model.dart'; 
import '../Model/suppliers_model.dart'; 
import '../Mapper/suppliers_mapper.dart'; 
import 'package:mobile_course_fp/data/repository/service/token_service.dart';


class SupplierService {

  final TokenService _tokenService = TokenService();
  
  Future<List<Supplier>> getSuppliers() async {
    try {
      final String? token = await _tokenService.getToken();
      print("TOKEN => $token");
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login terlebih dahulu.');
      }
      
      final response = await http.get(
        Uri.parse(Endpoints.supplierList.url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", 
          "Authorization": "Bearer $token",
        },
      );

      print("URL: ${Endpoints.supplierList.url}"); 
      print("Status Code: ${response.statusCode}"); 

      if (response.statusCode == 200) {
        final SupplierModel apiResponse = supplierModelFromMap(response.body);
        final List<Datum>? rawData = apiResponse.data;
        if (rawData == null) return [];
        return rawData.map((datum) => datum.datumToSupplier()).toList();
      } else {
        print("Error Body: ${response.body}"); 
        throw Exception('Gagal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

Future<bool> createSupplier({
    required String supplierName,
    required String contactPerson,
    required String phoneNumber,
    required String address,
  }) async {
    try {
      final String? token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login terlebih dahulu.');
      }

      final Map<String, dynamic> data = {
        "supplier_name": supplierName, 
        "contact_person": contactPerson,
        "phone_number": phoneNumber,
        "address": address,
      };

      final response = await http.post(
        Uri.parse(Endpoints.supplierList.url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", 
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data)
      );

      print("URL: ${Endpoints.supplierList.url}"); 
      print("Status Code: ${response.statusCode}"); 

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; 
      } else {
        print("Gagal Create: ${response.body}");
        return false; 
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }


    Future<bool> deleteSupplier(String id) async {
    try {
      final String? token = await _tokenService.getToken();
      print("TOKEN => $token");
      if (token == null) {
        throw Exception('Token tidak ditemukan. Silakan login terlebih dahulu.');
      }

      final url = Endpoints.supplierList.urlWithId(id);

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json", 
          "Authorization": "Bearer $token",
        },
      );

      print("URL: ${Endpoints.supplierList.url}"); 
      print("Status Code: ${response.statusCode}"); 

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; 
      } else {
        print("Gagal Delete: ${response.body}");
        return false; 
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

}