import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';
import 'package:mobile_course_fp/data/repository/service/dio_client.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

class SalesTransactionRepository {
  final TokenService tokenService;
  final Dio _dio;

  SalesTransactionRepository(this.tokenService) : _dio = DioClient(tokenService).dio;

  // Future<Either<Failure, String>> createTransaction() async {
  //   try {
  //     // final reponse = _dio.post('');

  //     return Right('');
  //   } on DioException catch (e) {
      
  //   }
  // }
}