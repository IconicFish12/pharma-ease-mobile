import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/model/medicine_model.dart';
import 'package:mobile_course_fp/data/provider/medicine_category_provider.dart';
import 'package:mobile_course_fp/data/model/medicine_category_model.dart'
    as cat;
import 'package:mobile_course_fp/data/model/supplier_model.dart' as sup;
import 'package:mobile_course_fp/data/provider/medicine_provider.dart';
import 'package:mobile_course_fp/data/provider/supplier_provider.dart';
import 'package:mobile_course_fp/data/view-model/medicine_view_model.dart';
import 'package:provider/provider.dart';

class AddEditMedicineModal extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialSupplierId;
  final bool isEditMode;
  final Datum? medicineToEdit;

  const AddEditMedicineModal({
    super.key,
    required this.isEditMode,
    this.initialCategoryId,
    this.initialSupplierId,
    this.medicineToEdit,
  });

  @override
  State<AddEditMedicineModal> createState() => _AddEditMedicineModalState();
}

class _AddEditMedicineModalState extends State<AddEditMedicineModal> {
  final _formKey = GlobalKey<FormState>();
  late String _medicineName;
  late String _medicineCode;
  String? _selectedCategoryId;
  String? _selectedSupplierId;
  late int _quantity;
  late int _price;
  late DateTime _expiryDate;

  @override
  void initState() {
    super.initState();

    _selectedCategoryId = widget.initialCategoryId;
    _selectedSupplierId = widget.initialSupplierId;

    if (widget.isEditMode && widget.medicineToEdit != null) {
      final med = widget.medicineToEdit!;
      _medicineName = med.medicineName ?? '';
      _medicineCode = med.sku ?? '';
      _quantity = med.stock ?? 0;

      String rawPrice = med.price ?? '0';
      String cleanPrice = rawPrice.replaceAll(RegExp(r'[^0-9]'), '');
      _price = int.tryParse(cleanPrice) ?? 0;

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

    Future.microtask(() {
      context.read<MedicineCategoryProvider>().fetchList();
      context.read<SupplierProvider>().fetchList();
    });
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

      final requestModel = MedicineViewModel(
        medicineId: widget.isEditMode
            ? widget.medicineToEdit?.id?.toString()
            : null,
        medicineName: _medicineName,
        sku: _medicineCode,
        stock: _quantity,
        price: _price.toDouble(),
        expiredDate: formattedDate,
        categoryId: _selectedCategoryId!,
        supplierId: _selectedSupplierId!,
      );

      bool success;
      if (widget.isEditMode) {
        if (widget.medicineToEdit?.id == null) return;

        success = await provider.updateData(
          widget.medicineToEdit!.id,
          data: requestModel.toJson(),
        );
      } else {
        success = await provider.addData(data: requestModel.toJson());
      }

      if (success && mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isEditMode ? 'Updated!' : 'Created!'),
            backgroundColor: Config.primaryGreen,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage ?? 'Operation failed'),
            backgroundColor: Config.errorRed,
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
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _medicineName,
                    decoration: const InputDecoration(
                      labelText: 'Medicine Name',
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _medicineName = v!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _medicineCode,
                    decoration: const InputDecoration(labelText: 'SKU / Code'),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                    onSaved: (v) => _medicineCode = v!,
                  ),
                  const SizedBox(height: 16),
                  Consumer<MedicineCategoryProvider>(
                    builder: (context, provider, child) {
                      final List<cat.Datum> categories = provider.listData
                          .cast<cat.Datum>();
                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Kategori Obat',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedCategoryId,
                        items: categories.map((cat.Datum item) {
                          return DropdownMenuItem<String>(
                            value: item.id,
                            child: Text(item.categoryName ?? '-'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Pilih kategori dulu' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<SupplierProvider>(
                    builder: (context, provider, child) {
                      final List<sup.Datum> suppliers = provider.listData
                          .cast<sup.Datum>();

                      return DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Supplier',
                          border: OutlineInputBorder(),
                        ),
                        value: _selectedSupplierId,
                        items: suppliers.map((sup.Datum item) {
                          return DropdownMenuItem<String>(
                            value: item.id,
                            child: Text(item.supplierName ?? '-'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSupplierId = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Pilih supplier dulu' : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _quantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Stock'),
                          validator: (v) =>
                              int.tryParse(v!) == null ? 'Invalid' : null,
                          onSaved: (v) => _quantity = int.parse(v!),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _price == 0 ? '' : _price.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            prefixText: 'Rp ',
                          ),
                          validator: (v) {
                            String c = v!.replaceAll(RegExp(r'[^0-9]'), '');
                            return c.isEmpty ? 'Invalid' : null;
                          },
                          onSaved: (v) {
                            String c = v!.replaceAll(RegExp(r'[^0-9]'), '');
                            _price = int.parse(c);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: DateFormat('dd MMM yyyy').format(_expiryDate),
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Config.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            widget.isEditMode ? 'Update' : 'Create',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
