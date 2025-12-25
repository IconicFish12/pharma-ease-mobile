import 'package:dio/dio.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

class DioClient {
  final Dio _dio;
  final TokenService _tokenService;

  DioClient(this._tokenService): _dio = Dio(
    BaseOptions(
      baseUrl: Config.baseURL,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
      responseType: ResponseType.json
    ),
  ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio;
}