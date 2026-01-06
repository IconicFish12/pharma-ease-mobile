import 'package:intl/intl.dart';
import '../../../data/model/medicine_order_model.dart'; 
import '../Model/order_model.dart'; 

extension DatumToDomain on Datum {
  Order toDomain() {
    final DateTime trxDate = transactionDate ?? DateTime.now();


    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');

    return Order(
      id: orderId ?? '-',
      suppliersName: supplier?.supplierName ?? 'Unknown Supplier',
      contactPerson: supplier?.contactPerson ?? '-',
      address: supplier?.address ?? '-',
      email: '-', 
      phoneNumber: supplier?.phone?.toString() ?? '-',
      whatsappNumber: '-', 
      
      orderDate: formatter.format(trxDate),
      
      status: _mapStatus(statusLabel),
      
      items: items?.map((apiItem) => OrderItem(
        name: apiItem.medicineName ?? 'Unknown Item',
        price: (apiItem.pricePerUnit ?? 0).toDouble(),
        amount: apiItem.quantityOrdered ?? 0,
      )).toList() ?? [],
    );
  }

  OrderStatus _mapStatus(String? label) {
    if (label == null) return OrderStatus.pending;
    switch (label.toLowerCase()) {
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }
}