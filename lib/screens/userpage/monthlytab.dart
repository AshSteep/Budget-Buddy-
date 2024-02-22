import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Transaction {
  final DateTime date;
  final double amount;
  final String description;
  final String category;

  Transaction({
    required this.date,
    required this.amount,
    required this.description,
    required this.category,
  });
}

class MonthlyTab extends StatefulWidget {
  const MonthlyTab({super.key});

  @override
  State<MonthlyTab> createState() => _MonthlyTabState();
}

class _MonthlyTabState extends State<MonthlyTab> {
  DateTime selectedDate = DateTime.now();

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked; // Update the selected date
      });
    }
  }

  selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser!.uid;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Colors.blue[900],
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              height: 40,
              width: double.infinity,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  selectDate(context);
                },
                child: Text(
                  DateFormat('MMMM y').format(selectedDate),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('Document does not exist'));
                } else {
                  final Map<String, dynamic>? incomeData =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  if (incomeData == null ||
                      !incomeData.containsKey('IncomeData')) {
                    return Center(child: Text('No Income Data Found'));
                  }

                  List<dynamic> incomeDataList = incomeData['IncomeData'];

                  // Filter the income data based on the selected month
                  incomeDataList = incomeDataList.where((income) {
                    if (income is Map<String, dynamic>) {
                      DateTime incomeDate = income['date'].toDate();
                      return incomeDate.month == selectedDate.month &&
                          incomeDate.year == selectedDate.year;
                    }
                    return false;
                  }).toList();

                  // Sort by date
                  incomeDataList.sort((a, b) {
                    DateTime dateA = a['date'].toDate();
                    DateTime dateB = b['date'].toDate();
                    return dateA.compareTo(dateB);
                  });

                  return ListView.separated(
                    itemCount: incomeDataList.length,
                    itemBuilder: (context, index) {
                      final dynamic income = incomeDataList[index];
                      if (income is Map<String, dynamic>) {
                        DateTime date = income['date'].toDate();
                        // ignore: unused_local_variable
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(date);
                        return SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${income['text']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${income['incomeType']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.currency_rupee,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Text(
                                    '${income['amount']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text(
                              'Invalid Income Data',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.grey,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
