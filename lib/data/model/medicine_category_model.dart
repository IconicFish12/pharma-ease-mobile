// To parse this JSON data, do
//
//     final medicineCategoryModel = medicineCategoryModelFromMap(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'medicine_category_model.g.dart';

MedicineCategoryModel medicineCategoryModelFromMap(String str) => MedicineCategoryModel.fromJson(json.decode(str));

String medicineCategoryModelToMap(MedicineCategoryModel data) => json.encode(data.toJson());

@JsonSerializable()
class MedicineCategoryModel {
    @JsonKey(name: "status")
    final String? status;
    @JsonKey(name: "message")
    final String? message;
    @JsonKey(name: "data")
    final List<Datum>? data;
    @JsonKey(name: "meta")
    final Meta? meta;

    MedicineCategoryModel({
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    MedicineCategoryModel copyWith({
        String? status,
        String? message,
        List<Datum>? data,
        Meta? meta,
    }) => 
        MedicineCategoryModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
            meta: meta ?? this.meta,
        );

    factory MedicineCategoryModel.fromJson(Map<String, dynamic> json) => _$MedicineCategoryModelFromJson(json);

    Map<String, dynamic> toJson() => _$MedicineCategoryModelToJson(this);
}

@JsonSerializable()
class Datum {
    @JsonKey(name: "id")
    final String? id;
    @JsonKey(name: "categoryName")
    final String? categoryName;
    @JsonKey(name: "createdAt")
    final AtedAt? createdAt;
    @JsonKey(name: "updatedAt")
    final AtedAt? updatedAt;

    Datum({
        this.id,
        this.categoryName,
        this.createdAt,
        this.updatedAt,
    });

    Datum copyWith({
        String? id,
        String? categoryName,
        AtedAt? createdAt,
        AtedAt? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            categoryName: categoryName ?? this.categoryName,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

    Map<String, dynamic> toJson() => _$DatumToJson(this);
}

enum AtedAt {
    @JsonValue("3 hari yang lalu")
    THE_3_HARI_YANG_LALU
}

final atedAtValues = EnumValues({
    "3 hari yang lalu": AtedAt.THE_3_HARI_YANG_LALU
});

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

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
