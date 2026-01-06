import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../config/config.dart';
import '../Model/suppliers_model.dart';
import '../ViewModel/supplier_viewmodel.dart';
import 'suppliers_detail.dart';

class SupplierList extends StatefulWidget {
  const SupplierList({super.key});

  @override
  State<SupplierList> createState() => _SupplierListState();
}

class _SupplierListState extends State<SupplierList> {
  @override
  void initState() {
    super.initState();
    // Mengambil data saat pertama kali halaman dimuat
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
          onSave: (newSupplier) async {
            await Provider.of<SupplierViewModel>(context, listen: false)
                .addSupplier(newSupplier);
            if (context.mounted) Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showEditSupplierModal(BuildContext context, Supplier supplier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddEditSupplierModal(
          isEditMode: true,
          supplierToEdit: supplier,
          onSave: (updatedSupplier) async {
            await Provider.of<SupplierViewModel>(context, listen: false)
                .updateSupplier(updatedSupplier);
            if (context.mounted) {
              Navigator.pop(context); // Tutup modal
              Navigator.pop(context); // Kembali dari detail ke list dengan data baru
            }
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
                const SizedBox(height: 16),
                _buildSearchBar(context),
                const SizedBox(height: 24),
                Text('Supplier List', style: textTheme.titleLarge),
                const SizedBox(height: 16),
              ]),
            ),
          ),
          Consumer<SupplierViewModel>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (vm.errorMessage.isNotEmpty) {
                return SliverToBoxAdapter(
                  child: Center(child: Text(vm.errorMessage)),
                );
              }

              if (vm.suppliers.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(child: Text("No suppliers found.")),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final supplier = vm.suppliers[index];
                      return SupplierListItem(
                        supplier: supplier,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SuppliersDetail(
                                supplier: supplier,
                                editSupplier: (s) => _showEditSupplierModal(context, s),
                                onDelete: (id) => vm.deleteSupplier(id),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: vm.suppliers.length,
                  ),
                ),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSupplierModal(context),
        backgroundColor: Config.primaryGreen,
        label: const Text('Add New Supplier', style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add_business_outlined, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      onChanged: (value) => Provider.of<SupplierViewModel>(context, listen: false).searchSuppliers(value),
      decoration: InputDecoration(
        hintText: 'Search suppliers...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class SupplierListItem extends StatelessWidget {
  final Supplier supplier;
  final VoidCallback onTap;

  const SupplierListItem({super.key, required this.supplier, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  Expanded(child: Text(supplier.suppliersName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: supplier.statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text(supplier.statusText, style: TextStyle(color: supplier.statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInfoRow(Icons.person_outline, supplier.contactPerson),
              _buildInfoRow(Icons.phone_outlined, supplier.phoneNumber),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(children: [Icon(icon, size: 16, color: Colors.grey), const SizedBox(width: 8), Text(text)]),
    );
  }
}