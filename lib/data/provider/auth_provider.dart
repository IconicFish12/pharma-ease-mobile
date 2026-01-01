import 'package:flutter/material.dart';
import 'package:mobile_course_fp/data/model/auth_model.dart';
import 'package:mobile_course_fp/data/repository/auth_repository.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

enum ViewState { initial, loading, success, error }

class AuthProvider extends ChangeNotifier{
  final AuthRepository authRepository;
  final TokenService tokenService;

  AuthProvider(this.authRepository, this.tokenService);

  ViewState _state = ViewState.initial;
  ViewState get state => _state;
  
  User? _currentUser;
  User? get currentUser => _currentUser;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> checkLoginStatus() async {
    final token = await tokenService.getToken();
    if (token != null) {
      _state = ViewState.success;
    } else {
      _state = ViewState.initial;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _state = ViewState.loading;
    notifyListeners();

    final result = await authRepository.login(email, password);

    return result.fold(
      (failure) {
        _state = ViewState.error;
        _errorMessage = failure.message;
        notifyListeners();
        return false;
      },
      (authModel) {
        _state = ViewState.success;
        _currentUser = authModel.user;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> logout() async {
    _state = ViewState.loading;
    notifyListeners();

    await authRepository.logout();
    
    _currentUser = null;
    _state = ViewState.initial;
    notifyListeners();
    return true;
  }
}