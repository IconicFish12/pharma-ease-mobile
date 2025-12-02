// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine_order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MedicineOrderModel _$MedicineOrderModelFromJson(Map<String, dynamic> json) =>
    MedicineOrderModel(
      status: json['status'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MedicineOrderModelToJson(MedicineOrderModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
  orderId: json['order_id'] as String?,
  orderCode: json['order_code'] as String?,
  transactionDate: json['transaction_date'] == null
      ? null
      : DateTime.parse(json['transaction_date'] as String),
  statusLabel: json['status_label'] as String?,
  totalAmountFormatted: json['total_amount_formatted'] as String?,
  cashier: json['cashier'] == null
      ? null
      : Cashier.fromJson(json['cashier'] as Map<String, dynamic>),
  supplier: json['supplier'] == null
      ? null
      : Supplier.fromJson(json['supplier'] as Map<String, dynamic>),
  items: (json['items'] as List<dynamic>?)
      ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
  'order_id': instance.orderId,
  'order_code': instance.orderCode,
  'transaction_date': instance.transactionDate?.toIso8601String(),
  'status_label': instance.statusLabel,
  'total_amount_formatted': instance.totalAmountFormatted,
  'cashier': instance.cashier,
  'supplier': instance.supplier,
  'items': instance.items,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

Cashier _$CashierFromJson(Map<String, dynamic> json) => Cashier(
  id: json['id'] as String?,
  name: json['name'] as String?,
  empId: json['emp_id'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  shift: json['shift'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  address: json['address'] as String?,
  salary: json['salary'] as String?,
  startDate: json['start_date'] as String?,
  avatar: json['avatar'],
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$CashierToJson(Cashier instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'emp_id': instance.empId,
  'email': instance.email,
  'role': instance.role,
  'shift': instance.shift,
  'date_of_birth': instance.dateOfBirth,
  'address': instance.address,
  'salary': instance.salary,
  'start_date': instance.startDate,
  'avatar': instance.avatar,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
  medicineId: json['medicine_id'] as String?,
  medicineName: json['medicine_name'] as String?,
  sku: json['sku'] as String?,
  quantityOrdered: (json['quantity_ordered'] as num?)?.toInt(),
  pricePerUnit: (json['price_per_unit'] as num?)?.toInt(),
  subtotal: (json['subtotal'] as num?)?.toInt(),
);

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'medicine_id': instance.medicineId,
  'medicine_name': instance.medicineName,
  'sku': instance.sku,
  'quantity_ordered': instance.quantityOrdered,
  'price_per_unit': instance.pricePerUnit,
  'subtotal': instance.subtotal,
};

Supplier _$SupplierFromJson(Map<String, dynamic> json) => Supplier(
  id: json['id'] as String?,
  supplierName: json['supplierName'] as String?,
  contactPerson: json['contactPerson'] as String?,
  phone: json['phone'],
  address: json['address'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
  'id': instance.id,
  'supplierName': instance.supplierName,
  'contactPerson': instance.contactPerson,
  'phone': instance.phone,
  'address': instance.address,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};
