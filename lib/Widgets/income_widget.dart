import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IncomeWidget extends StatefulWidget {
  final dynamic month;
  final dynamic year;
  IncomeWidget({required this.month, required this.year});

  @override
  State<IncomeWidget> createState() => _IncomeWidgetState();
}

class _IncomeWidgetState extends State<IncomeWidget> {
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

        final IncomeData = snapshot.data!.docs.first['IncomeData'];
        final groupedIncomes =
            _groupIncomesByDate(IncomeData, widget.month, widget.year);
        print('groupedIncomes: $groupedIncomes');

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: groupedIncomes.map((group) {
              final date = group['date'];
              final IncomesForDate = group['Incomes'];
              print('This is the exp $IncomesForDate');
              final totalIncome = _calculateTotalIncome(IncomesForDate);

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
                              'Total:  ₹ $totalIncome',
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
                        children: IncomesForDate.map<Widget>((Income) {
                          final amount = _parseAmount(Income['amount']);
                          final text = Income['text'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.category,
                                      size: 18,
                                      color: Colors.black,
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
                                  ' ₹ $amount',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
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

  List<Map<String, dynamic>> _groupIncomesByDate(
      List<dynamic> IncomeData, dynamic month, dynamic year) {
    Map<String, List<Map<String, dynamic>>> groupedIncomes = {};

    // Get the current month and year

    final currentYear = year;
    final currentMonth = month;

    for (var data in IncomeData) {
      final timestamp = data['date'] as Timestamp?;
      if (timestamp == null) continue; // Skip if 'date' is null
      final date =
          DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

      // Check if the expense is in the current month
      if (date.year == currentYear && date.month == currentMonth) {
        final dateString =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        if (groupedIncomes.containsKey(dateString)) {
          groupedIncomes[dateString]!.add(data);
        } else {
          groupedIncomes[dateString] = [data];
        }
      }
    }

    List<Map<String, dynamic>> result = [];
    List<String> sortedKeys = groupedIncomes.keys.toList()
      ..sort((a, b) => DateTime.parse(b).compareTo(DateTime.parse(a)));

    for (var key in sortedKeys) {
      final dateParts = key.split('-').map(int.parse).toList();
      final date = DateTime(dateParts[0], dateParts[1], dateParts[2]);
      result.add({'date': date, 'Incomes': groupedIncomes[key]});
    }

    return result;
  }

  int _calculateTotalIncome(List<dynamic> Income) {
    int totalIncome = 0;
    for (var income in Income) {
      totalIncome += _parseAmount(income['amount']);
    }
    return totalIncome;
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
