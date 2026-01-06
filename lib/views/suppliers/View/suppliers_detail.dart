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

  // --- Implementasi Logika Delete ---
void _confirmDelete() {
    showDialog(
      context: context, 
      builder: (BuildContext dialogContext) { 
        return AlertDialog(
          title: const Text('Hapus Supplier'),
          content: Text('Apakah Anda yakin ingin menghapus ${_currentSupplier.suppliersName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), 
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Config.errorRed),
              onPressed: () async {
                Navigator.pop(dialogContext); 
                if (mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Menghapus data..."), duration: Duration(seconds: 1)),
                  );
                }

                bool isSuccess = await widget.onDelete(_currentSupplier.id);

                if (!mounted) return;

                if (isSuccess) {
                  context.pop(); 
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Berhasil dihapus"), backgroundColor: Colors.green),
                  );
                } else {
                }
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // --- Implementasi Logika Edit ---
  void _handleEdit() async {
    final updatedSupplier = await widget.editSupplier(_currentSupplier);
    if (updatedSupplier != null && mounted) {
      setState(() {
        _currentSupplier = updatedSupplier;
      });
    }
  }

  // --- Launcher Helpers ---
  Future<void> _launchPhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showErrorSnackBar('Tidak dapat melakukan panggilan telepon.');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  Future<void> _launchWhatsApp(String whatsappNumber) async {
    String formattedNumber = whatsappNumber.replaceAll(RegExp(r'[\s+]'), '');
    final Uri url = Uri.parse('https://wa.me/$formattedNumber');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        _showErrorSnackBar('WhatsApp tidak ditemukan.');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        _showErrorSnackBar('Aplikasi Email tidak ditemukan.');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
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
        title: const Text('Detail Supplier'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Config.primaryGreen),
            onPressed: _handleEdit,
            tooltip: 'Edit Supplier',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Config.errorRed),
            onPressed: _confirmDelete,
            tooltip: 'Hapus Supplier',
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentSupplier.contactPerson,
                      style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kontak di ${_currentSupplier.suppliersName}',
                      style: textTheme.bodyMedium?.copyWith(color: Config.textSecondary),
                    ),
                    const Divider(height: 32),
                    _buildDetailRow(
                      context,
                      Icons.phone_outlined,
                      'Telepon',
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
                      'Alamat',
                      _currentSupplier.address,
                      isAddress: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Aksi Cepat', style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionChip(
                      context,
                      icon: Icons.call_outlined,
                      label: 'Telepon',
                      color: Config.accentBlue,
                      onTap: () => _launchPhoneCall(_currentSupplier.phoneNumber),
                    ),
                    _buildActionChip(
                      context,
                      icon: Icons.chat_bubble_outline,
                      label: 'WhatsApp',
                      color: Config.successGreen,
                      onTap: () => _launchWhatsApp(_currentSupplier.whatsappNumber),
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
            const SizedBox(height: 24),

            Text('Informasi Supplier', style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      Icons.inventory_2_outlined,
                      'Katalog',
                      '${_currentSupplier.medicineQuantity} Item Obat',
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

  // --- Implementasi Widget Helpers yang Kosong ---

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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: textTheme.bodySmall?.copyWith(color: Config.textSecondary)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: statusColor ?? Config.textPrimary,
                  ),
                  maxLines: isAddress ? 4 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}