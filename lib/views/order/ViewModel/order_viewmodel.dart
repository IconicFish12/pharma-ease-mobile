import 'package:flutter/material.dart';
import '../Model/order_model.dart';
import '../Service/order_service.dart'; 

class OrderViewmodel extends ChangeNotifier {
  final OrderService _service = OrderService();

  List<Order> _orders = [];      
  bool _isLoading = false;       
  String _errorMessage = '';     
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchOrders() async {    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); 

    try {
      print("[OrderVM] Memanggil Service getOrders..."); 
      
      _orders = await _service.getOrders();
      
      print("[OrderVM] SUCCESS => mendapatkan ${_orders.length} data");
    
    } catch (e) {
      print("[OrderVM] ERROR => $e"); 
      _errorMessage = e.toString(); 
    } finally {
      _isLoading = false;
      notifyListeners(); 
      print("[OrderVM] Selesai"); 
    }
  }
}