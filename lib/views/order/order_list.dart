import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/views/order/order_detail.dart';
import 'package:mobile_course_fp/views/order/order_model.dart';

class OrderList extends StatefulWidget {
  const OrderList({super.key});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  final List<Order> _orders = [
    Order(
      id: "ORD001",
      suppliersName: "MediSupply Co.",
      contactPerson: "David Lee",
      email: "david@medisupply.com",
      phoneNumber: "+1-555-0101",
      whatsappNumber: "+15550101",
      address: "123 Medical Ave, NY",
      orderDate: "2025-02-01",
      expectedDeliveryDate: "2025-02-10",
      items: [
        OrderItem(name: "Paracetamol", price: 100000, amount: 3),
        OrderItem(name: "Amoxicillin", price: 150000, amount: 2),
      ],
    ),
    Order(
      id: "ORD002",
      suppliersName: "PharmaCorp Ltd.",
      contactPerson: "Lisa Chen",
      email: "lisa@pharmacorp.com",
      phoneNumber: "+1-555-0102",
      whatsappNumber: "+15550102",
      address: "456 Health St, CA",
      orderDate: "2025-01-28",
      status: OrderStatus.failed,
      expectedDeliveryDate: "2025-02-05",
      items: [
        OrderItem(name: "Ibuprofen", price: 200000, amount: 2),
        OrderItem(name: "Paracetamol", price: 150000, amount: 1),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Orders", style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Management", style: textTheme.headlineMedium),
            const SizedBox(height: 16),

            _buildSearchBar(),
            const SizedBox(height: 24),

            Text("Order List", style: textTheme.headlineMedium),
            const SizedBox(height: 16),

            ..._orders.map((order) {
              return OrderListItem(
                order: order,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrderDetailPage(order: order),
                    ),
                  );
                },
              );
            }),

            const SizedBox(height: 80),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: Config.primaryGreen,
        label: Text("Add New Order"),
        icon: Icon(Icons.trolley),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search orders...",
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderListItem({super.key, required this.order, required this.onTap});

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
                  Text(order.id, style: textTheme.titleLarge),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order.statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order.statusText,
                      style: textTheme.labelSmall?.copyWith(
                        color: order.statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),
              _infoRow(Icons.store_mall_directory, order.suppliersName),
              SizedBox(height: 8),
              _infoRow(Icons.calendar_month, "Order: ${order.orderDate}"),
              SizedBox(height: 8),
              _infoRow(
                Icons.inventory_2,
                "${order.totalItemsOrdered} items",
              ),
              SizedBox(height: 8),
              _infoRow(Icons.monetization_on_sharp, "Rp.${order.totalAmount}")
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Config.textSecondary),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
