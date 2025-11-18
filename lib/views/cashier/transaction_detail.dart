import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/views/cashier/cashier_model.dart';

class TransactionDetailPage extends StatefulWidget {
  final List<CartItem> cartItems;
  const TransactionDetailPage({super.key, required this.cartItems});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  PaymentMethod _selectedPayment = PaymentMethod.cash;
  late List<CartItem> _currentCart;

  @override
  void initState() {
    super.initState();
    _currentCart = List.from(widget.cartItems); // Buat salinan
  }

  // --- LOGIKA PERHITUNGAN ---
  double _calculateSubtotal() {
    return _currentCart.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  double _calculateTax(double subtotal) {
    return subtotal * 0.08; // Contoh pajak 8%
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      _currentCart[index].quantity += change;
      if (_currentCart[index].quantity <= 0) {
        _currentCart.removeAt(index);
      }
      // Jika keranjang kosong, kembali ke halaman sebelumnya
      if (_currentCart.isEmpty) {
        context.pop();
      }
    });
  }

  void _confirmPayment() {
    final subtotal = _calculateSubtotal();
    final tax = _calculateTax(subtotal);
    final total = subtotal + tax;

    // Buat objek transaksi
    final transaction = Transaction(
      id: 'TXN${DateTime.now().millisecondsSinceEpoch}',
      items: _currentCart,
      subtotal: subtotal,
      tax: tax,
      total: total,
      paymentMethod: _selectedPayment,
      transactionType: 'Non-Prescription', // TODO: Sesuaikan ini
      timestamp: DateTime.now(),
    );

    // Gunakan pushReplacementNamed agar tidak bisa kembali ke checkout
    context.pushReplacementNamed(
      'Receipt',
      extra: transaction, // Kirim data transaksi ke halaman resep
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final subtotal = _calculateSubtotal();
    final tax = _calculateTax(subtotal);
    final total = subtotal + tax;
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Daftar Item
                  Text('Items in Cart', style: textTheme.titleLarge),
                  SizedBox(height: 8),
                  _buildCartItemList(textTheme, currencyFormat),
                  SizedBox(height: 24),

                  // 2. Ringkasan Pembayaran
                  Text('Payment Summary', style: textTheme.titleLarge),
                  SizedBox(height: 8),
                  _buildTotalSummary(
                    textTheme,
                    currencyFormat,
                    subtotal,
                    tax,
                    total,
                  ),
                  SizedBox(height: 24),

                  // 3. Metode Pembayaran
                  Text('Payment Method', style: textTheme.titleLarge),
                  SizedBox(height: 8),
                  _buildPaymentMethod(context),
                ],
              ),
            ),
          ),
          // Tombol Konfirmasi Pembayaran
          _buildConfirmButton(context, textTheme, currencyFormat, total),
        ],
      ),
    );
  }

  Widget _buildCartItemList(TextTheme textTheme, NumberFormat currencyFormat) {
    return Card(
      child: ListView.separated(
        itemCount: _currentCart.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        separatorBuilder: (context, index) =>
            Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final item = _currentCart[index];
          return ListTile(
            title: Text(item.product.name, style: textTheme.bodyLarge),
            subtitle: Text(
              '${currencyFormat.format(item.product.price)} x ${item.quantity}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: Config.errorRed,
                  ),
                  onPressed: () => _updateQuantity(index, -1),
                ),
                Text(item.quantity.toString(), style: textTheme.bodyLarge),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: Config.successGreen,
                  ),
                  onPressed: () => _updateQuantity(index, 1),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTotalSummary(
    TextTheme textTheme,
    NumberFormat currencyFormat,
    double subtotal,
    double tax,
    double total,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSummaryRow(
              'Subtotal',
              currencyFormat.format(subtotal),
              textTheme.bodyMedium!,
            ),
            SizedBox(height: 8),
            _buildSummaryRow('Tax (8%)', currencyFormat.format(tax), textTheme.bodySmall!),
            Divider(height: 24),
            _buildSummaryRow(
              'Total',
              currencyFormat.format(total),
              textTheme.titleLarge!.copyWith(color: Config.primaryGreen),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, TextStyle style) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(amount, style: style),
      ],
    );
  }

  Widget _buildPaymentMethod(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChoiceChip(
              label: Text('Cash'),
              avatar: Icon(
                Icons.money_outlined,
                color: _selectedPayment == PaymentMethod.cash
                    ? Config.primaryGreen
                    : Config.textSecondary,
              ),
              selected: _selectedPayment == PaymentMethod.cash,
              onSelected: (selected) {
                setState(() => _selectedPayment = PaymentMethod.cash);
              },
              selectedColor: Config.primaryGreen.withOpacity(0.1),
            ),
            ChoiceChip(
              label: Text('Card'),
              avatar: Icon(
                Icons.credit_card_outlined,
                color: _selectedPayment == PaymentMethod.card
                    ? Config.primaryGreen
                    : Config.textSecondary,
              ),
              selected: _selectedPayment == PaymentMethod.card,
              onSelected: (selected) {
                setState(() => _selectedPayment = PaymentMethod.card);
              },
              selectedColor: Config.primaryGreen.withOpacity(0.1),
            ),
            ChoiceChip(
              label: Text('e-Wallet'),
              avatar: Icon(
                Icons.qr_code_scanner_outlined,
                color: _selectedPayment == PaymentMethod.eWallet
                    ? Config.primaryGreen
                    : Config.textSecondary,
              ),
              selected: _selectedPayment == PaymentMethod.eWallet,
              onSelected: (selected) {
                setState(() => _selectedPayment = PaymentMethod.eWallet);
              },
              selectedColor: Config.primaryGreen.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton(
    BuildContext context,
    TextTheme textTheme,
    NumberFormat currencyFormat,
    double total,
  ) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Payment', style: textTheme.bodyMedium),
              Text(
                currencyFormat.format(total),
                style: textTheme.headlineMedium?.copyWith(
                  color: Config.primaryGreen,
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.check_circle_outline),
            label: Text('Confirm Payment'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: _confirmPayment,
          ),
        ],
      ),
    );
  }
}
