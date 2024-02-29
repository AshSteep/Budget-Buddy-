import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: FutureBuilder<QuerySnapshot>(
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

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: groupedExpenses.length,
              itemBuilder: (context, index) {
                final date = groupedExpenses.keys.elementAt(index);
                final expensesForDate = groupedExpenses[date]!;
                final totalExpense = _calculateTotalExpense(expensesForDate);

                return Padding(
                  padding: const EdgeInsets.all(15.0),
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
                            Text(
                              _formatDate(date),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Total: - ₹ $totalExpense',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.blueGrey),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: expensesForDate.map((expense) {
                            final amount = int.parse(expense['amount']);
                            final text = expense['text'];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '$text',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
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
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Map<DateTime, List<Map<String, dynamic>>> _groupExpensesByDate(
      List<dynamic> expenseData) {
    Map<DateTime, List<Map<String, dynamic>>> groupedExpenses = {};

    for (var data in expenseData) {
      final timestamp = data['date'] as Timestamp;
      final date =
          DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

      if (!groupedExpenses.containsKey(date)) {
        groupedExpenses[date] = [];
      }
      groupedExpenses[date]!.add(data);
    }

    return groupedExpenses;
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
