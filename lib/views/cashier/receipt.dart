// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';
// import 'package:mobile_course_fp/config/config.dart';
// import 'package:mobile_course_fp/views/cashier/Model/cashier_model.dart';

// class ReceiptPage extends StatelessWidget {
//   final Transaction transaction;
//   const ReceiptPage({super.key, required this.transaction});

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final currencyFormat =
//         NumberFormat.currency(locale: 'en_US', symbol: '\$');

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Transaction Receipt'),
//         // Sembunyikan tombol kembali
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Konten Resep (Struk)
//             Container(
//               padding: const EdgeInsets.all(24.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header
//                   Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           'PHARMACARE PLUS',
//                           style: textTheme.titleLarge
//                               ?.copyWith(fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           '123 Medical Street, Health City',
//                           style: textTheme.bodyMedium,
//                         ),
//                         Text(
//                           'Tel: (555) 123-4567',
//                           style: textTheme.bodyMedium,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(height: 32),
//                   _buildReceiptRow('Transaction ID:', transaction.id, textTheme),
//                   _buildReceiptRow('Date:', DateFormat('dd/MM/yyyy').format(transaction.timestamp), textTheme),
//                   _buildReceiptRow('Time:', DateFormat('HH:mm:ss').format(transaction.timestamp), textTheme),
//                   _buildReceiptRow('Type:', transaction.transactionType, textTheme),
//                   _buildReceiptRow('Payment:', transaction.paymentMethod.name.toUpperCase(), textTheme),
//                   Divider(height: 32),
//                   Text('Items Purchased', style: textTheme.titleLarge),
//                   SizedBox(height: 8),
//                   ListView.builder(
//                     itemCount: transaction.items.length,
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       final item = transaction.items[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 4.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 '${item.product.name}\n${item.quantity} x ${currencyFormat.format(item.product.price)}',
//                                 style: textTheme.bodyMedium,
//                               ),
//                             ),
//                             Text(
//                               currencyFormat.format(item.totalPrice),
//                               style: textTheme.bodyMedium
//                                   ?.copyWith(fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                   Divider(height: 32),
//                   _buildReceiptRow('Subtotal:', currencyFormat.format(transaction.subtotal), textTheme, isBold: true),
//                   _buildReceiptRow('Tax (8%):', currencyFormat.format(transaction.tax), textTheme, isBold: true),
//                   SizedBox(height: 8),
//                   _buildReceiptRow('Total:', currencyFormat.format(transaction.total), textTheme, isTotal: true),
//                   Divider(height: 32),
//                   Center(
//                     child: Text(
//                       'Thank you for your purchase!\nPlease keep this receipt for your records.',
//                       style: textTheme.bodyMedium?.copyWith(color: Config.textSecondary),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 24),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     icon: Icon(Icons.print_outlined),
//                     label: Text('Print Receipt'),
//                     onPressed: () {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Print logic not implemented yet.')),
//                       );
//                     },
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton.icon(
//                     icon: Icon(Icons.add_shopping_cart),
//                     label: Text('New Transaction'),
//                     onPressed: () {
//                       context.goNamed('Cashier');
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReceiptRow(String label, String value, TextTheme textTheme, {bool isBold = false, bool isTotal = false}) {
//     final style = isTotal
//         ? textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Config.primaryGreen)
//         : (isBold ? textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold) : textTheme.bodyMedium);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: style),
//           Text(value, style: style),
//         ],
//       ),
//     );
//   }
// }