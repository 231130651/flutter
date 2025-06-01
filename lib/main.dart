// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tugas2/controller/register_controller.dart';
import 'package:tugas2/view/splash.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'view/login_page.dart';
import 'controller/login_controller.dart';
import 'services/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();
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
        home: SplashScreen(),
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFFF8F2DE),
          primaryColor: Color(0xFFD84040),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFFD84040),
            primary: Color(0xFFD84040),
            secondary: Color(0xFFA31D1D),
            surface: Color(0xFFF8F2DE),
          ),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
