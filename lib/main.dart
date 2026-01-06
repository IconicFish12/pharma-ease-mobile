import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobile_course_fp/config/config.dart';
import 'package:mobile_course_fp/data/model/medicine_model.dart';
import 'package:mobile_course_fp/data/provider/activity_log_provider.dart';
import 'package:mobile_course_fp/data/provider/auth_provider.dart';
import 'package:mobile_course_fp/data/provider/medicine_category_provider.dart';
import 'package:mobile_course_fp/data/provider/medicine_order_provider.dart';
import 'package:mobile_course_fp/data/provider/medicine_provider.dart';
import 'package:mobile_course_fp/data/provider/supplier_provider.dart';
import 'package:mobile_course_fp/data/provider/user_provider.dart';
import 'package:mobile_course_fp/data/repository/auth_repository.dart';
import 'package:mobile_course_fp/data/repository/medicine_category_repository.dart';
import 'package:mobile_course_fp/data/repository/medicine_order_repository.dart';
import 'package:mobile_course_fp/data/repository/medicine_repository.dart';
import 'package:mobile_course_fp/data/repository/service/token_service.dart';
import 'package:mobile_course_fp/data/repository/supplier_repository.dart';
import 'package:mobile_course_fp/data/repository/user_repository.dart';
import 'package:mobile_course_fp/firebase_options.dart';
import 'package:mobile_course_fp/views/activity-log/activity_log.dart';
import 'package:mobile_course_fp/views/auth/forgot_password.dart';
import 'package:mobile_course_fp/views/auth/login.dart';
import 'package:mobile_course_fp/views/auth/send_email.dart';
import 'package:mobile_course_fp/views/cashier/cashier_menu.dart';
import 'package:mobile_course_fp/views/cashier/cashier_model.dart';
import 'package:mobile_course_fp/views/cashier/receipt.dart';
import 'package:mobile_course_fp/views/cashier/transaction_detail.dart';
import 'package:mobile_course_fp/views/cashier/transaction_summary.dart';
import 'package:mobile_course_fp/views/reports/home.dart';
import 'package:mobile_course_fp/views/medicine/medicine_detail.dart';
import 'package:mobile_course_fp/views/medicine/medicine_list.dart';
import 'package:mobile_course_fp/views/notifications.dart';
import 'package:mobile_course_fp/views/order/order_detail.dart';
import 'package:mobile_course_fp/views/order/order_list.dart';
import 'package:mobile_course_fp/views/order/order_model.dart';
import 'package:mobile_course_fp/views/reports/financial_report.dart';
import 'package:mobile_course_fp/views/reports/medicine_report.dart';
import 'package:mobile_course_fp/views/reports/reports.dart';
import 'package:mobile_course_fp/views/splash_screen.dart';
import 'package:mobile_course_fp/views/suppliers/View/supplier_list.dart';
import 'package:mobile_course_fp/views/users/profile_page.dart';
import 'package:mobile_course_fp/views/users/user_management_page.dart';
import 'package:mobile_course_fp/views/suppliers/ViewModel/supplier_viewmodel.dart';
import 'package:mobile_course_fp/views/medicine/medicine-category/ViewModel/medicine_category_viewmodel.dart';
import 'package:provider/provider.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenService = TokenService();
  final authRepository = AuthRepository(tokenService);

  try {
    print("DEBUG: Mulai inisialisasi Firebase...");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("DEBUG: Firebase Berhasil Connect!");
    print("DEBUG: Firebase Berhasil Connect!");
  } catch (e) {
    print("DEBUG: Error Firebase => $e");
    print("DEBUG: Error Firebase => $e");
  }

  print("DEBUG: Mulai inisialisasi Date Formatting...");
  print("DEBUG: Mulai inisialisasi Date Formatting...");
  await initializeDateFormatting('id_ID', '');

  print("DEBUG: Menjalankan runApp...");

  print("DEBUG: Menjalankan runApp...");

  runApp(
    MultiProvider(
      providers: [
        // ViewModel 
        ChangeNotifierProvider(create: (_) => SupplierViewModel()),
        ChangeNotifierProvider(create: (_) => MedicineCategoryViewmodel()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authRepository, tokenService),
        ),
        ChangeNotifierProvider(
          create: (_) => ActivityLogProvider(tokenService),
        ),
        ChangeNotifierProvider(
          create: (_) => MedicineProvider(MedicineRepository(tokenService)),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              MedicineOrderProvider(MedicineOrderRepository(tokenService)),
        ),
        ChangeNotifierProvider(
          create: (_) => MedicineCategoryProvider(
            MedicineCategoryRepository(tokenService),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SupplierProvider(SupplierRepository(tokenService)),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(UserRepository(tokenService)),
        ),
      ],
      child: const MyApp(),
    ),
  );
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
          name: 'Login',
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          name: 'ForgotPassword',
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          name: 'SendEmail',
          path: '/send-email',
          builder: (context, state) => const SendEmailPage(),
        ),
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
          name: 'MedicineDetail',
          path: '/medicine-detail',
          builder: (context, state) {
            final med = state.extra as Datum;
            return MedicineDetail(medicine: med);
          },
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
    //   home: LoginPage(),
    // );
  }
}
