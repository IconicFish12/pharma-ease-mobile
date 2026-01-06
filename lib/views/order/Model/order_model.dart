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
    required this.items,
    this.status = OrderStatus.pending,
  });

  int get totalItemsOrdered {
    return items.fold(0, (sum, item) => sum + item.amount);
  }

  double get totalAmount {
    return items.fold(0, (sum, item) => sum + (item.price * item.amount));
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.yellow;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return "Pending";
      case OrderStatus.completed:
        return "Successful";
      case OrderStatus.cancelled:
        return "Failed";
    }
  }
}

enum OrderStatus {
  pending,
  completed,
  cancelled,
}

class OrderItem {
  final String name;
  final double price;
  final int amount; 

  OrderItem({
    required this.name,
    required this.price,
    required this.amount,
  });

  // Catalog static tetap ada
  static List<OrderItem> catalog = [
    OrderItem(name: "Paracetamol 500mg", price: 5000, amount: 0),
    OrderItem(name: "Amoxicillin 500mg", price: 12000, amount: 0),
    OrderItem(name: "Ibuprofen 400mg", price: 8500, amount: 0),
    OrderItem(name: "Vitamin C 1000mg", price: 15000, amount: 0),
    OrderItem(name: "Omeprazole 20mg", price: 25000, amount: 0),
    OrderItem(name: "Cetirizine 10mg", price: 3000, amount: 0),
  ];
}