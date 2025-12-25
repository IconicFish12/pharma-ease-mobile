// To parse this JSON data, do
//
//     final authModel = authModelFromMap(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'auth_model.g.dart';

AuthModel authModelFromMap(String str) => AuthModel.fromJson(json.decode(str));

String authModelToMap(AuthModel data) => json.encode(data.toJson());

@JsonSerializable()
class AuthModel {
    @JsonKey(name: "status")
    final String status;
    @JsonKey(name: "message")
    final String message;
    @JsonKey(name: "token")
    final String token;
    @JsonKey(name: "user")
    final User user;

    AuthModel({
        required this.status,
        required this.message,
        required this.token,
        required this.user,
    });

    AuthModel copyWith({
        String? status,
        String? message,
        String? token,
        User? user,
    }) => 
        AuthModel(
            status: status ?? this.status,
            message: message ?? this.message,
            token: token ?? this.token,
            user: user ?? this.user,
        );

    factory AuthModel.fromJson(Map<String, dynamic> json) => _$AuthModelFromJson(json);

    Map<String, dynamic> toJson() => _$AuthModelToJson(this);
}

@JsonSerializable()
class User {
    @JsonKey(name: "user_id")
    final String userId;
    @JsonKey(name: "name")
    final String name;
    @JsonKey(name: "emp_id")
    final String empId;
    @JsonKey(name: "email")
    final String email;
    @JsonKey(name: "email_verified_at")
    final DateTime emailVerifiedAt;
    @JsonKey(name: "role")
    final String role;
    @JsonKey(name: "shift")
    final String shift;
    @JsonKey(name: "date_of_birth")
    final DateTime dateOfBirth;
    @JsonKey(name: "alamat")
    final String alamat;
    @JsonKey(name: "profile_avatar")
    final dynamic profileAvatar;
    @JsonKey(name: "salary")
    final int salary;
    @JsonKey(name: "start_date")
    final DateTime startDate;
    @JsonKey(name: "last_login_at")
    final dynamic lastLoginAt;
    @JsonKey(name: "created_at")
    final DateTime createdAt;
    @JsonKey(name: "updated_at")
    final DateTime updatedAt;

    User({
        required this.userId,
        required this.name,
        required this.empId,
        required this.email,
        required this.emailVerifiedAt,
        required this.role,
        required this.shift,
        required this.dateOfBirth,
        required this.alamat,
        required this.profileAvatar,
        required this.salary,
        required this.startDate,
        required this.lastLoginAt,
        required this.createdAt,
        required this.updatedAt,
    });

    User copyWith({
        String? userId,
        String? name,
        String? empId,
        String? email,
        DateTime? emailVerifiedAt,
        String? role,
        String? shift,
        DateTime? dateOfBirth,
        String? alamat,
        dynamic profileAvatar,
        int? salary,
        DateTime? startDate,
        dynamic lastLoginAt,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        User(
            userId: userId ?? this.userId,
            name: name ?? this.name,
            empId: empId ?? this.empId,
            email: email ?? this.email,
            emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
            role: role ?? this.role,
            shift: shift ?? this.shift,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            alamat: alamat ?? this.alamat,
            profileAvatar: profileAvatar ?? this.profileAvatar,
            salary: salary ?? this.salary,
            startDate: startDate ?? this.startDate,
            lastLoginAt: lastLoginAt ?? this.lastLoginAt,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

    Map<String, dynamic> toJson() => _$UserToJson(this);
}
