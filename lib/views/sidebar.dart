import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final String currentRoute;
  const Sidebar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    const Color activeBg = Color(0xFF82B1FF);
    const Color sidebarBg = Color(0xFF38684F); 
    const Color textColor = Colors.white;

    return Container(
      width: 220,
      color: sidebarBg,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50,),
          _buildNavItem(
            context,
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            route: '/',
            currentRoute: currentRoute,
            activeBg: activeBg,
            textColor: textColor,
          ),
          _buildNavItem(
            context,
            icon: Icons.inventory_2_outlined,
            label: 'Inventory',
            route: '/inventory',
            currentRoute: currentRoute,
            activeBg: activeBg,
            textColor: textColor,
          ),
          _buildNavItem(
            context,
            icon: Icons.credit_card_outlined,
            label: 'Cashier/POS',
            route: '/cashier',
            currentRoute: currentRoute,
            activeBg: activeBg,
            textColor: textColor,
          ),
          _buildNavItem(
            context,
            icon: Icons.group_outlined,
            label: 'User Management',
            route: '/users',
            currentRoute: currentRoute,
            activeBg: activeBg,
            textColor: textColor,
          ),
          _buildNavItem(
            context,
            icon: Icons.local_shipping_outlined,
            label: 'Suppliers',
            route: '/supplier',
            currentRoute: currentRoute,
            activeBg: activeBg,
            textColor: textColor,
          ),
          _buildNavItem(
            context,
            icon: Icons.shopping_cart_outlined,
            label: 'Purchase Orders',
            route: '/orders',
            currentRoute: currentRoute,
            activeBg: activeBg,
            textColor: textColor,
          ),
          _buildNavItem(
            context,
            icon: Icons.attach_money_outlined,
            label: 'Transaction Summary',
            route: '/transactions',
            currentRoute: currentRoute,
            activeBg: activeBg,
            textColor: textColor,
          ),
          _buildNavItem(
            context,
            icon: Icons.shield_outlined,
            label: 'Audit Log',
            route: '/audit',
            currentRoute: currentRoute,
            activeBg: activeBg,
            textColor: textColor,
          ),
          _buildNavItem(
            context,
            icon: Icons.article_outlined,
            label: 'Reports',
            route: '/reports',
            currentRoute: currentRoute,
            activeBg: activeBg,
            textColor: textColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required String currentRoute,
    required Color activeBg,
    required Color textColor,
  }) {
    final bool isActive = route == currentRoute;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (!isActive) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          decoration: BoxDecoration(
            color: isActive ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: textColor, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight:
                        isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
