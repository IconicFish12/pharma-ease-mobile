import 'package:flutter/material.dart';
import 'package:mobile_course_fp/data/model/activity_log_model.dart';
import 'package:mobile_course_fp/data/repository/activity_log_repository.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';

enum ViewState { initial, loading, success, error }

class ActivityLogProvider extends ChangeNotifier {
  final ActivityLogRepository _repository;

  ActivityLogProvider(this._repository);

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Datum> _listData = [];
  List<Datum> get listData => _listData;

  Datum? _selectedData;
  Datum? get selectedData => _selectedData;

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

  Future<void> fetchList({Map<String, dynamic>? params}) async {
    _setLoading();
    final result = await _repository.getMany(queryParams: params);
    
    result.fold(
      (failure) => _setError(failure),
      (data) {
        _listData = data;
        _setSuccess();
      },
    );
  }
}