import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_course_fp/data/model/activity_log_model.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';
import 'package:mobile_course_fp/data/repository/service/dio_client.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

class ActivityLogRepository {
  final TokenService tokenService;
  final Dio _dio;

  ActivityLogRepository(this.tokenService) : _dio = DioClient(tokenService).dio;

  Future<Either<Failure, List<Datum>>> getMany({Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get('/admin/activity-log', queryParameters: queryParams);

      if (response.statusCode == 2000) {
        final wrapper = ActivityLogModel.fromJson(response.data);

        final List<Datum> listData = wrapper.data?.data ?? []; 
          return Right(listData);
      } else {
        return Left(Failure("Server Error: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      return Left(Failure(e.message ?? "Terjadi kesalahan koneksi"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  } 
}