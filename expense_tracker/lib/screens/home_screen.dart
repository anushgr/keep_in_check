import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/sms_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Periodic debug print to confirm console is active
    Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 5));
      print('Debug: App is running');
      return true;
    });
    final smsService = Provider.of<SmsService>(context, listen: false);
    smsService.requestSmsPermission().then((granted) {
      print('SMS Permission Granted: $granted');
      if (!granted) {
        openAppSettings();
      } else {
        // Read existing SMS for debugging
        smsService.readExistingSms().then((transactions) {
          print('Read ${transactions.length} transactions');
          for (var transaction in transactions) {
            print('Existing transaction: ${transaction.toJson()}');
          }
        });
        smsService.listenForSms((transaction) {
          if (transaction != null) {
            print('New transaction: ${transaction.toJson()}');
          } else {
            print('Failed to parse SMS');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expense Tracker')),
      body: const Center(
        child: Text('Welcome to Expense Tracker'),
      ),
    );
  }
}