import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/views/suppliers/Model/suppliers_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/config.dart';

class SuppliersDetail extends StatefulWidget {
  final Supplier supplier;
  final Function(Supplier) editSupplier;
  final Function(String) onDelete;

  const SuppliersDetail({
    super.key,
    required this.supplier,
    required this.editSupplier,
    required this.onDelete,
  });

  @override
  State<SuppliersDetail> createState() => _SuppliersDetailState();
}

class _SuppliersDetailState extends State<SuppliersDetail> {
  late Supplier _currentSupplier;

  @override
  void initState() {
    super.initState();
    _currentSupplier = widget.supplier;
  }

  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showErrorSnackBar('Could not launch phone call.');
    }
  }

  Future<void> _launchWhatsApp(String whatsappNumber) async {
    // Hapus spasi dan +
    String formattedNumber = whatsappNumber.replaceAll(RegExp(r'[\s+]'), '');
    final Uri url = Uri.parse('https://wa.me/$formattedNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showErrorSnackBar('Could not open WhatsApp.');
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      _showErrorSnackBar('Could not open email app.');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Config.errorRed),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentSupplier.suppliersName,
          style: textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Config.primaryGreen),
            onPressed: () {
              // TODO: Panggil _showEditSupplierModal
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit feature coming soon!')),
              );
            },
            tooltip: 'Edit Supplier',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Config.errorRed),
            onPressed: () {
              // TODO: Panggil _confirmDelete
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delete feature coming soon!')),
              );
            },
            tooltip: 'Delete Supplier',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Kartu Kontak Utama ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentSupplier.contactPerson,
                      style: textTheme.headlineMedium,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Contact at ${_currentSupplier.suppliersName}',
                      style: textTheme.bodyMedium,
                    ),
                    Divider(height: 24),
                    _buildDetailRow(
                      context,
                      Icons.phone_outlined,
                      'Phone',
                      _currentSupplier.phoneNumber,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.email_outlined,
                      'Email',
                      _currentSupplier.email,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.location_on_outlined,
                      'Address',
                      _currentSupplier.address,
                      isAddress: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // --- Kartu Aksi (KEUNIKAN) ---
            Text('Quick Actions', style: textTheme.titleLarge),
            SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionChip(
                      context,
                      icon: Icons.call_outlined,
                      label: 'Call',
                      color: Config.accentBlue,
                      onTap: () =>
                          _launchPhoneCall(_currentSupplier.phoneNumber),
                    ),
                    _buildActionChip(
                      context,
                      icon: Icons.chat_bubble_outline,
                      label: 'WhatsApp',
                      color: Config.successGreen,
                      onTap: () =>
                          _launchWhatsApp(_currentSupplier.whatsappNumber),
                    ),
                    _buildActionChip(
                      context,
                      icon: Icons.email_outlined,
                      label: 'Email',
                      color: Colors.orange.shade700,
                      onTap: () => _launchEmail(_currentSupplier.email),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // --- Kartu Info Lain ---
            Text('Supplier Info', style: textTheme.titleLarge),
            SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      Icons.inventory_2_outlined,
                      'Catalog',
                      '${_currentSupplier.medicineQuantity} items',
                    ),
                    _buildDetailRow(
                      context,
                      Icons.info_outline,
                      'Status',
                      _currentSupplier.statusText,
                      statusColor: _currentSupplier.statusColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? statusColor,
    bool isAddress = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Config.textSecondary),
          SizedBox(width: 12),
          SizedBox(
            width: 80, // Lebar tetap untuk label
            child: Text(label, style: textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: statusColor ?? Config.textPrimary,
              ),
              maxLines: isAddress ? 3 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
