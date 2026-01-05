import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/model/medicine_model.dart';
import 'package:mobile_course_fp/data/provider/medicine_provider.dart';

class AddEditMedicineModal extends StatefulWidget {
  final bool isEditMode;
  final Datum? medicineToEdit;

  const AddEditMedicineModal({
    super.key,
    required this.isEditMode,
    this.medicineToEdit,
  });

  @override
  State<AddEditMedicineModal> createState() => _AddEditMedicineModalState();
}

class _AddEditMedicineModalState extends State<AddEditMedicineModal> {
  final _formKey = GlobalKey<FormState>();
  late String _medicineName;
  late String _medicineCode;
  late int _quantity;

  // Menggunakan int untuk harga agar lebih mudah dikelola (aritmatika/validasi)
  late int _price;

  // Default expiry 1 tahun dari sekarang jika create new
  late DateTime _expiryDate;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.medicineToEdit != null) {
      final med = widget.medicineToEdit!;
      _medicineName = med.medicineName ?? '';
      _medicineCode = med.sku ?? '';
      _quantity = med.stock ?? 0;

      // LOGIC: Membersihkan format uang (misal: "Rp 60.016") menjadi integer (60016)
      // Regex r'[^0-9]' akan menghapus semua karakter kecuali angka.
      String rawPrice = med.price ?? '0';
      String cleanPrice = rawPrice.replaceAll(RegExp(r'[^0-9]'), '');
      _price = int.tryParse(cleanPrice) ?? 0;

      // Parse tanggal dari string API yyyy-MM-dd
      if (med.expiredDate != null) {
        try {
          _expiryDate = DateFormat('yyyy-MM-dd').parse(med.expiredDate!);
        } catch (e) {
          _expiryDate = DateTime.now().add(const Duration(days: 365));
        }
      } else {
        _expiryDate = DateTime.now().add(const Duration(days: 365));
      }
    } else {
      _medicineName = '';
      _medicineCode = '';
      _quantity = 0;
      _price = 0;
      _expiryDate = DateTime.now().add(const Duration(days: 365));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Config.primaryGreen,
              onPrimary: Colors.white,
              onSurface: Config.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Config.primaryGreen),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final provider = context.read<MedicineProvider>();
      final formattedDate = DateFormat('yyyy-MM-dd').format(_expiryDate);

      // DEBUG: Cek nilai di Console sebelum dikirim
      debugPrint('Saving Medicine...');
      debugPrint('Name: $_medicineName');
      debugPrint('Price (Int): $_price');
      debugPrint('Stock: $_quantity');

      // Construct Datum Object
      // PERHATIKAN: field 'price' dikirim sebagai String angka bersih ("60016").
      // Jika Backend error, pastikan apakah backend butuh Integer (60016) atau String ("60016").
      // Karena Datum.price bertipe String, kita gunakan .toString().
      final newMedicine = Datum(
        id: widget.isEditMode ? widget.medicineToEdit?.id : null,
        medicineName: _medicineName,
        sku: _medicineCode,
        stock: _quantity,
        price: _price.toString(),
        expiredDate: formattedDate,
      );

      bool success;
      if (widget.isEditMode) {
        // Pastikan ID valid saat update
        if (widget.medicineToEdit?.id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Medicine ID is missing for update'),
            ),
          );
          return;
        }
        success = await provider.updateData(
          widget.medicineToEdit!.id,
          newMedicine,
        );
      } else {
        success = await provider.addData(newMedicine);
      }

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditMode
                  ? 'Updated successfully!'
                  : 'Created successfully!',
            ),
          ),
        );
      } else if (mounted) {
        // Tampilkan error dari provider jika ada (misal: Bad Response detail)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.errorMessage ?? 'Operation failed. Check inputs.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.isEditMode ? 'Edit Medicine' : 'Add New Medicine',
                  style: textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.isEditMode
                  ? 'Update the medicine details below.'
                  : 'Enter the medicine details to add to inventory.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Nama Obat
                  TextFormField(
                    initialValue: _medicineName,
                    decoration: const InputDecoration(
                      labelText: 'Medicine Name',
                      hintText: 'e.g., Paracetamol 500mg',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter medicine name';
                      }
                      return null;
                    },
                    onSaved: (value) => _medicineName = value!,
                  ),
                  const SizedBox(height: 16),

                  // SKU / Code
                  TextFormField(
                    initialValue: _medicineCode,
                    decoration: const InputDecoration(
                      labelText: 'SKU / Code',
                      hintText: 'e.g., MED001',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter SKU/Code';
                      }
                      return null;
                    },
                    onSaved: (value) => _medicineCode = value!,
                  ),
                  const SizedBox(height: 16),

                  // Stock & Price Row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _quantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            hintText: '0',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Required';
                            if (int.tryParse(value) == null)
                              return 'Invalid number';
                            return null;
                          },
                          onSaved: (value) => _quantity = int.parse(value!),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // PRICE FIELD (INT LOGIC)
                      Expanded(
                        child: TextFormField(
                          // Jika 0, kosongkan agar user mudah mengetik. Jika ada nilai, tampilkan angkanya saja.
                          initialValue: _price == 0 ? '' : _price.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            prefixText: 'Rp ', // Visual prefix saja
                            hintText: '0',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Required';
                            // Validasi apakah input hanya berisi angka (setelah dibersihkan)
                            String clean = value.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            );
                            if (clean.isEmpty) return 'Invalid price';
                            return null;
                          },
                          onSaved: (value) {
                            if (value == null || value.isEmpty) {
                              _price = 0;
                            } else {
                              // Bersihkan semua karakter non-angka sebelum parsing
                              String cleanVal = value.replaceAll(
                                RegExp(r'[^0-9]'),
                                '',
                              );
                              _price = int.tryParse(cleanVal) ?? 0;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Expiry Date Picker
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: DateFormat('dd MMM yyyy').format(_expiryDate),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          suffixIcon: const Icon(Icons.calendar_today_outlined),
                          border: Theme.of(context).inputDecorationTheme.border,
                          enabledBorder: Theme.of(
                            context,
                          ).inputDecorationTheme.enabledBorder,
                          focusedBorder: Theme.of(
                            context,
                          ).inputDecorationTheme.focusedBorder,
                          filled: Theme.of(context).inputDecorationTheme.filled,
                          fillColor: Theme.of(
                            context,
                          ).inputDecorationTheme.fillColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Config.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            widget.isEditMode
                                ? 'Update Medicine'
                                : 'Add Medicine',
                            style: textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Config.textSecondary,
                            side: BorderSide(
                              color: Config.textSecondary.withOpacity(0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: textTheme.labelLarge?.copyWith(
                              color: Config.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
