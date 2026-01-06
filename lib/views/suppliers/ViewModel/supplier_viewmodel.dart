import 'package:flutter/material.dart';
import '../Model/suppliers_model.dart';
import '../Service/suppliers_service.dart';

class SupplierViewModel extends ChangeNotifier {
  final SupplierService _service = SupplierService();

  List<Supplier> _suppliers = [];
  bool _isLoading = false;
  String _errorMessage = '';
  
  String _searchQuery = '';

  List<Supplier> get suppliers => _suppliers;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  List<Supplier> get filteredSuppliers {
    if (_searchQuery.isEmpty) {
      return _suppliers;
    }
    
    return _suppliers.where((supplier) {
      final query = _searchQuery.toLowerCase();
      return supplier.suppliersName.toLowerCase().contains(query) ||
             supplier.contactPerson.toLowerCase().contains(query) ||
             supplier.phoneNumber.contains(query);
    }).toList();
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    notifyListeners(); 
  }

  Future<void> fetchSuppliers() async {    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      print("[VM] Memanggil Service..."); 
      _suppliers = await _service.getSuppliers();
      
      _searchQuery = ''; 
      
      print("[VM] SUCCESS => mendapatkan ${_suppliers.length} data");
      print("[VM] DATA => $_suppliers");
    
    } catch (e) {
      print("[VM] ERROR => $e"); 
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
      print("[VM] Selesai (Loading false)"); 
    }
  }

  Future<bool> createNewSupplier({
    required String supplierName,
    required String contactPerson,
    required String phoneNumber,
    required String address,
  }) async {
    
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      print("[VM] Mencoba create supplier: $supplierName");
      final bool isSuccess = await _service.createSupplier(
        supplierName: supplierName,
        contactPerson: contactPerson,
        phoneNumber: phoneNumber,
        address: address,
      );
      if (isSuccess) {
        print("[VM] Create Berhasil!");
        await fetchSuppliers(); // Refresh list otomatis
        return true; 
      } else {
        _errorMessage = "Gagal menambahkan supplier";
        return false;
      }

    } catch (e) {
      print("[VM] Create ERROR => $e");
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteSupplier(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("[VM] Deleting supplier id: $id");
      final bool success = await _service.deleteSupplier(id);

      if (success) {
        await fetchSuppliers(); 
        return true;
      } else {
        _errorMessage = "Gagal menghapus data";
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}