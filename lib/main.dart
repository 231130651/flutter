import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas2/controller/register_controller.dart';
import 'package:tugas2/controller/login_controller.dart';
import 'package:tugas2/view/add_transaction_page.dart';
import 'package:tugas2/view/splash.dart';
import 'package:tugas2/view/login_page.dart';
import 'package:tugas2/view/register_page.dart';
import 'package:tugas2/view/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => RegisterController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/addTransaction': (context) => const AddTransactionPage(),
          '/register': (context) => const RegisterPage(),
          '/dashboard': (context) => const DashboardScreen(),
        },
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFF8F2DE),
          primaryColor: const Color(0xFFD84040),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFD84040),
            primary: const Color(0xFFD84040),
            secondary: const Color(0xFFA31D1D),
            surface: const Color(0xFFF8F2DE),
          ),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
