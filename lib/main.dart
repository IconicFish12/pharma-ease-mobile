import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/views/activity_log.dart';
import 'package:mobile_course_fp/views/cashier/cashier_menu.dart';
import 'package:mobile_course_fp/views/cashier/transaction_summary.dart';
import 'package:mobile_course_fp/views/home.dart';
import 'package:mobile_course_fp/views/medicine/medicine_list.dart';
import 'package:mobile_course_fp/views/notifications.dart';
import 'package:mobile_course_fp/views/reports/financial_report.dart';
import 'package:mobile_course_fp/views/reports/medicine_report.dart';
import 'package:mobile_course_fp/views/reports/reports.dart';
import 'package:mobile_course_fp/views/suppliers/medicine_supplies.dart';
import 'package:mobile_course_fp/views/suppliers/supplier_list.dart';
import 'package:mobile_course_fp/views/users/profile_page.dart';
// import 'package:mobile_course_fp/views/splash_screen.dart';
import 'package:mobile_course_fp/views/users/user_management_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {    
    final Config config = Config();
    final _router = GoRouter(
      restorationScopeId: 'router',
      routerNeglect: true,
      routes: [
        GoRoute(path: '/', builder: (context, state) => const HomePage()),
        GoRoute(
          name: 'MedicineInventory',
          path: '/inventory',
          builder: (context, state) => const MedicineList(),
        ),
        GoRoute(
          name: 'MedicineSupplier',
          path: '/suppliers',
          builder: (context, state) => const SupplierList(),
          routes: [
            GoRoute(
              name: 'SuppliersOrder',
              path: '/medicine-order',
              builder: (context, state) => const MedicineSuppliesOrder(),
            ),
          ],
        ),
        GoRoute(
          name: 'UserManage',
          path: '/users',
          builder: (context, state) => const UserManagementPage(),
          routes: [
            GoRoute(
              name: 'UserProfile',
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
        GoRoute(
          name: 'ActivityLog',
          path: '/activityLog',
          builder: (context, state) => const ActivityLog(),
        ),
        GoRoute(
          name: 'Notifications',
          path: '/notifications',
          builder: (context, state) => const Notifications(),
        ),
        GoRoute(
          name: 'Cashier',
          path: '/cashier',
          builder: (context, state) => const CashierMenu(),
          routes: [
            GoRoute(
              name: 'Transaction-summary',
              path: '/transaction-summary',
              builder: (context, state) => const TransactionSummary(),
            ),
          ],
        ),
        GoRoute(
          name: 'Reports',
          path: '/reports',
          builder: (context, state) => const Reports(),
          routes: [
            GoRoute(
              name: 'Financial-report',
              path: '/financial-report',
              builder: (context, state) => const FinancialReport(),
            ),
            GoRoute(
              name: 'Medicine-report',
              path: '/medicine-report',
              builder: (context, state) => const MedicineReport(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'PharmaEase',
      debugShowCheckedModeBanner: false,
      theme: config.getAppTheme(),
      routerConfig: _router,
      restorationScopeId: 'app',
    );
  }
}
