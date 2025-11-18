import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../config/config.dart';
import './medicines_model.dart';
import 'package:mobile_course_fp/views/medicine/medicine_category.dart';
import 'package:mobile_course_fp/views/medicine/medicine_detail.dart';

class MedicineList extends StatefulWidget {
  const MedicineList({super.key});

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  final List<Medicine> _medicines = [
    Medicine(
      id: 'MED001',
      name: 'Paracetamol',
      code: 'PCM500',
      category: 'Pain Relief',
      quantity: 150,
      unit: 'Tablet',
      expiryDate: DateTime(2025, 11, 15),
    ),
    Medicine(
      id: 'MED002',
      name: 'Amoxicillin',
      code: 'AMX250',
      category: 'Antibiotic',
      quantity: 80,
      unit: 'Capsule',
      expiryDate: DateTime(2025, 11, 20),
    ),
    Medicine(
      id: 'MED003',
      name: 'Ibuprofen',
      code: 'IBP400',
      category: 'Pain Relief',
      quantity: 200,
      unit: 'Tablet',
      expiryDate: DateTime(2025, 12, 5),
    ),
    Medicine(
      id: 'MED004',
      name: 'Ciprofloxacin',
      code: 'CIP500',
      category: 'Antibiotic',
      quantity: 45,
      unit: 'Tablet',
      expiryDate: DateTime(2025, 12, 10),
    ),
    Medicine(
      id: 'MED005',
      name: 'Omeprazole',
      code: 'OMP20',
      category: 'Antacid',
      quantity: 120,
      unit: 'Capsule',
      expiryDate: DateTime(2026, 1, 15),
    ),
    Medicine(
      id: 'MED006',
      name: 'Metformin',
      code: 'MET500',
      category: 'Diabetes',
      quantity: 95,
      unit: 'Tablet',
      expiryDate: DateTime(2026, 2, 20),
    ),
    Medicine(
      id: 'MED007',
      name: 'Aspirin',
      code: 'ASP75',
      category: 'Blood Thinner',
      quantity: 180,
      unit: 'Tablet',
      expiryDate: DateTime(2026, 3, 10),
    ),
    Medicine(
      id: 'MED008',
      name: 'Loratadine',
      code: 'LOR10',
      category: 'Antihistamine',
      quantity: 60,
      unit: 'Tablet',
      expiryDate: DateTime(2025, 12, 25),
    ),
    Medicine(
      id: 'MED009',
      name: 'Lisinopril',
      code: 'LIS10',
      category: 'Blood Pressure',
      quantity: 110,
      unit: 'Tablet',
      expiryDate: DateTime(2026, 1, 30),
    ),
    Medicine(
      id: 'MED010',
      name: 'Atorvastatin',
      code: 'ATV20',
      category: 'Cholesterol',
      quantity: 15,
      unit: 'Tablet',
      expiryDate: DateTime(2025, 11, 28),
    ),
  ];

  final List<Category> _categories = [
    Category(
      id: 'CAT001',
      name: 'Pain Relief',
      icon: Icons.medication_outlined,
    ),
    Category(id: 'CAT002', name: 'Antibiotic', icon: Icons.bug_report_outlined),
    Category(id: 'CAT003', name: 'Antacid', icon: Icons.sick),
    Category(id: 'CAT004', name: 'Diabetes', icon: Icons.bloodtype_outlined),
    Category(
      id: 'CAT005',
      name: 'Blood Thinner',
      icon: Icons.colorize_outlined,
    ),
    Category(id: 'CAT006', name: 'Antihistamine', icon: Icons.sick_outlined),
    Category(
      id: 'CAT007',
      name: 'Blood Pressure',
      icon: Icons.monitor_heart_outlined,
    ),
    Category(
      id: 'CAT008',
      name: 'Cholesterol',
      icon: Icons.monitor_weight_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    for (var med in _medicines) {
      med.updateStatus();
    }
  }

  void _addMedicine(Medicine newMedicine) {
    setState(() {
      _medicines.add(newMedicine);
      newMedicine.updateStatus(); // Pastikan status terupdate saat ditambahkan
    });
  }

  void _updateMedicine(Medicine updatedMedicine) {
    setState(() {
      final index = _medicines.indexWhere(
        (med) => med.id == updatedMedicine.id,
      );
      if (index != -1) {
        _medicines[index] = updatedMedicine;
        _medicines[index].updateStatus();
      }
    });
  }

  void _deleteMedicine(String medicineId) {
    setState(() {
      _medicines.removeWhere((med) => med.id == medicineId);
    });
  }

  void _showAddMedicineModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEditMedicineModal(
          isEditMode: false,
          onSave: (newMedicine) {
            _addMedicine(newMedicine);
            Navigator.pop(context); // Tutup modal setelah disimpan
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Medicine added successfully!')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory', style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text('Inventory Management', style: textTheme.headlineMedium),
                SizedBox(height: 16),

                _buildSearchBar(context),
                SizedBox(height: 24),

                _buildCategoriesSection(context),
                SizedBox(height: 24),

                Text('Medicine List', style: textTheme.headlineMedium),
                SizedBox(height: 16),
              ]),
            ),
          ),
          // Medicine List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final medicine = _medicines[index];
                return MedicineListItem(
                  medicine: medicine,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MedicineDetail(
                          medicine: medicine,
                          onUpdate: _updateMedicine,
                          onDelete: _deleteMedicine,
                        ),
                      ),
                    );
                  },
                );
              }, childCount: _medicines.length),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80)), // Space for FAB
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddMedicineModal(context),
        backgroundColor: Config.primaryGreen,
        label: const Text('Add New Medicine'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search medicine...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.filter_list_alt, color: Config.textSecondary),
            onPressed: () {
              // TODO: Implement filter functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter options coming soon!')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Categories', style: textTheme.titleLarge),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MedicineCategories(categories: _categories),
                  ),
                );
              },
              child: Text(
                'See All',
                style: textTheme.labelLarge?.copyWith(
                  color: Config.primaryGreen,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 100, // Tinggi tetap untuk daftar kategori horizontal
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length > 5
                ? 5
                : _categories.length, // Tampilkan maks 5
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CategoryIconCard(category: category),
              );
            },
          ),
        ),
      ],
    );
  }
}

class MedicineListItem extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onTap;

  const MedicineListItem({
    super.key,
    required this.medicine,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      medicine.name,
                      style: textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: medicine.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      medicine.statusText,
                      style: textTheme.labelSmall?.copyWith(
                        color: medicine.statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Code: ${medicine.code} | Category: ${medicine.category}',
                style: textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Qty: ${medicine.quantity} ${medicine.unit}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Exp: ${DateFormat('dd MMM yyyy').format(medicine.expiryDate)}',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryIconCard extends StatelessWidget {
  final Category category;

  const CategoryIconCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Filtered by ${category.name}')));
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80, 
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Config.primaryGreen.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Config.primaryGreen.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 28, color: Config.primaryGreen),
            SizedBox(height: 6),
            Text(
              category.name,
              style: textTheme.labelSmall,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Modal untuk menambahkan atau mengedit obat
class AddEditMedicineModal extends StatefulWidget {
  final bool isEditMode;
  final Medicine? medicineToEdit;
  final Function(Medicine) onSave;

  const AddEditMedicineModal({
    super.key,
    required this.isEditMode,
    this.medicineToEdit,
    required this.onSave,
  });

  @override
  State<AddEditMedicineModal> createState() => _AddEditMedicineModalState();
}

class _AddEditMedicineModalState extends State<AddEditMedicineModal> {
  final _formKey = GlobalKey<FormState>();
  late String _medicineName;
  late String _medicineCode;
  late String _medicineCategory;
  late int _quantity;
  late String _unit;
  late DateTime _expiryDate;

  final List<String> _units = [
    'Tablet',
    'Capsule',
    'Syrup',
    'Strip',
    'Box',
    'Bottle',
  ];
  final List<String> _categories = [
    'Pain Relief',
    'Antibiotic',
    'Antacid',
    'Diabetes',
    'Blood Thinner',
    'Antihistamine',
    'Blood Pressure',
    'Cholesterol',
    'Vitamin',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.medicineToEdit != null) {
      _medicineName = widget.medicineToEdit!.name;
      _medicineCode = widget.medicineToEdit!.code;
      _medicineCategory = widget.medicineToEdit!.category;
      _quantity = widget.medicineToEdit!.quantity;
      _unit = widget.medicineToEdit!.unit;
      _expiryDate = widget.medicineToEdit!.expiryDate;
    } else {
      _medicineName = '';
      _medicineCode = '';
      _medicineCategory = _categories.first; // Default category
      _quantity = 0;
      _unit = _units.first; // Default unit
      _expiryDate = DateTime.now().add(
        const Duration(days: 365),
      ); // Default 1 year from now
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
              primary: Config.primaryGreen, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Config.textPrimary, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Config.primaryGreen, // button text color
              ),
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

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newMedicine = Medicine(
        id: widget.isEditMode
            ? widget.medicineToEdit!.id
            : UniqueKey().toString(), // Gunakan ID lama atau buat baru
        name: _medicineName,
        code: _medicineCode,
        category: _medicineCategory,
        quantity: _quantity,
        unit: _unit,
        expiryDate: _expiryDate,
      );
      widget.onSave(newMedicine);
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
            SizedBox(height: 8),
            Text(
              widget.isEditMode
                  ? 'Update the medicine details below.'
                  : 'Enter the medicine details to add to inventory.',
              style: textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _medicineCode,
                    decoration: const InputDecoration(
                      labelText: 'Medicine Code',
                      hintText: 'e.g., MED001',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter medicine code';
                      }
                      return null;
                    },
                    onSaved: (value) => _medicineCode = value!,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _medicineCategory,
                    decoration: const InputDecoration(
                      labelText: 'Medicine Category',
                    ),
                    items: _categories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _medicineCategory = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                    onSaved: (value) => _medicineCategory = value!,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _quantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                            hintText: 'e.g., 100',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter quantity';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          onSaved: (value) => _quantity = int.parse(value!),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _unit,
                          decoration: const InputDecoration(labelText: 'Unit'),
                          items: _units
                              .map(
                                (unit) => DropdownMenuItem(
                                  value: unit,
                                  child: Text(unit),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _unit = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a unit';
                            }
                            return null;
                          },
                          onSaved: (value) => _unit = value!,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: TextEditingController(
                          text: DateFormat('dd/MM/yyyy').format(_expiryDate),
                        ),
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          suffixIcon: Icon(Icons.calendar_today_outlined),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an expiry date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveForm,
                          child: Text(
                            widget.isEditMode
                                ? 'Update Medicine'
                                : 'Add Medicine',
                            style: textTheme.labelLarge,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
