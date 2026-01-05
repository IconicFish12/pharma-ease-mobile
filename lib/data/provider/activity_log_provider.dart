import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../config/config.dart';
import '../../data/model/activity_log_model.dart';

enum ViewState { initial, loading, success, error, loadingMore }

class ActivityLogProvider extends ChangeNotifier {
  ActivityLogProvider(); 

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Datum> _logs = [];
  List<Datum> get logs => _logs;

  int _currentPage = 1;
  bool _hasReachedMax = false;
  
  Future<Options> _getHeaders() async {
    const storage = FlutterSecureStorage();
    
    final token = await storage.read(key: 'auth_token') ?? ''; 

    return Options(
      headers: {
        "Authorization": "Bearer $token", 
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      validateStatus: (status) => true, 
    );
  }

  // --- Actions ---
  Future<void> fetchLogs({Map<String, dynamic>? params}) async {
    _state = ViewState.loading;
    _errorMessage = null;
    _currentPage = 1; 
    _hasReachedMax = false;
    notifyListeners();

    try {
      final options = await _getHeaders(); 

      final response = await Config.dio.get(
        "${Config.baseURL}/admin/activity-log",
        queryParameters: {'page': _currentPage, ...?params},
        options: options, 
      );

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        final Map<String, dynamic> jsonMap = 
            (responseData is String) ? jsonDecode(responseData) : responseData;

        final model = ActivityLogModel.fromJson(jsonMap);
        final listData = model.data?.data ?? [];

        _logs = listData;
        _state = ViewState.success;
        
        if (listData.isEmpty) {
          _hasReachedMax = true;
        }
      } else if (response.statusCode == 401) {
        _state = ViewState.error;
        _errorMessage = "Sesi habis (401). Silakan Login ulang.";
      } else {
        _state = ViewState.error;
        _errorMessage = "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = "App Error: $e"; 
    }
    
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_state == ViewState.loadingMore || _hasReachedMax || _state == ViewState.loading) return;

    _state = ViewState.loadingMore;
    notifyListeners();

    _currentPage++;

    try {
      final options = await _getHeaders();
      
      final response = await Config.dio.get(
        "${Config.baseURL}/admin/activity-log",
        queryParameters: {'page': _currentPage},
        options: options,
      );

      if (response.statusCode == 200) {
        final dynamic responseData = response.data;
        final Map<String, dynamic> jsonMap = 
            (responseData is String) ? jsonDecode(responseData) : responseData;

        final model = ActivityLogModel.fromJson(jsonMap);
        final newData = model.data?.data ?? [];

        if (newData.isEmpty) {
          _hasReachedMax = true;
          _currentPage--;
        } else {
          _logs.addAll(newData);
        }
        _state = ViewState.success;
      } else {
        _currentPage--;
        _state = ViewState.success; 
      }
    } catch (e) {
      _currentPage--;
      _state = ViewState.success;
    }
    notifyListeners();
  }

  // --- Helper UI ---
  String getChangeSummary(Datum log) {
    if (log.properties?.details != null && log.properties!.details!.isNotEmpty) {
      return log.properties!.details!;
    }
    return log.description ?? 'Aktivitas tercatat';
  }
}