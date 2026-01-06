import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/views/cashier/Model/cashier_model.dart';

class TransactionSummary extends StatefulWidget {
  const TransactionSummary({super.key});

  @override
  State<TransactionSummary> createState() => _TransactionSummaryState();
}

class _TransactionSummaryState extends State<TransactionSummary> {
  // --- Data Dummy ---
  // (Data ini akan digunakan untuk mengisi list dan filter)
  final List<Transaction> _allTransactions = [
    // Data dummy (gunakan model Transaction yang sudah diperbarui)
    Transaction(
      id: 'TXN-20251020-001',
      items: [
        CartItem(
          product: Product(
            id: 'P001',
            name: 'Paracetamol 500mg',
            price: 5.99,
            imageUrl: '',
          ),
          quantity: 2,
        ),
      ],
      subtotal: 11.98,
      tax: 0.96,
      total: 12.94,
      paymentMethod: PaymentMethod.cash,
      transactionType: 'Non-Prescription',
      timestamp: DateTime(2025, 10, 20, 9, 15),
      cashierName: 'Mike Davis',
    ),
    Transaction(
      id: 'TXN-20251020-002',
      items: [
        CartItem(
          product: Product(
            id: 'P002',
            name: 'Amoxicillin 250mg',
            price: 12.50,
            imageUrl: '',
          ),
          quantity: 1,
        ),
        CartItem(
          product: Product(
            id: 'P003',
            name: 'Ibuprofen 400mg',
            price: 8.75,
            imageUrl: '',
          ),
          quantity: 2,
        ),
      ],
      subtotal: 30.00,
      tax: 2.40,
      total: 32.40,
      paymentMethod: PaymentMethod.card,
      transactionType: 'Prescription',
      timestamp: DateTime(2025, 10, 20, 9, 45),
      cashierName: 'Robert Wilson',
    ),
    Transaction(
      id: 'TXN-20251020-003',
      items: [
        CartItem(
          product: Product(
            id: 'P005',
            name: 'Loratadine 10mg',
            price: 7.20,
            imageUrl: '',
          ),
          quantity: 3,
        ),
      ],
      subtotal: 21.60,
      tax: 1.73,
      total: 23.33,
      paymentMethod: PaymentMethod.eWallet,
      transactionType: 'Non-Prescription',
      timestamp: DateTime(2025, 10, 20, 10, 30),
      cashierName: 'Mike Davis',
    ),
    // ... (Tambahkan lebih banyak data dummy jika perlu)
  ];

  final List<String> _cashiers = [
    'All Cashiers',
    'Mike Davis',
    'Robert Wilson',
  ];

  // --- State Variables ---
  late List<Transaction> _filteredTransactions;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedCashier = 'All Cashiers';
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _filteredTransactions = _allTransactions;
    _searchController.addListener(_filterTransactions);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTransactions);
    _searchController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // --- Logika Filter ---
  void _filterTransactions() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions = _allTransactions.where((tx) {
        // 1. Filter by Search Query
        final searchMatch =
            searchQuery.isEmpty ||
            tx.id.toLowerCase().contains(searchQuery) ||
            tx.cashierName!.toLowerCase().contains(searchQuery) ||
            tx.items.any(
              (item) => item.product.name.toLowerCase().contains(searchQuery),
            );

        // 2. Filter by Cashier
        final cashierMatch =
            _selectedCashier == 'All Cashiers' ||
            tx.cashierName == _selectedCashier;

        // 3. Filter by Date
        final dateMatch =
            _selectedDate == null ||
            (tx.timestamp.day == _selectedDate!.day &&
                tx.timestamp.month == _selectedDate!.month &&
                tx.timestamp.year == _selectedDate!.year);

        return searchMatch && cashierMatch && dateMatch;
      }).toList();
    });
  }

  // --- Logika Date Picker ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Config.primaryGreen,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
        _filterTransactions();
      });
    }
  }

  // --- Kalkulasi Ringkasan ---
  double get _totalRevenue {
    return _filteredTransactions.fold(0.0, (sum, tx) => sum + tx.total);
  }

  int get _totalTransactions {
    return _filteredTransactions.length;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Summary'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Daily Summary', style: textTheme.headlineMedium),
            SizedBox(height: 4),
            Text(
              'Based on current filters',
              style: textTheme.bodyMedium?.copyWith(
                color: Config.textSecondary,
              ),
            ),
            SizedBox(height: 16),
            // (PERBAIKAN) Kartu Ringkasan (Responsive)
            _buildSummaryCards(currencyFormat),
            SizedBox(height: 24),

            // Kartu Filter
            _buildFilterCard(context, textTheme),
            SizedBox(height: 24),

            // Header Daftar Transaksi
            Text('Transaction List', style: textTheme.headlineMedium),
            SizedBox(height: 16),

            // (PERBAIKAN) Daftar Transaksi (ListView, BUKAN DataTable)
            _buildTransactionList(context, textTheme, currencyFormat),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(NumberFormat currencyFormat) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _SummaryCard(
          title: 'Total Revenue',
          value: currencyFormat.format(_totalRevenue),
          icon: Icons.attach_money_rounded,
          iconColor: Config.successGreen,
        ),
        _SummaryCard(
          title: 'Total Transactions',
          value: _totalTransactions.toString(),
          icon: Icons.receipt_long_outlined,
          iconColor: Config.accentBlue,
        ),
      ],
    );
  }

  Widget _buildFilterCard(BuildContext context, TextTheme textTheme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Filter by Date',
                suffixIcon: Icon(Icons.calendar_today_outlined),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedCashier,
              decoration: InputDecoration(labelText: 'Filter by Cashier'),
              items: _cashiers
                  .map(
                    (cashier) =>
                        DropdownMenuItem(value: cashier, child: Text(cashier)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCashier = value!;
                  _filterTransactions();
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              icon: Icon(Icons.download_outlined),
              label: Text('Export Summary'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
              ),
              onPressed: () {
                // TODO: Implement Export Logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Export logic not implemented yet.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(
    BuildContext context,
    TextTheme textTheme,
    NumberFormat currencyFormat,
  ) {
    if (_filteredTransactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'No transactions found matching your filters.',
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _filteredTransactions.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final tx = _filteredTransactions[index];
        return _TransactionListItem(
          transaction: tx,
          currencyFormat: currencyFormat,
          onTap: () {
            // Navigasi ke Halaman Resep
            context.pushNamed('Receipt', extra: tx);
          },
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 32),
            SizedBox(height: 12),
            Text(
              title,
              style: textTheme.bodyMedium?.copyWith(
                color: Config.textSecondary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;

  const _TransactionListItem({
    required this.transaction,
    required this.currencyFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Config.primaryGreen.withOpacity(0.1),
          child: Icon(Icons.receipt_long, color: Config.primaryGreen),
        ),
        title: Text(
          transaction.id,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'By: ${transaction.cashierName} • ${DateFormat('dd MMM yyyy, HH:mm').format(transaction.timestamp)}',
          style: textTheme.bodyMedium,
        ),
        trailing: Text(
          currencyFormat.format(transaction.total),
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Config.primaryGreen,
          ),
        ),
      ),
    );
  }
}