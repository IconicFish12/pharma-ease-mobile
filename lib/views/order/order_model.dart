import 'package:flutter/material.dart';

class Order {
  final String id;
  String suppliersName;
  String contactPerson;
  String email;
  String phoneNumber;
  String whatsappNumber;
  String address;
  String orderDate;
  String expectedDeliveryDate;
  OrderStatus status;

  List<OrderItem> items;

  Order({
    required this.id,
    required this.suppliersName,
    required this.contactPerson,
    required this.email,
    required this.phoneNumber,
    required this.whatsappNumber,
    required this.address,
    required this.orderDate,
    required this.expectedDeliveryDate,
    required this.items,
    this.status = OrderStatus.pending,
  });

  int get totalItemsOrdered {
    return items.fold(0, (sum, item) => sum + item.amount);
  }

  int get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.price * item.amount));
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.yellow;
      case OrderStatus.successful:
        return Colors.green;
      case OrderStatus.failed:
        return Colors.red;
    }
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return "Pending";
      case OrderStatus.successful:
        return "Successful";
      case OrderStatus.failed:
        return "Failed";
    }
  }
}

enum OrderStatus {
  pending,
  successful,
  failed,
}

class OrderItem {
  final String name;
  final int price;
  final int amount;

  OrderItem({
    required this.name,
    required this.price,
    required this.amount,
  });
}
