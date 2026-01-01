import 'package:dio/dio.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

class DioClient {
  final TokenService _tokenService;
  late Dio _dio;

  DioClient(this._tokenService) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Config.baseURL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenService.getToken();
          
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 401) {}
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}