import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_course_fp/data/model/user_model.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';
import 'package:mobile_course_fp/data/repository/service/dio_client.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

class UserRepository implements Repository<Datum> {
  static String endpoint =
      'https://unuseful-odell-subincomplete.ngrok-free.dev/api/admin/users';

  final TokenService tokenService;
  final Dio _dio;

  UserRepository(this.tokenService) : _dio = DioClient(tokenService).dio {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  Options get _options => Options(
    headers: {
      "ngrok-skip-browser-warning": "true",
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
    followRedirects: false,
    validateStatus: (status) => status! < 500,
  );

  @override
  Future<Either<Failure, List<Datum>>> getMany({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        options: _options,
      );
      if (response.statusCode == 200) {
        final wrapper = UserModel.fromJson(response.data);
        return Right(wrapper.data ?? []);
      }
      return Left(Failure("Server Error: ${response.statusCode}"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Datum>> getOne(dynamic id) async {
    try {
      final response = await _dio.get('$endpoint/$id', options: _options);
      if (response.statusCode == 200) {
        final wrapper = UserModel.fromJson(response.data);
        return Right(wrapper.data!.first);
      }
      return Left(Failure("Data not found"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Datum>> create(Datum data) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data.toJson(),
        options: _options,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Right(data);
      }
      return Left(_parseError(response));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Datum>> update(dynamic id, Datum data) async {
    try {
      final Map<String, dynamic> body = data.toJson();

      body['_method'] = 'PUT';

      final response = await _dio.post(
        '$endpoint/$id',
        data: body,
        options: _options,
      );

      if (response.statusCode == 200) {
        return Right(data);
      }
      return Left(_parseError(response));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(dynamic id) async {
    try {
      final response = await _dio.post(
        '$endpoint/$id',
        data: {'_method': 'DELETE'},
        options: _options,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const Right(true);
      }
      return Left(_parseError(response));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Failure _parseError(Response response) {
    if (response.statusCode == 422 && response.data != null) {
      final data = response.data;
      if (data['message'] != null) return Failure(data['message']);
    }
    if (response.statusCode == 404) return Failure("URL Salah (404). Cek ID.");
    if (response.statusCode == 405)
      return Failure("Method 405. Cek Route Laravel.");
    if (response.statusCode == 500)
      return Failure("Server Error (500). Cek Log Laravel.");
    return Failure("Error: ${response.statusCode}");
  }
}
