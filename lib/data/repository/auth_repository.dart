import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_course_fp/data/model/auth_model.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';
import 'package:mobile_course_fp/data/repository/service/dio_client.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

enum ViewState { initial, loading, success, error }

class AuthRepository {
  final TokenService _tokenService;
  final Dio _dio;

  AuthRepository(this._tokenService) : _dio = DioClient(_tokenService).dio;

  Future<Either<Failure, AuthModel>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await _dio.post(
        "/login",
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        try {
          print(response.data);

          final token = response.data['token'] as String;

          if (token.isNotEmpty) {
            await _tokenService.saveToken(token);
          }

          final authModel = AuthModel.fromJson(response.data);
          return Right(authModel);
        } catch (e) {
          return Left(Failure("Gagal memproses data login: $e"));
        }
      } else {
        return Left(Failure("Login failed: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      // print(e.message.toString());
      if (e.response?.statusCode == 401) {
        return Left(Failure("ID atau Password salah"));
      }
      if (e.response?.statusCode == 404) {
        return Left(Failure("Akun tidak ditemukan"));
      }
      
      return Left(Failure(e.response?.data['message'] ?? e.message ?? "Error"));
    } catch (e) {
      print(e.toString());

      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      final response = await _dio.post("/logout");

      await _tokenService.deleteToken();

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(Failure("Logout server failed"));
      }
    } catch (e) {
      await _tokenService.deleteToken();
      return Left(Failure(e.toString()));
    }
  }
}
