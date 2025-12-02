import 'package:fpdart/fpdart.dart';
import 'package:mobile_course_fp/data/repository/repository.dart';

class TransactionDetailsRepository implements Repository {
  @override
  Future<Either<Failure, List<dynamic>>> getMany({Map<String, dynamic>? queryParams}) {
    // TODO: implement getMany
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, dynamic>> create(data) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, dynamic>> getOne(id) {
    // TODO: implement getOne
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, dynamic>> update(id, data) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> delete(id) {
    // TODO: implement delete
    throw UnimplementedError();
  }
}