import 'package:flutter/material.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';

enum ViewState { initial, loading, success, error }

class Provider<T> extends ChangeNotifier {
  final Repository<T> repository;

  Provider(this.repository);

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<T> _listData = [];
  List<T> get listData => _listData;

  T? _selectedData;
  T? get selectedData => _selectedData;

  void _setLoading() {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
  }

  void _setSuccess() {
    _state = ViewState.success;
    notifyListeners();
  }

  void _setError(Failure failure) {
    _state = ViewState.error;
    _errorMessage = failure.message;
    notifyListeners();
  }

  // GET ALL
  Future<void> fetchList({Map<String, dynamic>? params}) async {
    _setLoading();
    final result = await repository.getMany(queryParams: params);
    
    result.fold(
      (failure) => _setError(failure),
      (data) {
        _listData = data;
        _setSuccess();
      },
    );
  }

  // GET ONE
  Future<void> fetchDetail(dynamic id) async {
    _setLoading();
    final result = await repository.getOne(id);

    result.fold(
      (failure) => _setError(failure),
      (data) {
        _selectedData = data;
        _setSuccess();
      },
    );
  }

  // CREATE
  Future<bool> addData(T data) async {
    _setLoading();
    final result = await repository.create(data);

    return result.fold(
      (failure) {
        _setError(failure);
        return false;
      },
      (newData) {
        _listData.add(newData);
        _setSuccess();
        return true;
      },
    );
  }

  // UPDATE
  Future<bool> updateData(dynamic id, T data) async {
    _setLoading();
    final result = await repository.update(id, data);

    return result.fold(
      (failure) {
        _setError(failure);
        return false;
      },
      (updatedData) {
        final index = _listData.indexWhere((element) => element == _selectedData); 
        if (index != -1) {
           _listData[index] = updatedData;
        }
        
        _selectedData = updatedData;
        _setSuccess();
        return true;
      },
    );
  }

  // DELETE
  Future<bool> deleteData(dynamic id) async {
    _setLoading(); 
    final result = await repository.delete(id);

    return result.fold(
      (failure) {
        _setError(failure);
        return false;
      },
      (success) {
        // Hapus dari list lokal
        // _listData.removeWhere((item) => item.id == id); // Butuh akses properti id
        // Karena T generic gak tau punya 'id', kita refresh list saja amannya:
        fetchList(); 
        
        _setSuccess();
        return true;
      },
    );
  }
}