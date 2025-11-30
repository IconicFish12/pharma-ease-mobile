// To parse this JSON data, do
//
//     final suppliersModel = suppliersModelFromMap(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'supplier_model.g.dart';

SuppliersModel suppliersModelFromMap(String str) => SuppliersModel.fromJson(json.decode(str));

String suppliersModelToMap(SuppliersModel data) => json.encode(data.toJson());

@JsonSerializable()
class SuppliersModel {
    @JsonKey(name: "status")
    final String? status;
    @JsonKey(name: "message")
    final String? message;
    @JsonKey(name: "data")
    final List<Datum>? data;
    @JsonKey(name: "meta")
    final Meta? meta;

    SuppliersModel({
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    SuppliersModel copyWith({
        String? status,
        String? message,
        List<Datum>? data,
        Meta? meta,
    }) => 
        SuppliersModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
            meta: meta ?? this.meta,
        );

    factory SuppliersModel.fromJson(Map<String, dynamic> json) => _$SuppliersModelFromJson(json);

    Map<String, dynamic> toJson() => _$SuppliersModelToJson(this);
}

@JsonSerializable()
class Datum {
    @JsonKey(name: "id")
    final String? id;
    @JsonKey(name: "supplierName")
    final String? supplierName;
    @JsonKey(name: "contactPerson")
    final String? contactPerson;
    @JsonKey(name: "phone")
    final dynamic phone;
    @JsonKey(name: "address")
    final String? address;
    @JsonKey(name: "createdAt")
    final AtedAt? createdAt;
    @JsonKey(name: "updatedAt")
    final AtedAt? updatedAt;

    Datum({
        this.id,
        this.supplierName,
        this.contactPerson,
        this.phone,
        this.address,
        this.createdAt,
        this.updatedAt,
    });

    Datum copyWith({
        String? id,
        String? supplierName,
        String? contactPerson,
        dynamic phone,
        String? address,
        AtedAt? createdAt,
        AtedAt? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            supplierName: supplierName ?? this.supplierName,
            contactPerson: contactPerson ?? this.contactPerson,
            phone: phone ?? this.phone,
            address: address ?? this.address,
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
