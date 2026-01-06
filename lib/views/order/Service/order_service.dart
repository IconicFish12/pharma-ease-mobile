import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_course_fp/data/repository/service/current_user_service.dart';
import '../../../utils/endpoint.dart'; 
import '../../../data/repository/service/token_service.dart';
import '../../../data/model/medicine_order_model.dart'; 
import '../Model/order_model.dart'; 
import '../Mapper/order_mapper.dart'; 
import 'package:mobile_course_fp/data/repository/service/current_user_service.dart';

class OrderService {
  final TokenService _tokenService = TokenService();
  final CurrentUserService _currentUserService = CurrentUserService();

  Future<List<Order>> getOrders() async {
    try {
      final token = await _tokenService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await http.get(
        Uri.parse(Endpoints.medicineOrder.url), 
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Order Service Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final apiResponse = medicineOrderModelFromMap(response.body);

        final List<Datum>? rawData = apiResponse.data;
        
        if (rawData == null) return [];

        return rawData.map((datum) => datum.toDomain()).toList();
      } else {
        throw Exception('Gagal memuat data order: ${response.statusCode}');
      }
    } catch (e) {
      print("Order Service Error: $e");
      throw Exception('Error: $e');
    }
  }
}