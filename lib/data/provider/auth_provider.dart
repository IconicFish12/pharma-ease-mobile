import 'package:flutter/material.dart';
import 'package:mobile_course_fp/data/model/auth_model.dart';
import 'package:mobile_course_fp/data/repository/auth_repository.dart';

enum ViewState { initial, loading, success, error }

class AuthProvider extends ChangeNotifier{
  final AuthRepository authRepository;

  AuthProvider(this.authRepository);

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  User? _currentUser;
  User? get currentUser => _currentUser;

  String? _token;
  String? get token => _token;

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
        _token = authModel.token;
        notifyListeners();
        return true;
      },
    );
  }

  Future<bool> logout() async {
    if (_token == null) {
      _errorMessage = "User is not logged in.";
      return false;
    }

    final result = await authRepository.logout(_token!);

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        return false;
      },
      (_) {
        _currentUser = null;
        _token = null;
        _state = ViewState.initial;
        notifyListeners();
        return true;
      },
    );
  }
}