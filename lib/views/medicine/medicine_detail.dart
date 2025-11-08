import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/views/medicine/medicine_list.dart';
import '../../config/config.dart';
import './medicines_model.dart';

class MedicineDetail extends StatefulWidget {
  final Medicine medicine;
  final Function(Medicine) onUpdate;
  final Function(String) onDelete;

  const MedicineDetail({
    super.key,
    required this.medicine,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<MedicineDetail> createState() => _MedicineDetailState();
}

class _MedicineDetailState extends State<MedicineDetail> {
  late Medicine _currentMedicine;

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
          onSave: (updatedMedicine) {
            setState(() {
              _currentMedicine = updatedMedicine; // Update state lokal
            });
            widget.onUpdate(updatedMedicine); // Panggil callback di parent
            Navigator.pop(context); // Tutup modal
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Medicine updated successfully!')),
            );
          },
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: Text(
          'Are you sure you want to delete ${_currentMedicine.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Config.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Config.errorRed),
            onPressed: () {
              widget.onDelete(
                _currentMedicine.id,
              ); // Panggil callback di parent
              Navigator.of(context).pop(); // Tutup dialog konfirmasi
              Navigator.of(context).pop(); // Tutup halaman detail
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Medicine deleted successfully!')),
              );
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
        title: Text(_currentMedicine.name, style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: Config.primaryGreen),
            onPressed: () => _showEditMedicineModal(context),
            tooltip: 'Edit Medicine',
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Config.errorRed),
            onPressed: () => _confirmDelete(context),
            tooltip: 'Delete Medicine',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card utama dengan informasi ringkas
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
                      _currentMedicine.name,
                      style: textTheme.headlineMedium,
                    ),
                    SizedBox(height: 8),
                    Text(_currentMedicine.code, style: textTheme.bodyMedium),
                    Divider(height: 24),
                    _buildDetailRow(
                      context,
                      'Category',
                      _currentMedicine.category,
                      Icons.category_outlined,
                    ),
                    _buildDetailRow(
                      context,
                      'Quantity',
                      '${_currentMedicine.quantity} ${_currentMedicine.unit}',
                      Icons.storage_outlined,
                    ),
                    _buildDetailRow(
                      context,
                      'Expiry Date',
                      DateFormat(
                        'dd MMM yyyy',
                      ).format(_currentMedicine.expiryDate),
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
            SizedBox(height: 24),

            // Bagian deskripsi (contoh)
            Text('Description', style: textTheme.titleLarge),
            SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${_currentMedicine.name} is a ${_currentMedicine.category.toLowerCase()} medicine. It is typically used for [specific uses here]. Always consult a doctor or pharmacist before use.',
                  style: textTheme.bodyMedium,
                ),
              ),
            ),
            SizedBox(height: 24),

            // Tombol aksi di bagian bawah (opsional, sudah ada di AppBar)
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         onPressed: () => _showEditMedicineModal(context),
            //         icon: Icon(Icons.edit_outlined),
            //         label: Text('Edit'),
            //       ),
            //     ),
            //     SizedBox(width: 16),
            //     Expanded(
            //       child: ElevatedButton.icon(
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Config.errorRed,
            //         ),
            //         onPressed: () => _confirmDelete(context),
            //         icon: Icon(Icons.delete_outline),
            //         label: Text('Delete'),
            //       ),
            //     ),
            //   ],
            // ),
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
          SizedBox(width: 12),
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
