enum TransactionType { income, expense }

class Transaction {
  final double amount;
  final DateTime dateTime;
  final String category;
  final String? fromWhom; // For income
  final String? toWhom; // For expense
  final String? description;
  final TransactionType type;

  Transaction({
    required this.amount,
    required this.dateTime,
    required this.category,
    this.fromWhom,
    this.toWhom,
    this.description,
    required this.type,
  });

  // Convert Transaction to JSON for sending to Flask backend
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'dateTime': dateTime.toIso8601String(),
      'category': category,
      'fromWhom': fromWhom,
      'toWhom': toWhom,
      'description': description,
      'type': type.toString().split('.').last,
    };
  }

  // Create Transaction from SMS
  static Transaction? fromSms(String smsBody) {
    print('Parsing SMS: $smsBody'); // Debug line
    try {
      final regExp = RegExp(
          r'(Received|Spent) \$(\d+\.?\d*) (from|to) (\w+) on (\d{4}-\d{2}-\d{2} \d{2}:\d{2} [AP]M), category: (\w+)');
      final match = regExp.firstMatch(smsBody);
      if (match == null) {
        print('No regex match for SMS: $smsBody'); // Debug line
        return null;
      }

      final type = match.group(1) == 'Received' ? TransactionType.income : TransactionType.expense;
      final amount = double.parse(match.group(2)!);
      final dateTime = DateTime.parse(match.group(5)!.replaceAll(' AM', '').replaceAll(' PM', ''));
      final fromTo = match.group(4)!;
      final category = match.group(6)!;

      return Transaction(
        amount: amount,
        dateTime: dateTime,
        category: category,
        fromWhom: type == TransactionType.income ? fromTo : null,
        toWhom: type == TransactionType.expense ? fromTo : null,
        type: type,
      );
    } catch (e) {
      print('Error parsing SMS: $e');
      return null;
    }
  }
}