import 'package:flutter/material.dart';
import 'package:mobile_course_fp/data/model/activity_log_model.dart';
import 'package:mobile_course_fp/data/repository/activity_log_repository.dart';

enum ViewState { initial, loading, success, error, loadingMore }

class ActivityLogProvider extends ChangeNotifier {
  final ActivityLogRepository _repository;

  ActivityLogProvider(this._repository);

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Datum> _logs = [];
  List<Datum> get logs => _logs;

  int _currentPage = 1;
  bool _hasReachedMax = false;
  
  Map<String, dynamic>? _currentParams;

  // --- Actions ---
  Future<void> fetchLogs({Map<String, dynamic>? params}) async {
    _state = ViewState.loading;
    _errorMessage = null;
    _currentPage = 1; 
    _hasReachedMax = false;
    _currentParams = params;
    notifyListeners();

    final requestParams = {'page': _currentPage, ...?params};

    final result = await _repository.getMany(queryParams: requestParams);

    result.fold(
      (failure) {
        _state = ViewState.error;
        _errorMessage = failure.message;
        notifyListeners();
      },
      (data) {
        _logs = data;
        _state = ViewState.success;
        
        if (data.isEmpty) {
          _hasReachedMax = true;
        }
        notifyListeners();
      },
    );
  }

  Future<void> loadMore() async {
    if (_state == ViewState.loadingMore || _hasReachedMax || _state == ViewState.loading) return;

    _state = ViewState.loadingMore;
    notifyListeners();

    _currentPage++;

    final requestParams = {'page': _currentPage, ...?_currentParams};

    final result = await _repository.getMany(queryParams: requestParams);

    result.fold(
      (failure) {
        _currentPage--;
        _state = ViewState.success; 
        notifyListeners();
      },
      (newData) {
        if (newData.isEmpty) {
          _hasReachedMax = true;
          _currentPage--;
        } else {
          _logs.addAll(newData);
        }
        _state = ViewState.success;
        notifyListeners();
      },
    );
  }

  // --- Helper untuk UI (Logic View Model) ---
  String getChangeSummary(Datum log) {
    if (log.properties?.attributes == null) return log.description?.toString() ?? '-';

    final attributes = log.properties!.attributes!;
    final old = log.properties?.old;

    if (log.event == 'updated' && old != null) {
      if (attributes.stock != null && old.stock != null) {
        return 'Stok berubah: ${old.stock} -> ${attributes.stock}';
      }
    }
    
    return log.description?.toString() ?? 'Perubahan data tercatat';
  }
}