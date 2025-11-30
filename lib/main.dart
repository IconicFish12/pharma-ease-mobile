import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/firebase_options.dart';
import 'package:mobile_course_fp/views/activity_log.dart';
import 'package:mobile_course_fp/views/cashier/cashier_menu.dart';
import 'package:mobile_course_fp/views/cashier/cashier_model.dart';
import 'package:mobile_course_fp/views/cashier/receipt.dart';
import 'package:mobile_course_fp/views/cashier/transaction_detail.dart';
import 'package:mobile_course_fp/views/cashier/transaction_summary.dart';
import 'package:mobile_course_fp/views/home.dart';
import 'package:mobile_course_fp/views/medicine/medicine_list.dart';
import 'package:mobile_course_fp/views/notifications.dart';
import 'package:mobile_course_fp/views/order/order_detail.dart';
import 'package:mobile_course_fp/views/order/order_list.dart';
import 'package:mobile_course_fp/views/order/order_model.dart';
import 'package:mobile_course_fp/views/reports/financial_report.dart';
import 'package:mobile_course_fp/views/reports/medicine_report.dart';
import 'package:mobile_course_fp/views/reports/reports.dart';
import 'package:mobile_course_fp/views/splash_screen.dart';
import 'package:mobile_course_fp/views/suppliers/supplier_list.dart';
import 'package:mobile_course_fp/views/users/profile_page.dart';
import 'package:mobile_course_fp/views/users/user_management_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    demoProjectId: 'pharma-ease',
    name: 'pharma-ease',
  );

  initializeDateFormatting('id_ID', '').then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {    
     final Config config = Config();
    final router = GoRouter(
      restorationScopeId: 'router',
      routerNeglect: true,
      routes: [
        GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
        GoRoute(
          path: '/home',
          name: 'Home',
          builder: (context, state) => const HomePage(),
        ),
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
              path: 'medicine-order',
              builder: (context, state) => const OrderList(),
            ),
            GoRoute(
              name: 'OrderDetail',
              path: 'order-detail',
              builder: (context, state) {
                final order = state.extra as Order;
                return OrderDetailPage(order: order);
              },
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
              path: 'profile',
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
              name: 'TransactionSummary',
              path: 'transaction-summary',
              builder: (context, state) => const TransactionSummary(),
            ),
            GoRoute(
              name: 'TransactionDetail',
              path: 'detail',
              builder: (context, state) {
                final cartItems = state.extra as List<CartItem>?;
                return TransactionDetailPage(cartItems: cartItems ?? []);
              },
            ),
            
            GoRoute(
              name: 'Receipt',
              path: 'receipt', 
              builder: (context, state) {
                final transaction = state.extra as Transaction;
                return ReceiptPage(transaction: transaction);
              },
            ),
          ],
        ),
        GoRoute(
          name: 'Reports',
          path: '/reports',
          builder: (context, state) => const Reports(),
          routes: [
            GoRoute(
              name: 'FinancialReport',
              path: 'financial-report',
              builder: (context, state) => const FinancialReport(),
            ),
            GoRoute(
              name: 'MedicineReport',
              path: 'medicine-report',
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
      routerConfig: router,
      restorationScopeId: 'app',

    );
    // return MaterialApp(
    //   title: 'PharmaEase',
    //   debugShowCheckedModeBanner: false,
    //   theme: config.getAppTheme(),
    //   home: UserManagementPage(),
    // );
  }
}
