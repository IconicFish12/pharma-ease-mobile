import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_course_fp/data/model/supplier_model.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';
import 'package:mobile_course_fp/data/repository/service/dio_client.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

class SupplierRepository implements Repository<Datum> {
  static String endpoint = '/admin/suppliers';
  final TokenService tokenService;
  final Dio _dio;

  SupplierRepository(this.tokenService) : _dio = DioClient(tokenService).dio;

   @override
  Future<Either<Failure, List<Datum>>> getMany({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final wrapper = SupplierModel.fromJson(response.data);
        return Right(wrapper.data ?? []);
      } else {
        return Left(Failure("Server Error: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      debugPrint("DioError GetMany: ${e.message}");
      return Left(Failure(e.response?.data['message'] ?? "Terjadi kesalahan koneksi"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

   @override
  Future<Either<Failure, Datum>> getOne(dynamic id) async {
    try {
      final response = await _dio.get('$endpoint/$id');

      if (response.statusCode == 200) {
        // Handle kemungkinan wrapper data
        final json = response.data['data'] ?? response.data;
        final data = Datum.fromJson(json);
        return Right(data);
      }
      return Left(Failure("Server Error: ${response.statusCode}"));
    } on DioException catch (e) {
      debugPrint("DioError GetOne: ${e.message}");
      return Left(Failure(e.message ?? "Terjadi kesalahan koneksi"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Datum>> create({required dynamic data}) async {
    try {
      debugPrint("API Request Create Payload: $data");

      final response = await _dio.post(endpoint, data: data);

      debugPrint("API Response Create: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final json = response.data['data'] ?? response.data;
        final wrapper = Datum.fromJson(json);
        return Right(wrapper);
      }
      return Left(Failure("Gagal create data: Status ${response.statusCode}"));
    } on DioException catch (e) {
      debugPrint("DioError Create: ${e.response?.data} | ${e.message}");
      return Left(Failure(e.response?.data['message'] ?? e.message ?? "Terjadi kesalahan koneksi"));
    } catch (e) {
      debugPrint("Error Create: $e");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> update(dynamic id, {required dynamic data}) async {
    try {
      debugPrint("API Request Update Payload: $data");

      final response = await _dio.put(
        '$endpoint/$id',
        data: data,
      );

      debugPrint("API Response Update: ${response.statusCode}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Karena backend hanya return true/message, kita return true saja
        return const Right(true);
      }
      return Left(Failure("Gagal update data: Status ${response.statusCode}"));
    } on DioException catch (e) {
       debugPrint("DioError Update: ${e.response?.data} | ${e.message}");
      return Left(Failure(e.response?.data['message'] ?? e.message ?? "Terjadi kesalahan koneksi"));
    } catch (e) {
      debugPrint("Error Message : ${e.toString()}");
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> delete(dynamic id) async {
    try {
      final response = await _dio.delete('$endpoint/$id');
      if (response.statusCode == 200) {
        return const Right(true);
      }
      return Left(Failure("Gagal delete"));
    } on DioException catch (e) {
      return Left(Failure(e.message ?? "Terjadi kesalahan koneksi"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
