import 'package:flutter/material.dart';
import '../Model/suppliers_model.dart';
import '../Service/suppliers_service.dart';

class SupplierViewModel extends ChangeNotifier {
  final SupplierService _service = SupplierService();

  List<Supplier> _suppliers = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Supplier> get suppliers => _suppliers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchSuppliers() async {    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      print("[VM] Memanggil Service..."); 
      _suppliers = await _service.getSuppliers();
      print("[VM] SUCCESS => mendapatkan ${_suppliers.length} data");
      print("[VM] DATA => ${_suppliers}");
    
    } catch (e) {
      print("[VM] ERROR => $e"); 
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
      print("[VM] Selesai (Loading false)"); 
    }
  }
}