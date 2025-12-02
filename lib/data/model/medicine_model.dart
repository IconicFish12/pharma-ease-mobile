// To parse this JSON data, do
//
//     final medicineModel = medicineModelFromMap(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'medicine_model.g.dart';

MedicineModel medicineModelFromMap(String str) => MedicineModel.fromJson(json.decode(str));

String medicineModelToMap(MedicineModel data) => json.encode(data.toJson());

@JsonSerializable()
class MedicineModel {
    @JsonKey(name: "status")
    final String? status;
    @JsonKey(name: "message")
    final String? message;
    @JsonKey(name: "data")
    final List<Datum>? data;
    @JsonKey(name: "meta")
    final Meta? meta;

    MedicineModel({
        this.status,
        this.message,
        this.data,
        this.meta,
    });

    MedicineModel copyWith({
        String? status,
        String? message,
        List<Datum>? data,
        Meta? meta,
    }) => 
        MedicineModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
            meta: meta ?? this.meta,
        );

    factory MedicineModel.fromJson(Map<String, dynamic> json) => _$MedicineModelFromJson(json);

    Map<String, dynamic> toJson() => _$MedicineModelToJson(this);
}

@JsonSerializable()
class Datum {
    @JsonKey(name: "id")
    final String? id;
    @JsonKey(name: "medicineName")
    final String? medicineName;
    @JsonKey(name: "sku")
    final String? sku;
    @JsonKey(name: "stock")
    final int? stock;
    @JsonKey(name: "expiredDate")
    final String? expiredDate;
    @JsonKey(name: "price")
    final String? price;
    @JsonKey(name: "category")
    final Category? category;
    @JsonKey(name: "suplier")
    final Suplier? suplier;
    @JsonKey(name: "createdAt")
    final DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    final DateTime? updatedAt;

    Datum({
        this.id,
        this.medicineName,
        this.sku,
        this.stock,
        this.expiredDate,
        this.price,
        this.category,
        this.suplier,
        this.createdAt,
        this.updatedAt,
    });

    Datum copyWith({
        String? id,
        String? medicineName,
        String? sku,
        int? stock,
        String? expiredDate,
        String? price,
        Category? category,
        Suplier? suplier,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            id: id ?? this.id,
            medicineName: medicineName ?? this.medicineName,
            sku: sku ?? this.sku,
            stock: stock ?? this.stock,
            expiredDate: expiredDate ?? this.expiredDate,
            price: price ?? this.price,
            category: category ?? this.category,
            suplier: suplier ?? this.suplier,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

    Map<String, dynamic> toJson() => _$DatumToJson(this);
}

@JsonSerializable()
class Category {
    @JsonKey(name: "id")
    final String? id;
    @JsonKey(name: "categoryName")
    final String? categoryName;
    @JsonKey(name: "createdAt")
    final DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    final DateTime? updatedAt;

    Category({
        this.id,
        this.categoryName,
        this.createdAt,
        this.updatedAt,
    });

    Category copyWith({
        String? id,
        String? categoryName,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Category(
            id: id ?? this.id,
            categoryName: categoryName ?? this.categoryName,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

    Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class Suplier {
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

    Suplier({
        this.id,
        this.supplierName,
        this.contactPerson,
        this.phone,
        this.address,
        this.createdAt,
        this.updatedAt,
    });

    Suplier copyWith({
        String? id,
        String? supplierName,
        String? contactPerson,
        dynamic phone,
        String? address,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Suplier(
            id: id ?? this.id,
            supplierName: supplierName ?? this.supplierName,
            contactPerson: contactPerson ?? this.contactPerson,
            phone: phone ?? this.phone,
            address: address ?? this.address,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Suplier.fromJson(Map<String, dynamic> json) => _$SuplierFromJson(json);

    Map<String, dynamic> toJson() => _$SuplierToJson(this);
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
