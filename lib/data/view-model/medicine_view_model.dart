class MedicineViewModel {
  final String? medicineId;
  final String medicineName;
  final String sku;
  final String categoryId;
  final String supplierId;
  final int stock;
  final double price;
  final String expiredDate;

  MedicineViewModel({
    this.medicineId,
    required this.medicineName,
    required this.sku,
    required this.categoryId,
    required this.supplierId,
    required this.stock,
    required this.price,
    required this.expiredDate,
  });

  Map<String, dynamic> toJson() => {
    if (medicineId != null) "id": medicineId,
    "medicine_name": medicineName,
    "sku": sku,
    "category_id": categoryId,
    "supplier_id": supplierId,
    "stock": stock,
    "price": price,
    "expired_date": expiredDate,
  };
}
