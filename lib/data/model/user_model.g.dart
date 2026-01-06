// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  status: json['status'] as String?,
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'data': instance.data,
  'meta': instance.meta,
};

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: json['user_id'] as String?,
  name: json['name'] as String?,
  empId: json['emp_id'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  shift: json['shift'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  address: json['alamat'] as String?,
  salary: json['salary'],
  startDate: json['start_date'] as String?,
  avatar: json['avatar'],
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'user_id': instance.id,
  'name': instance.name,
  'emp_id': instance.empId,
  'email': instance.email,
  'role': instance.role,
  'shift': instance.shift,
  'date_of_birth': instance.dateOfBirth,
  'alamat': instance.address,
  'salary': instance.salary,
  'start_date': instance.startDate,
  'avatar': instance.avatar,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'per_page': instance.perPage,
  'total': instance.total,
};
