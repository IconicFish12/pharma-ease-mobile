// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineModel _$MedicineModelFromJson(Map<String, dynamic> json) =>
    MedicineModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MedicineModelToJson(MedicineModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'meta': instance.meta,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: json['id'] as String?,
  medicineName: json['medicineName'] as String?,
  sku: json['sku'] as String?,
  stock: (json['stock'] as num?)?.toInt(),
  expiredDate: json['expiredDate'] as String?,
  price: json['price'] as String?,
  category: json['category'] == null
      ? null
      : Category.fromJson(json['category'] as Map<String, dynamic>),
  suplier: json['suplier'] == null
      ? null
      : Suplier.fromJson(json['suplier'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'medicineName': instance.medicineName,
  'sku': instance.sku,
  'stock': instance.stock,
  'expiredDate': instance.expiredDate,
  'price': instance.price,
  'category': instance.category,
  'suplier': instance.suplier,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
  id: json['id'] as String?,
  categoryName: json['categoryName'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
  'id': instance.id,
  'categoryName': instance.categoryName,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

Suplier _$SuplierFromJson(Map<String, dynamic> json) => Suplier(
  id: json['id'] as String?,
  supplierName: json['supplierName'] as String?,
  contactPerson: json['contactPerson'] as String?,
  phone: json['phone'],
  address: json['address'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$SuplierToJson(Suplier instance) => <String, dynamic>{
  'id': instance.id,
  'supplierName': instance.supplierName,
  'contactPerson': instance.contactPerson,
  'phone': instance.phone,
  'address': instance.address,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  perPage: (json['per_page'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'per_page': instance.perPage,
  'total': instance.total,
};
