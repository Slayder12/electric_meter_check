import 'package:electric_meter_check/pages/meter_check_page1.dart';
import 'package:flutter/material.dart';

const backgroundColor = Color(0xFF191C1E);
const appBarTheme = Color(0xFF0E0E0E);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          color: appBarTheme,
        ),
        useMaterial3: true,
      ),
      home: const MeterCheckPage1(),
    );
  }
}
