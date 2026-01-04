// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityLogModel _$ActivityLogModelFromJson(Map<String, dynamic> json) =>
    ActivityLogModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityLogModelToJson(ActivityLogModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
  currentPage: (json['current_page'] as num?)?.toInt(),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
      .toList(),
  firstPageUrl: json['first_page_url'] as String?,
  from: (json['from'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  lastPageUrl: json['last_page_url'] as String?,
  links: (json['links'] as List<dynamic>?)
      ?.map((e) => Link.fromJson(e as Map<String, dynamic>))
      .toList(),
  nextPageUrl: json['next_page_url'] as String?,
  path: json['path'] as String?,
  perPage: (json['per_page'] as num?)?.toInt(),
  prevPageUrl: json['prev_page_url'],
  to: (json['to'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
  'current_page': instance.currentPage,
  'data': instance.data,
  'first_page_url': instance.firstPageUrl,
  'from': instance.from,
  'last_page': instance.lastPage,
  'last_page_url': instance.lastPageUrl,
  'links': instance.links,
  'next_page_url': instance.nextPageUrl,
  'path': instance.path,
  'per_page': instance.perPage,
  'prev_page_url': instance.prevPageUrl,
  'to': instance.to,
  'total': instance.total,
};

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  id: (json['id'] as num?)?.toInt(),
  logName: json['log_name'] as String?,
  description: $enumDecodeNullable(_$DescriptionEnumMap, json['description']),
  subjectType: json['subject_type'] as String?,
  subjectId: json['subject_id'] as String?,
  causerType: $enumDecodeNullable(_$CauserTypeEnumMap, json['causer_type']),
  causerId: json['causer_id'] as String?,
  properties: json['properties'] == null
      ? null
      : Properties.fromJson(json['properties'] as Map<String, dynamic>),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  event: json['event'] as String?,
  batchUuid: json['batch_uuid'],
  causer: json['causer'] == null
      ? null
      : Causer.fromJson(json['causer'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'id': instance.id,
  'log_name': instance.logName,
  'description': _$DescriptionEnumMap[instance.description],
  'subject_type': instance.subjectType,
  'subject_id': instance.subjectId,
  'causer_type': _$CauserTypeEnumMap[instance.causerType],
  'causer_id': instance.causerId,
  'properties': instance.properties,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'event': instance.event,
  'batch_uuid': instance.batchUuid,
  'causer': instance.causer,
};

const _$DescriptionEnumMap = {
  Description.CREATED: 'Created',
  Description.LOGIN: 'Login',
  Description.UPDATED: 'Updated',
};

const _$CauserTypeEnumMap = {CauserType.APP_MODELS_USER: 'App\\Models\\User'};

Causer _$CauserFromJson(Map<String, dynamic> json) => Causer(
  userId: json['user_id'] as String?,
  name: $enumDecodeNullable(_$NameEnumMap, json['name']),
  empId: $enumDecodeNullable(_$EmpIdEnumMap, json['emp_id']),
  email: $enumDecodeNullable(_$EmailEnumMap, json['email']),
  emailVerifiedAt: json['email_verified_at'] == null
      ? null
      : DateTime.parse(json['email_verified_at'] as String),
  role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
  shift: $enumDecodeNullable(_$ShiftEnumMap, json['shift']),
  dateOfBirth: json['date_of_birth'] == null
      ? null
      : DateTime.parse(json['date_of_birth'] as String),
  alamat: $enumDecodeNullable(_$AlamatEnumMap, json['alamat']),
  profileAvatar: json['profile_avatar'],
  salary: (json['salary'] as num?)?.toInt(),
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  lastLoginAt: json['last_login_at'],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$CauserToJson(Causer instance) => <String, dynamic>{
  'user_id': instance.userId,
  'name': _$NameEnumMap[instance.name],
  'emp_id': _$EmpIdEnumMap[instance.empId],
  'email': _$EmailEnumMap[instance.email],
  'email_verified_at': instance.emailVerifiedAt?.toIso8601String(),
  'role': _$RoleEnumMap[instance.role],
  'shift': _$ShiftEnumMap[instance.shift],
  'date_of_birth': instance.dateOfBirth?.toIso8601String(),
  'alamat': _$AlamatEnumMap[instance.alamat],
  'profile_avatar': instance.profileAvatar,
  'salary': instance.salary,
  'start_date': instance.startDate?.toIso8601String(),
  'last_login_at': instance.lastLoginAt,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$NameEnumMap = {Name.PROF_ALEC_BEAHAN_DDS: 'Prof. Alec Beahan DDS'};

const _$EmpIdEnumMap = {EmpId.EMP_51414: 'EMP-51414'};

const _$EmailEnumMap = {
  Email.JEFFEREY95_LEUSCHKE_ORG: 'jefferey95@leuschke.org',
};

const _$RoleEnumMap = {Role.OWNER: 'owner'};

const _$ShiftEnumMap = {Shift.MALAM: 'malam'};

const _$AlamatEnumMap = {
  Alamat.THE_561_DU_BUQUE_MOUNT_NORAMOUTH_AR_065386064:
      '561 DuBuque Mount\nNoramouth, AR 06538-6064',
};

Properties _$PropertiesFromJson(Map<String, dynamic> json) => Properties(
  ip: $enumDecodeNullable(_$IpEnumMap, json['ip']),
  userName: $enumDecodeNullable(_$NameEnumMap, json['user_name']),
  role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
  details: $enumDecodeNullable(_$DetailsEnumMap, json['details']),
  attributes: json['attributes'] == null
      ? null
      : Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
  old: json['old'] == null
      ? null
      : Old.fromJson(json['old'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PropertiesToJson(Properties instance) =>
    <String, dynamic>{
      'ip': _$IpEnumMap[instance.ip],
      'user_name': _$NameEnumMap[instance.userName],
      'role': _$RoleEnumMap[instance.role],
      'details': _$DetailsEnumMap[instance.details],
      'attributes': instance.attributes,
      'old': instance.old,
    };

const _$IpEnumMap = {Ip.THE_127001: '127.0.0.1'};

const _$DetailsEnumMap = {
  Details.CREATED_NEW_DATA: 'Created new data: #',
  Details.SUCCESSFUL_LOGIN: 'Successful login',
  Details.UPDATED_DATA: 'Updated data: #',
};

Attributes _$AttributesFromJson(Map<String, dynamic> json) => Attributes(
  salesId: json['sales_id'] as String?,
  kodePenjualan: json['kode_penjualan'] as String?,
  userId: json['user_id'] as String?,
  transactionDate: json['transaction_date'] == null
      ? null
      : DateTime.parse(json['transaction_date'] as String),
  totalPrice: (json['total_price'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  medicineId: json['medicine_id'] as String?,
  quantity: (json['quantity'] as num?)?.toInt(),
  unitPrice: (json['unit_price'] as num?)?.toInt(),
  subtotal: (json['subtotal'] as num?)?.toInt(),
  stock: (json['stock'] as num?)?.toInt(),
);

Map<String, dynamic> _$AttributesToJson(Attributes instance) =>
    <String, dynamic>{
      'sales_id': instance.salesId,
      'kode_penjualan': instance.kodePenjualan,
      'user_id': instance.userId,
      'transaction_date': instance.transactionDate?.toIso8601String(),
      'total_price': instance.totalPrice,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'medicine_id': instance.medicineId,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'subtotal': instance.subtotal,
      'stock': instance.stock,
    };

Old _$OldFromJson(Map<String, dynamic> json) => Old(
  stock: (json['stock'] as num?)?.toInt(),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  transactionDate: json['transaction_date'] == null
      ? null
      : DateTime.parse(json['transaction_date'] as String),
  totalPrice: (json['total_price'] as num?)?.toInt(),
);

Map<String, dynamic> _$OldToJson(Old instance) => <String, dynamic>{
  'stock': instance.stock,
  'updated_at': instance.updatedAt?.toIso8601String(),
  'transaction_date': instance.transactionDate?.toIso8601String(),
  'total_price': instance.totalPrice,
};

Link _$LinkFromJson(Map<String, dynamic> json) => Link(
  url: json['url'] as String?,
  label: json['label'] as String?,
  page: (json['page'] as num?)?.toInt(),
  active: json['active'] as bool?,
);

Map<String, dynamic> _$LinkToJson(Link instance) => <String, dynamic>{
  'url': instance.url,
  'label': instance.label,
  'page': instance.page,
  'active': instance.active,
};
