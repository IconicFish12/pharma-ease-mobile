// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuppliersModel _$SuppliersModelFromJson(Map<String, dynamic> json) =>
    SuppliersModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SuppliersModelToJson(SuppliersModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
      'meta': instance.meta,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: json['id'] as String?,
  supplierName: json['supplierName'] as String?,
  contactPerson: json['contactPerson'] as String?,
  phone: json['phone'],
  address: json['address'] as String?,
  createdAt: $enumDecodeNullable(_$AtedAtEnumMap, json['createdAt']),
  updatedAt: $enumDecodeNullable(_$AtedAtEnumMap, json['updatedAt']),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'supplierName': instance.supplierName,
  'contactPerson': instance.contactPerson,
  'phone': instance.phone,
  'address': instance.address,
  'createdAt': _$AtedAtEnumMap[instance.createdAt],
  'updatedAt': _$AtedAtEnumMap[instance.updatedAt],
};

const _$AtedAtEnumMap = {AtedAt.THE_3_HARI_YANG_LALU: '3 hari yang lalu'};

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
