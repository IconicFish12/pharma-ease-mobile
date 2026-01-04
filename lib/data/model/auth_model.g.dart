// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
  status: json['status'] as String,
  message: json['message'] as String,
  token: json['token'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
  'status': instance.status,
  'message': instance.message,
  'token': instance.token,
  'user': instance.user,
};

User _$UserFromJson(Map<String, dynamic> json) => User(
  userId: json['user_id'] as String,
  name: json['name'] as String,
  empId: json['emp_id'] as String,
  email: json['email'] as String,
  emailVerifiedAt: json['email_verified_at'] == null
      ? null
      : DateTime.parse(json['email_verified_at'] as String),
  role: json['role'] as String,
  shift: json['shift'] as String,
  dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
  alamat: json['alamat'] as String,
  profileAvatar: json['profile_avatar'] as String?,
  salary: (json['salary'] as num).toInt(),
  startDate: DateTime.parse(json['start_date'] as String),
  lastLoginAt: json['last_login_at'] == null
      ? null
      : DateTime.parse(json['last_login_at'] as String),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'user_id': instance.userId,
  'name': instance.name,
  'emp_id': instance.empId,
  'email': instance.email,
  'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
  'role': instance.role,
  'shift': instance.shift,
  'date_of_birth': instance.dateOfBirth.toIso8601String(),
  'alamat': instance.alamat,
  'profile_avatar': instance.profileAvatar,
  'salary': instance.salary,
  'start_date': instance.startDate.toIso8601String(),
  'last_login_at': instance.lastLoginAt?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};
