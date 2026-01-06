import 'package:flutter/material.dart';
import '../Model/medicine_category_model.dart';
import '../Service/medicine_category_service.dart';

class MedicineCategoryViewmodel extends ChangeNotifier {
  final MedicineCategoryService _categoryService = MedicineCategoryService();

  List<Category> _categories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchAllCategories() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _categories = await _categoryService.getCategories();
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('ERROR FETCH CATEGORIES => $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}