import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/sms_service.dart';
import 'screens/home_screen.dart';

void main() {
  print('App starting'); // Debug line
  runApp(
    MultiProvider(
      providers: [
        Provider<SmsService>(create: (_) => SmsService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}