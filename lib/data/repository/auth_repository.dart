import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/model/auth_model.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';
import 'package:mobile_course_fp/data/repository/service/dio_client.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

enum ViewState { initial, loading, success, error }

class AuthRepository {
  final String baseURL = Config.baseURL;
  final TokenService _tokenService;
  final Dio _dio;

  AuthRepository(this._tokenService) : _dio = DioClient(_tokenService).dio;

  Future<Either<Failure, AuthModel>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await Config.dio.post(
        "$baseURL/login",
        data: {email, password},
      );

      if (response.statusCode == 200) {
        try {
          final token = response.data['token'] as String?;
          
          if (token != null) {
            await _tokenService.saveToken(token);
          }

          final loginModel = AuthModel.fromJson(response.data);
          return Right(loginModel);
        } catch (e) {
          return Left(Failure("Failed to parse login response: $e"));
        }
      } else {
        return Left(
          Failure("Login failed with status code: ${response.statusCode}"),
        );
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(Failure("ID atau Password salah"));
      }
      if (e.response?.statusCode == 404) {
        return Left(Failure("Akun tidak ditemukan"));
      }
      return Left(
        Failure(
          e.response?.data['message'] ??
              e.message ??
              "Terjadi kesalahan koneksi",
        ),
      );
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Future<Either<Failure, void>> logout(String token) async {
    try {
      final response = await Config.dio.post(
        "$baseURL/logout",
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        return Left(Failure("Logout failed with status code: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      return Left(Failure(e.message ?? "Terjadi kesalahan koneksi"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
