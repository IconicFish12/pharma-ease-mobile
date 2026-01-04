import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/config.dart';
import '../../medicines_model.dart';
import 'package:mobile_course_fp/views/medicine/medicine-category/Model/medicine_category_model.dart';


class MedicineCategories extends StatelessWidget {
  final List<Category> categories;

  const MedicineCategories({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('All Categories', style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kategori per baris
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5, // Rasio aspek kartu
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return CategoryCard(category: category);
          },
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // TODO: Implement navigation to filter inventory by this category
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing ${category.name} medicines')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, size: 40, color: Config.primaryGreen),
              SizedBox(height: 12),
              Text(
                category.name,
                style: textTheme.titleLarge?.copyWith(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
