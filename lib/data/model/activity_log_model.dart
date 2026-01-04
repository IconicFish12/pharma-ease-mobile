import 'dart:convert';

ActivityLogModel activityLogModelFromMap(String str) =>
    ActivityLogModel.fromJson(json.decode(str));

String activityLogModelToMap(ActivityLogModel data) => json.encode(data.toJson());

class ActivityLogModel {
  String? status;
  String? message;
  Data? data;

  ActivityLogModel({
    this.status,
    this.message,
    this.data,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) =>
      ActivityLogModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? currentPage;
  List<Datum>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  String? nextPageUrl;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Data({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}

class Datum {
  int? id;
  String? logName;
  String? description;
  String? subjectType;
  String? subjectId;
  String? causerType;
  String? causerId;
  Properties? properties;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? event;
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
    this.causer,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    // TRICK PINTAR:
    // Kadang Laravel taruh 'ip', 'user_name', 'role' di luar 'properties'.
    // Kita paksa masukkan ke dalam 'properties' supaya UI tidak error.
    Map<String, dynamic> propsData = json["properties"] is Map 
        ? Map<String, dynamic>.from(json["properties"]) 
        : {};

    // Cek data di root, kalau ada masukkan ke propsData
    if (json["ip"] != null) propsData["ip"] = json["ip"];
    if (json["user_name"] != null) propsData["user_name"] = json["user_name"];
    if (json["role"] != null) propsData["role"] = json["role"];
    if (json["details"] != null) propsData["details"] = json["details"];

    return Datum(
      id: json["id"],
      logName: json["log_name"],
      description: json["description"]?.toString(), // Paksa jadi String
      subjectType: json["subject_type"],
      subjectId: json["subject_id"]?.toString(),
      causerType: json["causer_type"],
      causerId: json["causer_id"]?.toString(),
      properties: Properties.fromJson(propsData),
      createdAt: json["created_at"] == null
          ? null
          : DateTime.tryParse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.tryParse(json["updated_at"]),
      event: json["event"],
      causer: json["causer"] == null ? null : Causer.fromJson(json["causer"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "log_name": logName,
        "description": description,
        "subject_type": subjectType,
        "subject_id": subjectId,
        "causer_type": causerType,
        "causer_id": causerId,
        "properties": properties?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "event": event,
        "causer": causer?.toJson(),
      };
}

class Causer {
  String? userId;
  String? name;
  String? email;
  String? role;

  Causer({
    this.userId,
    this.name,
    this.email,
    this.role,
  });

  factory Causer.fromJson(Map<String, dynamic> json) => Causer(
        userId: json["user_id"]?.toString(),
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        role: json["role"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
        "role": role,
      };
}

class Properties {
  String? ip;
  String? userName;
  String? role;
  String? details;
  // Kita abaikan 'attributes' dan 'old' yang kompleks agar tidak error
  
  Properties({
    this.ip,
    this.userName,
    this.role,
    this.details,
  });

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        ip: json["ip"]?.toString(),
        userName: json["user_name"]?.toString(),
        role: json["role"]?.toString(),
        details: json["details"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "ip": ip,
        "user_name": userName,
        "role": role,
        "details": details,
      };
}