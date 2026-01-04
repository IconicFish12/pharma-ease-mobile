import 'dart:convert';
import 'package:dio/dio.dart'; // Pastikan import Dio
import 'package:flutter/material.dart';
import '../../config/config.dart'; // Pastikan path ke Config benar
import '../../data/model/activity_log_model.dart';

enum ViewState { initial, loading, success, error, loadingMore }

class ActivityLogProvider extends ChangeNotifier {
  // Kita HAPUS dependency ke Repository biar tidak ribet
  // final ActivityLogRepository _repository; 
  
  // Constructor jadi kosong
  ActivityLogProvider(); // Hapus parameter repository di main.dart nanti

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Datum> _logs = [];
  List<Datum> get logs => _logs;

  int _currentPage = 1;
  bool _hasReachedMax = false;
  
  // --- Actions ---
  Future<void> fetchLogs({Map<String, dynamic>? params}) async {
    _state = ViewState.loading;
    _errorMessage = null;
    _currentPage = 1; 
    _hasReachedMax = false;
    notifyListeners();

    try {
      // 1. PANGGIL API LANGSUNG (BYPASS REPOSITORY)
      final response = await Config.dio.get(
        "${Config.baseURL}/admin/activity-log",
        queryParameters: {'page': _currentPage, ...?params},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          validateStatus: (status) => true, // Biar gak error kalau status != 200
        ),
      );

      // 2. CEK STATUS
      if (response.statusCode == 200) {
        // 3. PARSING DATA (Handle jika Dio return String atau Map)
        final dynamic responseData = response.data;
        final Map<String, dynamic> jsonMap = 
            (responseData is String) ? jsonDecode(responseData) : responseData;

        // Masukkan ke Model Manual yang baru
        final model = ActivityLogModel.fromJson(jsonMap);
        final listData = model.data?.data ?? [];

        _logs = listData;
        _state = ViewState.success;
        
        if (listData.isEmpty) {
          _hasReachedMax = true;
        }
      } else {
        // Jika server menolak (404, 500, dll)
        _state = ViewState.error;
        _errorMessage = "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      // Jika error kodingan/koneksi
      _state = ViewState.error;
      _errorMessage = "App Error: $e"; 
      print("DEBUG ERROR: $e"); // Cek ini di terminal kalau masih error
    }
    
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (_state == ViewState.loadingMore || _hasReachedMax || _state == ViewState.loading) return;

    _state = ViewState.loadingMore;
    notifyListeners();

    _currentPage++;

    try {
      final response = await Config.dio.get(
        "${Config.baseURL}/admin/activity-log",
        queryParameters: {'page': _currentPage},
        options: Options(headers: {"Accept": "application/json"}),
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
        _state = ViewState.success; // Fail silent saat load more
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