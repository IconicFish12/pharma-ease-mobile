import 'package:flutter/material.dart';
import 'package:mobile_course_fp/views/order/order_model.dart';
import 'package:mobile_course_fp/config/config.dart';

class OrderDetailPage extends StatelessWidget {
  final Order order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(order.id, style: textTheme.titleLarge),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Config.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.suppliersName, style: textTheme.headlineMedium),
                    SizedBox(height: 4),
                    Text("Order to ${order.suppliersName}",
                        style: textTheme.bodyMedium),
                    Divider(height: 24),

                    _buildDetailRow(
                      context,
                      Icons.person_outline,
                      "Contact",
                      order.contactPerson,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.email_outlined,
                      "Email",
                      order.email,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.location_on_outlined,
                      "Address",
                      order.address,
                      isAddress: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text("Order Info", style: textTheme.titleLarge),
            const SizedBox(height: 12),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow(
                      context,
                      Icons.calendar_month_outlined,
                      "Order Date",
                      order.orderDate,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.calendar_today_outlined,
                      "Delivery",
                      order.expectedDeliveryDate,
                    ),
                    _buildDetailRow(
                      context,
                      Icons.inventory_2_outlined,
                      "Total Items",
                      "${order.totalItemsOrdered}",
                    ),
                    _buildDetailRow(
                      context,
                      Icons.payments_outlined,
                      "Amount",
                      "\Rp.${order.totalAmount}",
                    ),
                    _buildDetailRow(
                      context,
                      Icons.info_outline,
                      "Status",
                      order.statusText,
                      statusColor: order.statusColor,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24),

            Text("Ordered Items", style: textTheme.titleLarge),
            SizedBox(height: 12),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: order.items
                      .map((item) => Padding(
                          padding:  EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.name,
                                  style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600)),
                              Text("${item.amount} pcs • \Rp.${item.price}",
                                  style: textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    Color? statusColor,
    bool isAddress = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Config.textSecondary),
          const SizedBox(width: 12),
          SizedBox(
            width: 90,
            child: Text(label, style: textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(
                color: statusColor ?? Config.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: isAddress ? 3 : 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
