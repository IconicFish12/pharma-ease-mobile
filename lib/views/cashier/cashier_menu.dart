import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/views/cashier/cashier_model.dart';

class CashierMenu extends StatefulWidget {
  const CashierMenu({super.key});

  @override
  State<CashierMenu> createState() => _CashierMenuState();
}

class _CashierMenuState extends State<CashierMenu>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<CartItem> _cartItems = [];

  // Data dummy untuk produk (gantilah dengan data dari API Anda)
  final List<Product> _products = [
    Product(
      id: 'P001',
      name: 'Paracetamol 500mg',
      price: 5.99,
      imageUrl: 'https://placehold.co/150x150/E9F6EE/356B52?text=Paracetamol',
    ),
    Product(
      id: 'P002',
      name: 'Amoxicillin 250mg',
      price: 12.50,
      imageUrl: 'https://placehold.co/150x150/E9F6EE/356B52?text=Amoxicillin',
    ),
    Product(
      id: 'P003',
      name: 'Ibuprofen 400mg',
      price: 8.75,
      imageUrl: 'https://placehold.co/150x150/E9F6EE/356B52?text=Ibuprofen',
    ),
    Product(
      id: 'P004',
      name: 'Omeprazole 20mg',
      price: 15.00,
      imageUrl: 'https://placehold.co/150x150/E9F6EE/356B52?text=Omeprazole',
    ),
    Product(
      id: 'P005',
      name: 'Loratadine 10mg',
      price: 7.20,
      imageUrl: 'https://placehold.co/150x150/E9F6EE/356B52?text=Loratadine',
    ),
    Product(
      id: 'P006',
      name: 'Aspirin 75mg',
      price: 4.50,
      imageUrl: 'https://placehold.co/150x150/E9F6EE/356B52?text=Aspirin',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- LOGIKA KERANJANG ---
  void _addToCart(Product product) {
    setState(() {
      // Cek apakah produk sudah ada di keranjang
      final index = _cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );
      if (index != -1) {
        _cartItems[index].quantity++; // Tambah jumlah
      } else {
        _cartItems.add(CartItem(product: product, quantity: 1)); // Tambah baru
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        duration: const Duration(seconds: 1),
        backgroundColor: Config.successGreen,
      ),
    );
  }

  double _calculateTotal() {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  int _calculateTotalItems() {
    return _cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cashier / POS'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Config.primaryGreen,
          unselectedLabelColor: Config.textSecondary,
          indicatorColor: Config.primaryGreen,
          tabs: const [
            Tab(icon: Icon(Icons.shopping_bag_outlined), text: 'Products'),
            Tab(icon: Icon(Icons.description_outlined), text: 'Prescription'),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Konten utama (produk dan resep)
          TabBarView(
            controller: _tabController,
            children: [
              _buildProductGrid(context),
              _buildPrescriptionForm(context),
            ],
          ),
          // Ringkasan keranjang yang mengambang
          if (_cartItems.isNotEmpty) _buildCartSummary(context, textTheme),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK TAB PRODUK (NON-RESEP) ---
  Widget _buildProductGrid(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
            // TODO: Implement search logic
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 100), // Padding di bawah
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 produk per baris
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75, // Atur rasio agar kartu pas
            ),
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return _ProductCard(
                product: product,
                onAdd: () => _addToCart(product),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- WIDGET UNTUK TAB RESEP (PRESCRIPTION) ---
  Widget _buildPrescriptionForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find Prescription',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Prescription ID',
                  hintText: 'Enter prescription ID...',
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  hintText: 'Enter patient name...',
                ),
              ),
              SizedBox(height: 24),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.search),
                  label: Text('Find Prescription'),
                  onPressed: () {
                    // TODO: Implement prescription search logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Prescription logic not implemented yet.',
                        ),
                        backgroundColor: Config.errorRed,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET UNTUK RINGKASAN KERANJANG (FLOATING) ---
  Widget _buildCartSummary(BuildContext context, TextTheme textTheme) {
    final total = _calculateTotal();
    final totalItems = _calculateTotalItems();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Card(
        elevation: 8,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$totalItems Item${totalItems > 1 ? 's' : ''}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: Config.textSecondary,
                    ),
                  ),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_US',
                      symbol: '\$',
                    ).format(total),
                    style: textTheme.headlineMedium?.copyWith(
                      color: Config.primaryGreen,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.shopping_cart_checkout),
                label: Text('View Cart'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  // Navigasi ke Halaman Detail Transaksi
                  context.pushNamed(
                    'TransactionDetail',
                    extra: _cartItems, // Kirim data keranjang
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;

  const _ProductCard({required this.product, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onAdd,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.medication_outlined)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    NumberFormat.currency(
                      locale: 'en_US',
                      symbol: '\$',
                    ).format(product.price),
                    style: textTheme.bodyMedium?.copyWith(
                      color: Config.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: OutlinedButton.icon(
                icon: Icon(Icons.add_shopping_cart, size: 16),
                label: Text('Add', style: textTheme.labelSmall),
                onPressed: onAdd,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Config.primaryGreen,
                  side: BorderSide(color: Config.primaryGreen),
                  padding: EdgeInsets.symmetric(vertical: 4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}