import 'package:intl/intl.dart';
// Sesuaikan path import ini dengan struktur folder kamu
import '../../../data/model/medicine_order_model.dart'; 
import '../Model/order_model.dart'; 

extension DatumToDomain on Datum {
  Order toDomain() {
    final DateTime trxDate = transactionDate ?? DateTime.now();

    // Logic +7 hari DIHAPUS

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
      // Assignment expectedDeliveryDate DIHAPUS
      
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
      case 'successful': // Handle variasi string API
      case 'completed':
        return OrderStatus.completed;
      case 'failed':
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }
}