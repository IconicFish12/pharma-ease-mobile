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
            _createNewSupplier(newSupplier);
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

Future<void> _createNewSupplier(Supplier supplierData) async {
    final vm = Provider.of<SupplierViewModel>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saving data...'), duration: Duration(milliseconds: 800)),
    );

    final bool isSuccess = await vm.createNewSupplier(
      supplierName: supplierData.suppliersName,
      contactPerson: supplierData.contactPerson,
      phoneNumber: supplierData.phoneNumber,
      address: supplierData.address,
    );
    if (!mounted) return;

    if (isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Supplier added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage), 
          backgroundColor: Colors.red,
        ),
      );
    }
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
                _buildSearchBar(context), 
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
                              onDelete: (supplierId) async {
                                final vm = Provider.of<SupplierViewModel>(context, listen: false);
                                bool success = await vm.deleteSupplier(supplierId);

                                if (!success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(vm.errorMessage), 
                                      backgroundColor: Colors.red
                                    ),
                                  );
                                }

                                // 4. Return status sukses/gagal ke halaman Detail
                                return success;
                              },
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
  
  // HANYA 4 VARIABEL UTAMA SESUAI POSTMAN
  late String _suppliersName;
  late String _contactPerson;
  late String _phoneNumber;
  late String _address;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.supplierToEdit != null) {
      _suppliersName = widget.supplierToEdit!.suppliersName;
      _contactPerson = widget.supplierToEdit!.contactPerson;
      _phoneNumber = widget.supplierToEdit!.phoneNumber;
      _address = widget.supplierToEdit!.address;
    } else {
      _suppliersName = '';
      _contactPerson = '';
      _phoneNumber = '';
      _address = '';
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      // KITA BUAT OBJEK SUPPLIER
      // Karena Model Supplier kamu mungkin masih mewajibkan field email/wa/quantity,
      // kita isi dengan data dummy ('-' atau 0) agar tidak error codingannya.
      // Data dummy ini tidak akan dikirim ke server karena ViewModel hanya mengambil 4 field di atas.
      
      final newsupplier = Supplier(
        id: widget.isEditMode
            ? widget.supplierToEdit!.id
            : UniqueKey().toString(),
        suppliersName: _suppliersName,
        contactPerson: _contactPerson,
        phoneNumber: _phoneNumber,
        address: _address,
        
        // --- DATA DUMMY (Untuk pelengkap Model saja) ---
        email: widget.isEditMode ? widget.supplierToEdit!.email : '-', 
        whatsappNumber: widget.isEditMode ? widget.supplierToEdit!.whatsappNumber : '-',
        medicineQuantity: widget.isEditMode ? widget.supplierToEdit!.medicineQuantity : 0,
        status: widget.isEditMode ? widget.supplierToEdit!.status : SupplierStatus.active,
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
            const SizedBox(height: 8),
            Text(
              widget.isEditMode
                  ? 'Update the supplier details below.'
                  : 'Enter the supplier details to add to inventory.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _suppliersName,
                    decoration: const InputDecoration(
                      labelText: 'Supplier Name',
                      hintText: 'e.g., PT Kimia Farma',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama supplier wajib diisi';
                      }
                      return null;
                    },
                    onSaved: (value) => _suppliersName = value!,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    initialValue: _contactPerson,
                    decoration: const InputDecoration(
                      labelText: 'Contact Person Name',
                      hintText: 'e.g., Budi Santoso',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kontak person wajib diisi';
                      }
                      return null;
                    },
                    onSaved: (value) => _contactPerson = value!,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    initialValue: _phoneNumber,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'e.g., 08123456789',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nomor telepon wajib diisi';
                      }
                      return null;
                    },
                    onSaved: (value) => _phoneNumber = value!,
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                    minLines: 1,
                    initialValue: _address,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      hintText: 'e.g., Jl. Sudirman No. 10',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat wajib diisi';
                      }
                      return null;
                    },
                    onSaved: (value) => _address = value!,
                  ),
                  
                  const SizedBox(height: 24),
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
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}