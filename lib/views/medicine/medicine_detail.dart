import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/model/medicine_model.dart';
import 'package:mobile_course_fp/data/provider/medicine_provider.dart';
import 'package:mobile_course_fp/views/medicine/form/add_edit_medicine_modal.dart';
import 'package:mobile_course_fp/views/medicine/extension/medicine_ui_extension.dart';
import 'package:provider/provider.dart';

class MedicineDetail extends StatefulWidget {
  final Datum medicine;

  const MedicineDetail({super.key, required this.medicine});

  @override
  State<MedicineDetail> createState() => _MedicineDetailState();
}

class _MedicineDetailState extends State<MedicineDetail> {
  // HAPUS initState dan _currentMedicine lokal.
  // Kita akan ambil data real-time di method build.

  void _showEditMedicineModal(BuildContext context, Datum currentData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEditMedicineModal(
          isEditMode: true,
          medicineToEdit: currentData, // Kirim data terbaru
        ),
      ),
    );
    // Tidak perlu .then(fetchList) manual disini,
    // karena Provider Anda sudah otomatis fetchList saat updateData return bool/false.
  }

  void _confirmDelete(BuildContext context, Datum currentData) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text(
          'Are you sure you want to delete ${currentData.displayName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: TextStyle(color: Config.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Config.errorRed),
            onPressed: () async {
              Navigator.pop(dialogContext);

              final success = await context.read<MedicineProvider>().deleteData(
                currentData.id,
              );

              if (success && context.mounted) {
                context.pop(); // Kembali ke list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Medicine deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete medicine')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // LOGIKA REAKTIF:
    // Ambil data terbaru dari Provider list.
    // Jika update berhasil, Provider akan refresh list, dan widget ini akan rebuild otomatis.
    final provider = context.watch<MedicineProvider>();

    // Cari obat ini di dalam list terbaru provider.
    // Gunakan orElse untuk fallback ke widget.medicine (data awal) jika list kosong/loading.
    final medicine = provider.listData.firstWhere(
      (element) => element.id == widget.medicine.id,
      orElse: () => widget.medicine,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.displayName, style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Config.primaryGreen),
            onPressed: () => _showEditMedicineModal(context, medicine),
            tooltip: 'Edit',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Config.errorRed),
            onPressed: () => _confirmDelete(context, medicine),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Utama
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
                    Text(medicine.displayName, style: textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      "SKU: ${medicine.displayCode}",
                      style: textTheme.bodyMedium,
                    ),
                    const Divider(height: 24),

                    _buildDetailRow(
                      context,
                      'Price',
                      medicine.price ?? '0',
                      Icons.attach_money,
                    ),
                    _buildDetailRow(
                      context,
                      'Stock',
                      medicine.stock.toString(),
                      Icons.storage_outlined,
                    ),
                    _buildDetailRow(
                      context,
                      'Expiry Date',
                      medicine.expiredDate ?? '-',
                      Icons.calendar_today_outlined,
                    ),
                    _buildDetailRow(
                      context,
                      'Status',
                      medicine.statusText,
                      Icons.info_outline,
                      statusColor: medicine.statusColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Description', style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Medicine ${medicine.displayName} (SKU: ${medicine.sku}). Ensure to check stock regularly.',
                  style: textTheme.bodyMedium,
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
    String label,
    String value,
    IconData icon, {
    Color? statusColor,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Config.textSecondary),
          const SizedBox(width: 12),
          Expanded(flex: 2, child: Text(label, style: textTheme.bodyMedium)),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: statusColor ?? Config.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
