// To parse this JSON data, do
//
//     final medicineOrderModel = medicineOrderModelFromMap(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'medicine_order_model.g.dart';

MedicineOrderModel medicineOrderModelFromMap(String str) => MedicineOrderModel.fromJson(json.decode(str));

String medicineOrderModelToMap(MedicineOrderModel data) => json.encode(data.toJson());

@JsonSerializable()
class MedicineOrderModel {
    @JsonKey(name: "status")
    final String? status;
    @JsonKey(name: "message")
    final String? message;
    @JsonKey(name: "data")
    final List<Datum>? data;

    MedicineOrderModel({
        this.status,
        this.message,
        this.data,
    });

    MedicineOrderModel copyWith({
        String? status,
        String? message,
        List<Datum>? data,
    }) => 
        MedicineOrderModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory MedicineOrderModel.fromJson(Map<String, dynamic> json) => _$MedicineOrderModelFromJson(json);

    Map<String, dynamic> toJson() => _$MedicineOrderModelToJson(this);
}

@JsonSerializable()
class Datum {
    @JsonKey(name: "order_id")
    final String? orderId;
    @JsonKey(name: "order_code")
    final String? orderCode;
    @JsonKey(name: "transaction_date")
    final DateTime? transactionDate;
    @JsonKey(name: "status_label")
    final String? statusLabel;
    @JsonKey(name: "total_amount_formatted")
    final String? totalAmountFormatted;
    @JsonKey(name: "cashier")
    final Cashier? cashier;
    @JsonKey(name: "supplier")
    final Supplier? supplier;
    @JsonKey(name: "items")
    final List<Item>? items;
    @JsonKey(name: "createdAt")
    final DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    final DateTime? updatedAt;

    Datum({
        this.orderId,
        this.orderCode,
        this.transactionDate,
        this.statusLabel,
        this.totalAmountFormatted,
        this.cashier,
        this.supplier,
        this.items,
        this.createdAt,
        this.updatedAt,
    });

    Datum copyWith({
        String? orderId,
        String? orderCode,
        DateTime? transactionDate,
        String? statusLabel,
        String? totalAmountFormatted,
        Cashier? cashier,
        Supplier? supplier,
        List<Item>? items,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Datum(
            orderId: orderId ?? this.orderId,
            orderCode: orderCode ?? this.orderCode,
            transactionDate: transactionDate ?? this.transactionDate,
            statusLabel: statusLabel ?? this.statusLabel,
            totalAmountFormatted: totalAmountFormatted ?? this.totalAmountFormatted,
            cashier: cashier ?? this.cashier,
            supplier: supplier ?? this.supplier,
            items: items ?? this.items,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

    Map<String, dynamic> toJson() => _$DatumToJson(this);
}

@JsonSerializable()
class Cashier {
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
    final DateTime? createdAt;
    @JsonKey(name: "updatedAt")
    final DateTime? updatedAt;

    Cashier({
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

    Cashier copyWith({
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
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Cashier(
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

    factory Cashier.fromJson(Map<String, dynamic> json) => _$CashierFromJson(json);

    Map<String, dynamic> toJson() => _$CashierToJson(this);
}

@JsonSerializable()
class Item {
    @JsonKey(name: "medicine_id")
    final String? medicineId;
    @JsonKey(name: "medicine_name")
    final String? medicineName;
    @JsonKey(name: "sku")
    final String? sku;
    @JsonKey(name: "quantity_ordered")
    final int? quantityOrdered;
    @JsonKey(name: "price_per_unit")
    final int? pricePerUnit;
    @JsonKey(name: "subtotal")
    final int? subtotal;

    Item({
        this.medicineId,
        this.medicineName,
        this.sku,
        this.quantityOrdered,
        this.pricePerUnit,
        this.subtotal,
    });

    Item copyWith({
        String? medicineId,
        String? medicineName,
        String? sku,
        int? quantityOrdered,
        int? pricePerUnit,
        int? subtotal,
    }) => 
        Item(
            medicineId: medicineId ?? this.medicineId,
            medicineName: medicineName ?? this.medicineName,
            sku: sku ?? this.sku,
            quantityOrdered: quantityOrdered ?? this.quantityOrdered,
            pricePerUnit: pricePerUnit ?? this.pricePerUnit,
            subtotal: subtotal ?? this.subtotal,
        );

    factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

    Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class Supplier {
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

    Supplier({
        this.id,
        this.supplierName,
        this.contactPerson,
        this.phone,
        this.address,
        this.createdAt,
        this.updatedAt,
    });

    Supplier copyWith({
        String? id,
        String? supplierName,
        String? contactPerson,
        dynamic phone,
        String? address,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Supplier(
            id: id ?? this.id,
            supplierName: supplierName ?? this.supplierName,
            contactPerson: contactPerson ?? this.contactPerson,
            phone: phone ?? this.phone,
            address: address ?? this.address,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);

    Map<String, dynamic> toJson() => _$SupplierToJson(this);
}
