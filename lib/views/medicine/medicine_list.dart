import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/model/medicine_model.dart';
import 'package:mobile_course_fp/data/provider/medicine_provider.dart';
import 'package:mobile_course_fp/data/provider/provider.dart';
import 'package:mobile_course_fp/views/medicine/form/add_edit_medicine_modal.dart';
import 'package:mobile_course_fp/views/medicine/medicine-category/View/medicine_category.dart';
import 'package:mobile_course_fp/views/medicine/medicine-category/ViewModel/medicine_category_viewmodel.dart';
import 'package:mobile_course_fp/views/medicine/view-model/extension/medicine_ui_extension.dart';
import 'package:provider/provider.dart';

class MedicineList extends StatefulWidget {
  const MedicineList({super.key});

  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicineProvider>().fetchList();
      context.read<MedicineCategoryViewmodel>().fetchAllCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
        child: const AddEditMedicineModal(isEditMode: false),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MedicineProvider>().fetchList(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<MedicineProvider>().fetchList();
          await context.read<MedicineCategoryViewmodel>().fetchAllCategories();
        },
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text('Inventory Management', style: textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  _buildSearchBar(context),
                  const SizedBox(height: 24),
                  _buildCategoriesSection(context),
                  const SizedBox(height: 24),
                  Text('Medicine List', style: textTheme.headlineMedium),
                  const SizedBox(height: 16),
                ]),
              ),
            ),

            // Consumer untuk List Data
            Consumer<MedicineProvider>(
              builder: (context, provider, child) {
                if (provider.state == ViewState.loading &&
                    provider.listData.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (provider.state == ViewState.error) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Config.errorRed,
                          ),
                          const SizedBox(height: 16),
                          Text(provider.errorMessage ?? 'Error occurred'),
                          TextButton(
                            onPressed: () => provider.fetchList(),
                            child: const Text("Try Again"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (provider.listData.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text("No medicines found in inventory"),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final medicine = provider.listData[index];
                      return MedicineListItem(
                        medicine: medicine,
                        onTap: () {
                          context.pushNamed('MedicineDetail', extra: medicine);
                        },
                      );
                    }, childCount: provider.listData.length),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
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
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search medicine...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
            onChanged: (value) {
              // Implement local search filter if needed inside Provider
              // context.read<MedicineProvider>().searchLocal(value);
            },
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(Icons.filter_list_alt, color: Config.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter coming soon!')),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Consumer<MedicineCategoryViewmodel>(
      builder: (context, viewmodel, child) {
        if (viewmodel.isLoading) {
          return const Center(child: LinearProgressIndicator());
        }
        if (viewmodel.categories.isEmpty) return const SizedBox();

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
                        builder: (context) => MedicineCategories(
                          categories: viewmodel.categories,
                        ),
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
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: viewmodel.categories.length > 5
                    ? 5
                    : viewmodel.categories.length,
                itemBuilder: (context, index) {
                  final category = viewmodel.categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: 80,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Config.primaryGreen.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Config.primaryGreen.withOpacity(0.1),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Placeholder icon logic, replace with your category icon logic
                            Icon(
                              Icons.medication,
                              size: 28,
                              color: Config.primaryGreen,
                            ),
                            const SizedBox(height: 6),
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
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MedicineListItem extends StatelessWidget {
  final Datum medicine;
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
                      medicine.displayName, // via extension
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
                      color: medicine.statusColor.withOpacity(
                        0.1,
                      ), // via extension
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      medicine.statusText, // via extension
                      style: textTheme.labelSmall?.copyWith(
                        color: medicine.statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'SKU: ${medicine.displayCode}', // via extension
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stok: ${medicine.displayStock}', // via extension
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    medicine.expiredDate != null
                        ? 'Exp: ${medicine.expiredDate}'
                        : 'Exp: -',
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
