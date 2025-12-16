// To parse this JSON data, do
//
//     final suppliersModel = suppliersModelFromMap(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'supplier_model.g.dart';

SupplierModel supplierModelFromMap(String str) => SupplierModel.fromJson(json.decode(str));

String supplierModelToMap(SupplierModel data) => json.encode(data.toJson());

@JsonSerializable()
class SupplierModel {
    @JsonKey(name: "status")
    final String? status;
    @JsonKey(name: "message")
    final String? message;
    @JsonKey(name: "data")
    final List<Datum>? data;
    @JsonKey(name: "meta")
    final Meta? meta;

    SupplierModel({
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    SupplierModel copyWith({
        String? status,
        String? message,
        List<Datum>? data,
        Meta? meta,
    }) => 
        SupplierModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
            meta: meta ?? this.meta,
        );

    factory SupplierModel.fromJson(Map<String, dynamic> json) => _$SupplierModelFromJson(json);

    Map<String, dynamic> toJson() => _$SupplierModelToJson(this);
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
    final DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    final DateTime? updatedAt;

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
        DateTime? createdAt,
        DateTime? updatedAt,
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
