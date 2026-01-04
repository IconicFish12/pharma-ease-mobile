// To parse this JSON data, do
//
//     final medicineCategoryModel = medicineCategoryModelFromMap(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'activity_log_model.g.dart';

ActivityLogModel activityLogModelFromMap(String str) => ActivityLogModel.fromJson(json.decode(str));

String activityLogModelToMap(ActivityLogModel data) => json.encode(data.toJson());

@JsonSerializable()
class ActivityLogModel {
    @JsonKey(name: "status")
    String? status;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "data")
    Data? data;

    ActivityLogModel({
        this.status,
        this.message,
        this.data,
    });

    ActivityLogModel copyWith({
        String? status,
        String? message,
        Data? data,
    }) => 
        ActivityLogModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory ActivityLogModel.fromJson(Map<String, dynamic> json) => _$ActivityLogModelFromJson(json);

    Map<String, dynamic> toJson() => _$ActivityLogModelToJson(this);
}

@JsonSerializable()
class Data {
    @JsonKey(name: "current_page")
    int? currentPage;
    @JsonKey(name: "data")
    List<Datum>? data;
    @JsonKey(name: "first_page_url")
    String? firstPageUrl;
    @JsonKey(name: "from")
    int? from;
    @JsonKey(name: "last_page")
    int? lastPage;
    @JsonKey(name: "last_page_url")
    String? lastPageUrl;
    @JsonKey(name: "links")
    List<Link>? links;
    @JsonKey(name: "next_page_url")
    String? nextPageUrl;
    @JsonKey(name: "path")
    String? path;
    @JsonKey(name: "per_page")
    int? perPage;
    @JsonKey(name: "prev_page_url")
    dynamic prevPageUrl;
    @JsonKey(name: "to")
    int? to;
    @JsonKey(name: "total")
    int? total;

    Data({
        this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total,
    });

    Data copyWith({
        int? currentPage,
        List<Datum>? data,
        String? firstPageUrl,
        int? from,
        int? lastPage,
        String? lastPageUrl,
        List<Link>? links,
        String? nextPageUrl,
        String? path,
        int? perPage,
        dynamic prevPageUrl,
        int? to,
        int? total,
    }) => 
        Data(
            currentPage: currentPage ?? this.currentPage,
            data: data ?? this.data,
            firstPageUrl: firstPageUrl ?? this.firstPageUrl,
            from: from ?? this.from,
            lastPage: lastPage ?? this.lastPage,
            lastPageUrl: lastPageUrl ?? this.lastPageUrl,
            links: links ?? this.links,
            nextPageUrl: nextPageUrl ?? this.nextPageUrl,
            path: path ?? this.path,
            perPage: perPage ?? this.perPage,
            prevPageUrl: prevPageUrl ?? this.prevPageUrl,
            to: to ?? this.to,
            total: total ?? this.total,
        );

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

    Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Datum {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "log_name")
    String? logName;
    @JsonKey(name: "description")
    Description? description;
    @JsonKey(name: "subject_type")
    String? subjectType;
    @JsonKey(name: "subject_id")
    String? subjectId;
    @JsonKey(name: "causer_type")
    CauserType? causerType;
    @JsonKey(name: "causer_id")
    String? causerId;
    @JsonKey(name: "properties")
    Properties? properties;
    @JsonKey(name: "created_at")
    DateTime? createdAt;
    @JsonKey(name: "updated_at")
    DateTime? updatedAt;
    @JsonKey(name: "event")
    String? event;
    @JsonKey(name: "batch_uuid")
    dynamic batchUuid;
    @JsonKey(name: "causer")
    Causer? causer;

    Datum({
        this.id,
        this.logName,
        this.description,
        this.subjectType,
        this.subjectId,
        this.causerType,
        this.causerId,
        this.properties,
        this.createdAt,
        this.updatedAt,
        this.event,
        this.batchUuid,
        this.causer,
    });

    Datum copyWith({
        int? id,
        String? logName,
        Description? description,
        String? subjectType,
        String? subjectId,
        CauserType? causerType,
        String? causerId,
        Properties? properties,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? event,
        dynamic batchUuid,
        Causer? causer,
    }) => 
        Datum(
            id: id ?? this.id,
            logName: logName ?? this.logName,
            description: description ?? this.description,
            subjectType: subjectType ?? this.subjectType,
            subjectId: subjectId ?? this.subjectId,
            causerType: causerType ?? this.causerType,
            causerId: causerId ?? this.causerId,
            properties: properties ?? this.properties,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            event: event ?? this.event,
            batchUuid: batchUuid ?? this.batchUuid,
            causer: causer ?? this.causer,
        );

    factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

    Map<String, dynamic> toJson() => _$DatumToJson(this);
}

@JsonSerializable()
class Causer {
    @JsonKey(name: "user_id")
    String? userId;
    @JsonKey(name: "name")
    Name? name;
    @JsonKey(name: "emp_id")
    EmpId? empId;
    @JsonKey(name: "email")
    Email? email;
    @JsonKey(name: "email_verified_at")
    DateTime? emailVerifiedAt;
    @JsonKey(name: "role")
    Role? role;
    @JsonKey(name: "shift")
    Shift? shift;
    @JsonKey(name: "date_of_birth")
    DateTime? dateOfBirth;
    @JsonKey(name: "alamat")
    Alamat? alamat;
    @JsonKey(name: "profile_avatar")
    dynamic profileAvatar;
    @JsonKey(name: "salary")
    int? salary;
    @JsonKey(name: "start_date")
    DateTime? startDate;
    @JsonKey(name: "last_login_at")
    dynamic lastLoginAt;
    @JsonKey(name: "created_at")
    DateTime? createdAt;
    @JsonKey(name: "updated_at")
    DateTime? updatedAt;

    Causer({
        this.userId,
        this.name,
        this.empId,
        this.email,
        this.emailVerifiedAt,
        this.role,
        this.shift,
        this.dateOfBirth,
        this.alamat,
        this.profileAvatar,
        this.salary,
        this.startDate,
        this.lastLoginAt,
        this.createdAt,
        this.updatedAt,
    });

    Causer copyWith({
        String? userId,
        Name? name,
        EmpId? empId,
        Email? email,
        DateTime? emailVerifiedAt,
        Role? role,
        Shift? shift,
        DateTime? dateOfBirth,
        Alamat? alamat,
        dynamic profileAvatar,
        int? salary,
        DateTime? startDate,
        dynamic lastLoginAt,
        DateTime? createdAt,
        DateTime? updatedAt,
    }) => 
        Causer(
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

    factory Causer.fromJson(Map<String, dynamic> json) => _$CauserFromJson(json);

    Map<String, dynamic> toJson() => _$CauserToJson(this);
}

enum Alamat {
    @JsonValue("561 DuBuque Mount\nNoramouth, AR 06538-6064")
    THE_561_DU_BUQUE_MOUNT_NORAMOUTH_AR_065386064
}

enum Email {
    @JsonValue("jefferey95@leuschke.org")
    JEFFEREY95_LEUSCHKE_ORG
}

enum EmpId {
    @JsonValue("EMP-51414")
    EMP_51414
}

enum Name {
    @JsonValue("Prof. Alec Beahan DDS")
    PROF_ALEC_BEAHAN_DDS
}

enum Role {
    @JsonValue("owner")
    OWNER
}

enum Shift {
    @JsonValue("malam")
    MALAM
}

enum CauserType {
    @JsonValue("App\\Models\\User")
    APP_MODELS_USER
}

enum Description {
    @JsonValue("Created")
    CREATED,
    @JsonValue("Login")
    LOGIN,
    @JsonValue("Updated")
    UPDATED
}

@JsonSerializable()
class Properties {
    @JsonKey(name: "ip")
    Ip? ip;
    @JsonKey(name: "user_name")
    Name? userName;
    @JsonKey(name: "role")
    Role? role;
    @JsonKey(name: "details")
    Details? details;
    @JsonKey(name: "attributes")
    Attributes? attributes;
    @JsonKey(name: "old")
    Old? old;

    Properties({
        this.ip,
        this.userName,
        this.role,
        this.details,
        this.attributes,
        this.old,
    });

    Properties copyWith({
        Ip? ip,
        Name? userName,
        Role? role,
        Details? details,
        Attributes? attributes,
        Old? old,
    }) => 
        Properties(
            ip: ip ?? this.ip,
            userName: userName ?? this.userName,
            role: role ?? this.role,
            details: details ?? this.details,
            attributes: attributes ?? this.attributes,
            old: old ?? this.old,
        );

    factory Properties.fromJson(Map<String, dynamic> json) => _$PropertiesFromJson(json);

    Map<String, dynamic> toJson() => _$PropertiesToJson(this);
}

@JsonSerializable()
class Attributes {
    @JsonKey(name: "sales_id")
    String? salesId;
    @JsonKey(name: "kode_penjualan")
    String? kodePenjualan;
    @JsonKey(name: "user_id")
    String? userId;
    @JsonKey(name: "transaction_date")
    DateTime? transactionDate;
    @JsonKey(name: "total_price")
    int? totalPrice;
    @JsonKey(name: "created_at")
    DateTime? createdAt;
    @JsonKey(name: "updated_at")
    DateTime? updatedAt;
    @JsonKey(name: "medicine_id")
    String? medicineId;
    @JsonKey(name: "quantity")
    int? quantity;
    @JsonKey(name: "unit_price")
    int? unitPrice;
    @JsonKey(name: "subtotal")
    int? subtotal;
    @JsonKey(name: "stock")
    int? stock;

    Attributes({
        this.salesId,
        this.kodePenjualan,
        this.userId,
        this.transactionDate,
        this.totalPrice,
        this.createdAt,
        this.updatedAt,
        this.medicineId,
        this.quantity,
        this.unitPrice,
        this.subtotal,
        this.stock,
    });

    Attributes copyWith({
        String? salesId,
        String? kodePenjualan,
        String? userId,
        DateTime? transactionDate,
        int? totalPrice,
        DateTime? createdAt,
        DateTime? updatedAt,
        String? medicineId,
        int? quantity,
        int? unitPrice,
        int? subtotal,
        int? stock,
    }) => 
        Attributes(
            salesId: salesId ?? this.salesId,
            kodePenjualan: kodePenjualan ?? this.kodePenjualan,
            userId: userId ?? this.userId,
            transactionDate: transactionDate ?? this.transactionDate,
            totalPrice: totalPrice ?? this.totalPrice,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            medicineId: medicineId ?? this.medicineId,
            quantity: quantity ?? this.quantity,
            unitPrice: unitPrice ?? this.unitPrice,
            subtotal: subtotal ?? this.subtotal,
            stock: stock ?? this.stock,
        );

    factory Attributes.fromJson(Map<String, dynamic> json) => _$AttributesFromJson(json);

    Map<String, dynamic> toJson() => _$AttributesToJson(this);
}

enum Details {
    @JsonValue("Created new data: #")
    CREATED_NEW_DATA,
    @JsonValue("Successful login")
    SUCCESSFUL_LOGIN,
    @JsonValue("Updated data: #")
    UPDATED_DATA
}

enum Ip {
    @JsonValue("127.0.0.1")
    THE_127001
}

@JsonSerializable()
class Old {
    @JsonKey(name: "stock")
    int? stock;
    @JsonKey(name: "updated_at")
    DateTime? updatedAt;
    @JsonKey(name: "transaction_date")
    DateTime? transactionDate;
    @JsonKey(name: "total_price")
    int? totalPrice;

    Old({
        this.stock,
        this.updatedAt,
        this.transactionDate,
        this.totalPrice,
    });

    Old copyWith({
        int? stock,
        DateTime? updatedAt,
        DateTime? transactionDate,
        int? totalPrice,
    }) => 
        Old(
            stock: stock ?? this.stock,
            updatedAt: updatedAt ?? this.updatedAt,
            transactionDate: transactionDate ?? this.transactionDate,
            totalPrice: totalPrice ?? this.totalPrice,
        );

    factory Old.fromJson(Map<String, dynamic> json) => _$OldFromJson(json);

    Map<String, dynamic> toJson() => _$OldToJson(this);
}

@JsonSerializable()
class Link {
    @JsonKey(name: "url")
    String? url;
    @JsonKey(name: "label")
    String? label;
    @JsonKey(name: "page")
    int? page;
    @JsonKey(name: "active")
    bool? active;

    Link({
        this.url,
        this.label,
        this.page,
        this.active,
    });

    Link copyWith({
        String? url,
        String? label,
        int? page,
        bool? active,
    }) => 
        Link(
            url: url ?? this.url,
            label: label ?? this.label,
            page: page ?? this.page,
            active: active ?? this.active,
        );

    factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);

    Map<String, dynamic> toJson() => _$LinkToJson(this);
}
