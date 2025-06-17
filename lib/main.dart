import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas2/controller/register_controller.dart';
import 'package:tugas2/controller/login_controller.dart';
import 'package:tugas2/view/add_transaction_page.dart';
import 'package:tugas2/view/splash.dart';
import 'package:tugas2/view/login_page.dart';
import 'package:tugas2/view/register_page.dart';
import 'package:tugas2/view/dashboard_screen.dart';
import 'package:tugas2/controller/database_handler.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const InitApp());
}

class InitApp extends StatefulWidget {
  const InitApp({super.key});

  @override
  State<InitApp> createState() => _InitAppState();
}

class _InitAppState extends State<InitApp> {
  ThemeMode? _initialTheme;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final db = DatabaseHandler();
    final theme = await db.getThemeMode();
    themeNotifier.value = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    setState(() {
      _initialTheme = themeNotifier.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_initialTheme == null) {
      return const MaterialApp(home: SizedBox());
    }

    return const MyApp();
  }
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
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (context, currentMode, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFF8F2DE),
              primaryColor: const Color(0xFFD84040),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFFD84040),
                primary: const Color(0xFFD84040),
                secondary: const Color(0xFFA31D1D),
                surface: const Color(0xFFF8F2DE),
              ),
              textTheme: const TextTheme(
                bodyMedium: TextStyle(color: Colors.black),
                bodyLarge: TextStyle(color: Colors.black),
                titleMedium: TextStyle(color: Colors.black),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                labelStyle: TextStyle(color: Colors.black),
                hintStyle: TextStyle(color: Colors.black54),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black54),
                ),
              ),
            ),
            darkTheme: ThemeData.dark(),
            themeMode: currentMode,
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginPage(),
              '/addTransaction': (context) => const AddTransactionPage(),
              '/register': (context) => const RegisterPage(),
              '/dashboard': (context) => const DashboardScreen(),
            },
          );
        },
      ),
    );
  }
}
