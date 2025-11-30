// To parse this JSON data, do
//
//     final userModel = userModelFromMap(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'user_model.g.dart';

UserModel userModelFromMap(String str) => UserModel.fromJson(json.decode(str));

String userModelToMap(UserModel data) => json.encode(data.toJson());

@JsonSerializable()
class UserModel {
    @JsonKey(name: "status")
    final String? status;
    @JsonKey(name: "message")
    final String? message;
    @JsonKey(name: "data")
    final List<Datum>? data;
    @JsonKey(name: "meta")
    final Meta? meta;

    UserModel({
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    UserModel copyWith({
        String? status,
        String? message,
        List<Datum>? data,
        Meta? meta,
    }) => 
        UserModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
            meta: meta ?? this.meta,
        );

    factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

    Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class Datum {
    @JsonKey(name: "id")
    final String? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "emp_id")
    final String? empId;
    @JsonKey(name: "email")
    final String? email;
    @JsonKey(name: "role")
    final String? role;
    @JsonKey(name: "shift")
    final String? shift;
    @JsonKey(name: "date_of_birth")
    final String? dateOfBirth;
    @JsonKey(name: "address")
    final String? address;
    @JsonKey(name: "salary")
    final String? salary;
    @JsonKey(name: "start_date")
    final String? startDate;
    @JsonKey(name: "avatar")
    final dynamic avatar;
    @JsonKey(name: "createdAt")
    final String? createdAt;
    @JsonKey(name: "updatedAt")
    final String? updatedAt;

    Datum({
        this.id,
        this.name,
        this.empId,
        this.email,
        this.role,
        this.shift,
        this.dateOfBirth,
        this.address,
        this.salary,
        this.startDate,
        this.avatar,
        this.createdAt,
        this.updatedAt,
    });

    Datum copyWith({
        String? id,
        String? name,
        String? empId,
        String? email,
        String? role,
        String? shift,
        String? dateOfBirth,
        String? address,
        String? salary,
        String? startDate,
        dynamic avatar,
        String? createdAt,
        String? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            name: name ?? this.name,
            empId: empId ?? this.empId,
            email: email ?? this.email,
            role: role ?? this.role,
            shift: shift ?? this.shift,
            dateOfBirth: dateOfBirth ?? this.dateOfBirth,
            address: address ?? this.address,
            salary: salary ?? this.salary,
            startDate: startDate ?? this.startDate,
            avatar: avatar ?? this.avatar,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

    Map<String, dynamic> toJson() => _$DatumToJson(this);
}

@JsonSerializable()
class Meta {
    @JsonKey(name: "current_page")
    final int? currentPage;
    @JsonKey(name: "last_page")
    final int? lastPage;
    @JsonKey(name: "per_page")
    final int? perPage;
    @JsonKey(name: "total")
    final int? total;

    Meta({
        this.currentPage,
        this.lastPage,
        this.perPage,
        this.total,
    });

    Meta copyWith({
        int? currentPage,
        int? lastPage,
        int? perPage,
        int? total,
    }) => 
        Meta(
            currentPage: currentPage ?? this.currentPage,
            lastPage: lastPage ?? this.lastPage,
            perPage: perPage ?? this.perPage,
            total: total ?? this.total,
        );

    factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

    Map<String, dynamic> toJson() => _$MetaToJson(this);
}
