class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}
class Transaction {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double total;
  final DateTime timestamp;
  String? cashierName;

  Transaction({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.total,
    required this.timestamp,
    this.cashierName
  });
}
