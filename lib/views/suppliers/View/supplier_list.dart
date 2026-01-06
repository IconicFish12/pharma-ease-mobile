import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/views/suppliers/View/suppliers_detail.dart';
import 'package:mobile_course_fp/views/suppliers/Model/suppliers_model.dart';
import '../../../config/config.dart';
import 'package:mobile_course_fp/views/suppliers/ViewModel/supplier_viewmodel.dart';
import 'package:provider/provider.dart';


class SupplierList extends StatefulWidget {
  const SupplierList({super.key});

  @override
  State<SupplierList> createState() => _SupplierListState();
}

class _SupplierListState extends State<SupplierList> {
  // void _addSupplier(Supplier newSupplier) {
  //   setState(() {
  //     SupplierData.suppliers.add(newSupplier);
  //   });
  // }

  // void _updateSupplier(Supplier updateSupplier) {
  //   setState(() {
  //     final index = SupplierData.suppliers.indexWhere((med) => med.id == updateSupplier.id);
  //     if (index != -1) {
  //       SupplierData.suppliers[index] = updateSupplier;
  //     }
  //   });
  // }

  // void _deleteSupplier(String supplierId) {
  //   setState(() {
  //     SupplierData.suppliers.removeWhere((med) => med.id == supplierId);
  //   });
  // }

  void _getAllSupplier() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SupplierViewModel>(context, listen: false).fetchSuppliers();
    });
  }

  void _showAddSupplierModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEditSupplierModal(
          isEditMode: false,
          onSave: (newSupplier) {
            // _addSupplier(newSupplier);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Supplier added successfully!')),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    _getAllSupplier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Suppliers', style: textTheme.titleLarge),
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
                Text('Supplier Management', style: textTheme.headlineMedium),
                SizedBox(height: 16),
                _buildSearchBar(context), // Menggunakan search bar
                SizedBox(height: 24),
                Text('Supplier List', style: textTheme.headlineMedium),
                SizedBox(height: 16),
              ]),
            ),
          ),

          // panggil vm
          Consumer<SupplierViewModel>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              // cek error dari vm
              if (vm.errorMessage.isNotEmpty) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(vm.errorMessage),
                          TextButton(
                            onPressed: () => vm.fetchSuppliers(),
                            child: const Text("Coba Lagi"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              // cek data kosong
              if (vm.suppliers.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text("Belum ada data supplier")),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final supplier = vm.suppliers[index];

                    return SupplierListItem(
                      supplier: supplier,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuppliersDetail(
                              supplier: supplier,
                              editSupplier: (updatedSupplier) {},
                              onDelete: (supplierId) {},
                            ),
                          ),
                        );
                      },
                    );
                  }, childCount: vm.suppliers.length),
                ),
              );
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSupplierModal(context),
        backgroundColor: Config.primaryGreen,
        label: const Text('Add New Supplier'),
        icon: const Icon(Icons.add_business_outlined),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search suppliers...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 0),
      ),
    );
  }
}

class SupplierListItem extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback onTap;

  const SupplierListItem({
    super.key,
    required this.supplier,
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
                      supplier.suppliersName,
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
                      color: supplier.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      supplier.statusText,
                      style: textTheme.labelSmall?.copyWith(
                        color: supplier.statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                context,
                Icons.person_outline,
                supplier.contactPerson,
                textTheme.bodyLarge,
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                context,
                Icons.phone_outlined,
                supplier.phoneNumber,
                textTheme.bodyMedium,
              ),
              SizedBox(height: 8),
              _buildInfoRow(
                context,
                Icons.inventory_2_outlined,
                '${supplier.medicineQuantity} items in catalog',
                textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String text,
    TextStyle? style,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Config.textSecondary),
        SizedBox(width: 8),
        Text(text, style: style),
      ],
    );
  }
}

class AddEditSupplierModal extends StatefulWidget {
  final bool isEditMode;
  final Supplier? supplierToEdit;
  final Function(Supplier) onSave;

  const AddEditSupplierModal({
    super.key,
    required this.isEditMode,
    this.supplierToEdit,
    required this.onSave,
  });

  @override
  State<AddEditSupplierModal> createState() => _AddEditSupplierModalState();
}

class _AddEditSupplierModalState extends State<AddEditSupplierModal> {
  final _formKey = GlobalKey<FormState>();
  late String _suppliersName;
  late String _contactPerson;
  late String _email;
  late String _phoneNumber;
  late String _whatsappNumber;
  late String _address;
  late int _medicineQuantity;
  late SupplierStatus _status;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.supplierToEdit != null) {
      _suppliersName = widget.supplierToEdit!.suppliersName;
      _contactPerson = widget.supplierToEdit!.contactPerson;
      _email = widget.supplierToEdit!.email;
      _phoneNumber = widget.supplierToEdit!.phoneNumber;
      _address = widget.supplierToEdit!.address;
      _medicineQuantity = widget.supplierToEdit!.medicineQuantity;
      _status = widget.supplierToEdit!.status;
    } else {
      _suppliersName = '';
      _contactPerson = '';
      _email = '';
      _phoneNumber = '';
      _whatsappNumber = '';
      _address = '';
      _medicineQuantity = 0;
      _status = SupplierStatus.active; // Default 1 year from now
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newsupplier = Supplier(
        id: widget.isEditMode
            ? widget.supplierToEdit!.id
            : UniqueKey().toString(),
        suppliersName: _suppliersName,
        contactPerson: _contactPerson,
        email: _email,
        phoneNumber: _phoneNumber,
        whatsappNumber: _whatsappNumber,
        address: _address,
        medicineQuantity: _medicineQuantity,
        status: _status,
      );
      widget.onSave(newsupplier);
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
                  widget.isEditMode ? 'Edit Supplier' : 'Add New Supplier',
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
                  ? 'Update the supplier details below.'
                  : 'Enter the supplier details to add to inventory.',
              style: textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _suppliersName,
                    decoration: const InputDecoration(
                      labelText: 'Supplier Name',
                      hintText: 'e.g., John Doe',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter supplier name';
                      }
                      return null;
                    },
                    onSaved: (value) => _suppliersName = value!,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _contactPerson,
                    decoration: const InputDecoration(
                      labelText: 'Supplier Personal Contact',
                      hintText: 'e.g., John Doe',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter medicine code';
                      }
                      return null;
                    },
                    onSaved: (value) => _contactPerson = value!,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    initialValue: _email,
                    decoration: const InputDecoration(
                      labelText: 'Supplier Email',
                      hintText: 'e.g., JohnDoe@gmail.com',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter medicine code';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: _phoneNumber,
                          decoration: const InputDecoration(
                            labelText: 'Supplier Phone Number',
                            hintText: '+6282233445551',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Suplier Phone Number';
                            }
                            return null;
                          },
                          onSaved: (value) => _phoneNumber = value!,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          initialValue: _whatsappNumber,
                          decoration: const InputDecoration(
                            labelText: 'Contact Person Number',
                            hintText: '+6282233445551',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Contact Phone Number';
                            }
                            return null;
                          },
                          onSaved: (value) => _whatsappNumber = value!,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 2,
                    initialValue: _address,
                    decoration: const InputDecoration(
                      labelText: 'Supplier Address',
                      hintText: 'e.g., JohnDoe@gmail.com',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Supplier Address';
                      }
                      return null;
                    },
                    onSaved: (value) => _address = value!,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: _medicineQuantity.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Supplier Address',
                      hintText: 'e.g., JohnDoe@gmail.com',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Supplier Address';
                      }
                      return null;
                    },
                    onSaved: (value) => _medicineQuantity = int.parse(value!),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveForm,
                          child: Text(
                            widget.isEditMode
                                ? 'Update Supplier'
                                : 'Add Supplier',
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