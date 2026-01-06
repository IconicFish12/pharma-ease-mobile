class Product {
final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}


enum PaymentMethod { cash, card, eWallet }

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
  final double tax;
  final double total;
  final PaymentMethod paymentMethod;
  final String transactionType;
  final DateTime timestamp;
  String? cashierName;

  Transaction({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.transactionType,
    required this.timestamp,
    this.cashierName
  });
}