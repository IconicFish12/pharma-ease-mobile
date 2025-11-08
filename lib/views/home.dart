import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class FeatureItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  FeatureItem({required this.icon, required this.label, required this.onTap});
}

class ExpiryItem {
  final String name;
  final String dose;
  final int daysLeft;

  ExpiryItem({required this.name, required this.dose, required this.daysLeft});
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Daftar fitur utama untuk menu ikon
    final List<FeatureItem> features = [
      FeatureItem(
        icon: Icons.inventory_2_outlined,
        label: 'Inventory',
        onTap: () {
          context.pushNamed('MedicineInventory');
        },
      ),
      FeatureItem(
        icon: Icons.point_of_sale_outlined,
        label: 'Cashier',
        onTap: () {
          context.pushNamed('Cashier');
        },
      ),
      FeatureItem(
        icon: Icons.receipt_long_outlined,
        label: 'Summary',
        onTap: () {
          context.pushNamed('TransactionSummary');
        },
      ),
      FeatureItem(
        icon: Icons.assessment_outlined,
        label: 'Finance',
        onTap: () {
          context.pushNamed('FinancialReport');
        },
      ),
      FeatureItem(
        icon: Icons.medication_outlined,
        label: 'Medicine',
        onTap: () {},
      ),
      FeatureItem(
        icon: Icons.summarize_outlined,
        label: 'All Report',
        onTap: () {
          context.pushNamed('Reports');
        },
      ),
      FeatureItem(
        icon: Icons.local_shipping_outlined,
        label: 'Suppliers',
        onTap: () {
          context.pushNamed('MedicineSupplier');
        },
      ),
      FeatureItem(
        icon: Icons.history_outlined,
        label: 'Activity Log',
        onTap: () {
          context.pushNamed('ActivityLog');
        },
      ),
      FeatureItem(
        icon: Icons.add_shopping_cart_outlined,
        label: 'Order',
        onTap: () {
          context.pushNamed('SuppliersOrder');
        },
      ),
      FeatureItem(
        icon: Icons.people_alt_outlined,
        label: 'Users',
        onTap: () {
          context.pushNamed('UserManage');
        },
      ),
    ];

    // Daftar obat bohongan untuk contoh
    final List<ExpiryItem> expiringMedicines = [
      ExpiryItem(name: 'Paracetamol', dose: '500mg', daysLeft: 26),
      ExpiryItem(name: 'Amoxicillin', dose: '250mg', daysLeft: 31),
      ExpiryItem(name: 'Ibuprofen', dose: '400mg', daysLeft: 46),
      ExpiryItem(name: 'Ciprofloxacin', dose: '500mg', daysLeft: 51),
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: Config.primaryGreen),
            SizedBox(width: 8),
            Text('Pharma Ease'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Config.accentBlue,
              child: Text(
                'H',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: textTheme.headlineLarge),
            SizedBox(height: 4),
            Text(
              'Manage your pharmacy operations efficiently',
              style: textTheme.bodyMedium,
            ),
            SizedBox(height: 24),

            // 1. Kartu Ringkasan
            _buildSummarySection(),

            SizedBox(height: 24),

            // 2. Menu Fitur Utama (Perubahan Utama)
            Text('Main Features', style: textTheme.headlineMedium),
            SizedBox(height: 16),
            _buildFeaturesGrid(context, features),

            SizedBox(height: 24),

            // 3. Placeholder Grafik
            Text('Sales Trend', style: textTheme.headlineMedium),
            SizedBox(height: 16),
            _buildGraphPlaceholder(context),

            SizedBox(height: 24),

            // 4. Obat Mendekati Kedaluwarsa
            Text('Medicines Nearing Expiry', style: textTheme.headlineMedium),
            SizedBox(height: 16),
            _buildExpiryList(context, expiringMedicines),
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian ringkasan (4 kartu)
  Widget _buildSummarySection() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildSummaryCard(
          title: 'Total Medicines',
          value: '1,284',
          change: '+12% from last month',
          icon: Icons.inventory_2_outlined,
          iconColor: Colors.blueGrey,
        ),
        _buildSummaryCard(
          title: 'Low Stock Items',
          value: '23',
          change: 'Requires immediate attention',
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
        ),
        _buildSummaryCard(
          title: 'Total Revenue',
          value: '\$186,450',
          change: '+18% from last month',
          icon: Icons.attach_money_rounded,
          iconColor: Config.successGreen,
        ),
        _buildSummaryCard(
          title: 'Total Transactions',
          value: '1,745',
          change: '+7% from last month',
          icon: Icons.shopping_cart_outlined,
          iconColor: Config.accentBlue,
        ),
      ],
    );
  }

  // Widget untuk satu kartu ringkasan
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color iconColor,
  }) {
    return Builder(
      builder: (context) {
        final textTheme = Theme.of(context).textTheme;
        return Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: iconColor, size: 28),
                SizedBox(height: 8),
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(value, style: textTheme.headlineMedium,
                ),
                SizedBox(height: 4),
                Text(
                  change,
                  style: textTheme.bodyMedium?.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget untuk grid fitur utama
  Widget _buildFeaturesGrid(BuildContext context, List<FeatureItem> features) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return _buildFeatureButton(
          context: context,
          icon: feature.icon,
          label: feature.label,
          onTap: feature.onTap,
        );
      },
    );
  }

  // Widget untuk satu tombol fitur
  Widget _buildFeatureButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Config.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Config.primaryGreen, size: 28),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: textTheme.labelSmall,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget untuk placeholder grafik
  Widget _buildGraphPlaceholder(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.all(16),
        width: double.infinity,
        height: 200,
        child: Center(
          child: Text(
            'Line Chart Placeholder',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }

  // Widget untuk daftar obat kedaluwarsa
  Widget _buildExpiryList(BuildContext context, List<ExpiryItem> items) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2.0,
          child: ListTile(
            leading: Icon(Icons.warning_amber_rounded, color: Config.errorRed),
            title: Text(
              item.name,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(item.dose, style: textTheme.bodyMedium),
            trailing: Text(
              'Expires: ${item.daysLeft} days left',
              style: textTheme.bodyMedium?.copyWith(
                color: Config.errorRed,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 8),
    );
  }
}
