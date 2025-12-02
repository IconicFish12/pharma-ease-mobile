import 'package:fpdart/fpdart.dart';

class Failure {
  final String message;
  final int? statusCode;

  Failure(this.message, {this.statusCode});

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode)';
}

abstract class Repository<T> {
  Future<Either<Failure, List<T>>> getMany({Map<String, dynamic>? queryParams});

  Future<Either<Failure, T>> getOne(dynamic id);

  Future<Either<Failure, T>> create(T data);

  Future<Either<Failure, T>> update(dynamic id, T data);

  Future<Either<Failure, bool>> delete(dynamic id);
}