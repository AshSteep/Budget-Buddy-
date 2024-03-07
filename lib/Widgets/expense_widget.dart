import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExpenseWidget extends StatelessWidget {
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
        final groupedExpenses = _groupExpensesByDate(expenseData);

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
                              'Total: - ₹ $totalExpense',
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
                          final amount = int.parse(expense['amount']);
                          final text = expense['text'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.category, // Icon for category
                                      size: 18, // Adjust size as needed
                                      color: Colors.black, // Icon color
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ), // Adjust spacing between icon and text
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
                                  '- ₹ $amount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(), // Convert the mapped list to a list of Widgets
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

  List<Map<String, dynamic>> _groupExpensesByDate(List<dynamic> expenseData) {
    Map<String, List<Map<String, dynamic>>> groupedExpenses = {};

    for (var data in expenseData) {
      final timestamp = data['date'] as Timestamp;
      final date =
          DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

      // Format the date as a string to be used as the key in the map
      final dateString = '${date.year}-${date.month}-${date.day}';

      if (groupedExpenses.containsKey(dateString)) {
        groupedExpenses[dateString]!.add(data);
      } else {
        groupedExpenses[dateString] = [data];
      }
    }

    List<Map<String, dynamic>> result = [];
    groupedExpenses.forEach((key, value) {
      // Parse the date string back to DateTime
      final dateParts = key.split('-').map(int.parse).toList();
      final date = DateTime(dateParts[0], dateParts[1], dateParts[2]);
      result.add({'date': date, 'expenses': value});
    });

    return result;
  }

  int _calculateTotalExpense(List<Map<String, dynamic>> expenses) {
    int totalExpense = 0;
    for (var expense in expenses) {
      totalExpense += int.parse(expense['amount']);
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
}
