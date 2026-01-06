import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile_course_fp/data/model/medicine_order_model.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';
import 'package:mobile_course_fp/data/repository/service/dio_client.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';

class MedicineOrderRepository implements Repository<Datum> {
  static String endpoint = 'http://localhost:8000/api/admin/medicine-order';
  final TokenService tokenService;
  final Dio _dio;

  MedicineOrderRepository(this.tokenService) : _dio = DioClient(tokenService).dio;

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
        final wrapper = MedicineOrderModel.fromJson(response.data);

        final List<Datum> dataList = wrapper.data ?? [];

        return Right(dataList);
      } else {
        return Left(Failure("Server Error: ${response.statusCode}"));
      }
    } on DioException catch (e) {
      return Left(Failure(e.message ?? "Terjadi kesalahan koneksi"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Datum>> getOne(dynamic id) async {
    try {
      final response = await _dio.get('$endpoint/$id');

      if (response.statusCode == 200) {
        final wrapper = MedicineOrderModel.fromJson(response.data);
        if (wrapper.data != null && wrapper.data!.isNotEmpty) {
          return Right(wrapper.data!.first);
        } else {
          return Left(Failure("Data tidak ditemukan"));
        }
      }
      return Left(Failure("Server Error"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Datum>> create({required dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data.toJson());

      if (response.statusCode == 201 || response.statusCode == 200) {
        final wrapper = MedicineOrderModel.fromJson(response.data);
        if (wrapper.data != null && wrapper.data!.isNotEmpty) {
          return Right(wrapper.data!.first);
        }
        return Left(Failure("Gagal parsing response create"));
      }
      return Left(Failure("Gagal create data"));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Datum>> update(dynamic id, {required dynamic data}) async {
    try {
      final response = await _dio.put(
        '$endpoint/$id',
        data: data.toJson(),
      );

      if (response.statusCode == 200) {
        final wrapper = MedicineOrderModel.fromJson(response.data);
        return Right(wrapper.data!.first);
      }
      return Left(Failure("Gagal update"));
    } catch (e) {
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
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}