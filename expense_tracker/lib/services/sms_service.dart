import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/transaction.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;

  // Request SMS permissions
  Future<bool> requestSmsPermission() async {
    if (await Permission.sms.isGranted) {
      print('SMS permission already granted');
      return true;
    }
    final status = await Permission.sms.request();
    print('SMS permission request result: $status');
    return status.isGranted;
  }

  // Listen for incoming SMS and parse them
  void listenForSms(void Function(Transaction?) onTransaction) {
    print('Starting SMS listener');
    try {
      telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          print('Received SMS: ${message.body}, from: ${message.address}, time: ${message.date}');
          final transaction = Transaction.fromSms(message.body ?? '');
          if (transaction == null) {
            print('Failed to parse SMS: ${message.body}');
          }
          onTransaction(transaction);
        },
        listenInBackground: false,
        onBackgroundMessage: (SmsMessage message) {
          // Optionally handle background messages if needed
        },
      );
    } catch (e) {
      print('Error setting up SMS listener: $e');
    }
  }

  // Read existing SMS (for testing)
  Future<List<Transaction>> readExistingSms() async {
    print('Reading existing SMS');
    List<Transaction> transactions = [];
    try {
      final messages = await telephony.getInboxSms(
        columns: [SmsColumn.BODY, SmsColumn.DATE, SmsColumn.ADDRESS],
      );
      print('Found ${messages.length} SMS');
      for (var message in messages) {
        print('Processing SMS: ${message.body}, from: ${message.address}, time: ${message.date}');
        final transaction = Transaction.fromSms(message.body ?? '');
        if (transaction != null) {
          transactions.add(transaction);
        } else {
          print('Failed to parse existing SMS: ${message.body}');
        }
      }
    } catch (e) {
      print('Error reading SMS: $e');
    }
    return transactions;
  }
}