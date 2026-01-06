import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/model/medicine_model.dart';
import 'package:mobile_course_fp/data/provider/medicine_provider.dart';
import 'package:mobile_course_fp/views/medicine/form/add_edit_medicine_modal.dart';
import 'package:mobile_course_fp/views/medicine/view-model/extension/medicine_ui_extension.dart';
import 'package:provider/provider.dart';

class MedicineDetail extends StatefulWidget {
  final Datum medicine;

  const MedicineDetail({super.key, required this.medicine});

  @override
  State<MedicineDetail> createState() => _MedicineDetailState();
}

class _MedicineDetailState extends State<MedicineDetail> {
  // Kita gunakan local state untuk update UI langsung setelah edit tanpa fetch ulang entire list
  late Datum _currentMedicine;

  @override
  void initState() {
    super.initState();
    _currentMedicine = widget.medicine;
  }

  void _showEditMedicineModal(BuildContext context) {
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
          medicineToEdit: _currentMedicine,
        ),
      ),
    ).then((_) {
      context.read<MedicineProvider>().fetchList();
    });
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text(
          'Are you sure you want to delete ${_currentMedicine.displayName}?',
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
                _currentMedicine.id,
              );

              if (success && context.mounted) {
                context.pop(); // Kembali ke list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Medicine deleted successfully'),
                  ),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete medicine')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentMedicine.displayName, style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Config.primaryGreen),
            onPressed: () => _showEditMedicineModal(context),
            tooltip: 'Edit',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Config.errorRed),
            onPressed: () => _confirmDelete(context),
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
                    Text(
                      _currentMedicine.displayName,
                      style: textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "SKU: ${_currentMedicine.displayCode}",
                      style: textTheme.bodyMedium,
                    ),
                    const Divider(height: 24),

                    _buildDetailRow(
                      context,
                      'Price',
                      _currentMedicine.price ?? '0',
                      Icons.attach_money,
                    ),
                    _buildDetailRow(
                      context,
                      'Stock',
                      _currentMedicine.stock.toString(),
                      Icons.storage_outlined,
                    ),
                    _buildDetailRow(
                      context,
                      'Expiry Date',
                      _currentMedicine.expiredDate ?? '-',
                      Icons.calendar_today_outlined,
                    ),
                    _buildDetailRow(
                      context,
                      'Status',
                      _currentMedicine.statusText,
                      Icons.info_outline,
                      statusColor: _currentMedicine.statusColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Deskripsi (Optional jika ada di model)
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
                  'Medicine ${_currentMedicine.displayName} (SKU: ${_currentMedicine.sku}). Ensure to check stock regularly.',
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
