import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

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

  UserModel({this.status, this.message, this.data, this.meta});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class Datum {
  // === PERBAIKAN UTAMA ===
  // Mapping 'user_id' dari Laravel ke variabel 'id' di Flutter
  @JsonKey(name: "user_id")
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

  // Mapping 'alamat' dari Laravel ke variabel 'address'
  @JsonKey(name: "alamat")
  final String? address;

  @JsonKey(name: "salary")
  final dynamic salary; // Dynamic agar aman menerima String "Rp..." atau Int

  @JsonKey(name: "start_date")
  final String? startDate;

  @JsonKey(name: "avatar")
  final dynamic avatar;

  // Mapping ke created_at (snake_case) dan ubah ke String biar aman
  @JsonKey(name: "created_at")
  final String? createdAt;

  @JsonKey(name: "updated_at")
  final String? updatedAt;

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? password;

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
    this.password,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['name'] = name;
    map['emp_id'] = empId;
    map['email'] = email;
    map['role'] = role;
    map['shift'] = shift;
    map['alamat'] = address;

    if (salary != null) {
      String strSalary = salary.toString().replaceAll(RegExp(r'[^0-9]'), '');
      map['salary'] = int.tryParse(strSalary) ?? 0;
    } else {
      map['salary'] = 0;
    }

    if (password != null && password!.isNotEmpty) {
      map['password'] = password;
    }

    if (dateOfBirth != null) {
      map['date_of_birth'] = _formatDate(dateOfBirth!);
    }

    if (startDate != null) {
      map['start_date'] = _formatDate(startDate!);
    }

    return map;
  }

  String _formatDate(String dateStr) {
    try {
      if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateStr)) return dateStr;
      DateTime dt = DateFormat("dd MMM yyyy").parse(dateStr);
      return DateFormat('yyyy-MM-dd').format(dt);
    } catch (e) {
      return dateStr;
    }
  }
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

  Meta({this.currentPage, this.lastPage, this.perPage, this.total});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
