import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenseWidget extends StatefulWidget {
  final dynamic month;
  final dynamic year;
  ExpenseWidget({required this.month, required this.year});

  @override
  State<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends State<ExpenseWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('users').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final expenseData = snapshot.data!.docs.first['expenseData'];
        final groupedExpenses =
            _groupExpensesByDate(expenseData, widget.month, widget.year);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: groupedExpenses.map((group) {
              final date = group['date'];
              final expensesForDate = group['expenses'];
              final totalExpense = _calculateTotalExpense(expensesForDate);

              return Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10, bottom: 10),
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 204, 214, 219),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _formatDate(date),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(width: 120),
                          Expanded(
                            child: Text(
                              'Total: ₹ $totalExpense',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.blueGrey),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: expensesForDate.map<Widget>((expense) {
                          final amount = _parseAmount(expense['amount']);
                          final text = expense['text'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/expense.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '$text',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '₹ $amount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _groupExpensesByDate(
      List<dynamic> expenseData, month, year) {
    Map<String, List<Map<String, dynamic>>> groupedExpenses = {};

    // Get the current month and year

    final currentYear = year;
    final currentMonth = month;

    for (var data in expenseData) {
      final timestamp = data['date'] as Timestamp;
      final date =
          DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

      // Check if the expense is in the current month
      if (date.year == currentYear && date.month == currentMonth) {
        final dateString =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        if (groupedExpenses.containsKey(dateString)) {
          groupedExpenses[dateString]!.add(data);
        } else {
          groupedExpenses[dateString] = [data];
        }
      }
    }

    List<Map<String, dynamic>> result = [];
    List<String> sortedKeys = groupedExpenses.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

    for (var key in sortedKeys) {
      final dateParts = key.split('-').map(int.parse).toList();
      final date = DateTime(dateParts[0], dateParts[1], dateParts[2]);
      result.add({'date': date, 'expenses': groupedExpenses[key]});
    }

    return result;
  }

  int _calculateTotalExpense(List<Map<String, dynamic>> expenses) {
    int totalExpense = 0;
    for (var expense in expenses) {
      totalExpense += _parseAmount(expense['amount']);
    }
    return totalExpense;
  }

  String _formatDate(DateTime date) {
    return '${_getDayOfWeek(date)}, ${date.day}';
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  int _parseAmount(dynamic value) {
    if (value == null) return 0; // Handle null values
    if (value is int) return value; // If the value is already an integer

    final parsedValue = int.tryParse(value.toString());
    return parsedValue ?? 0; // Return 0 if the parsing fails
  }
}
