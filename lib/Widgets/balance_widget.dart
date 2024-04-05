import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseTotal extends StatefulWidget {
  @override
  State<ExpenseTotal> createState() => _ExpenseTotalState();
}

class _ExpenseTotalState extends State<ExpenseTotal> {
  int totalExpense = 0;
  int totalIncome = 0;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser!.uid;
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          color: Color(0xFFF6573D3), borderRadius: BorderRadius.circular(20)),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Total Balance ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          '₹ ${totalIncome - totalExpense}',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_downward,
                        size: 12,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    children: [
                      Text(
                        'Income Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text('No data available');
                            }

                            // Extract expenses data from the user document
                            Map<String, dynamic> userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            int sum = 0;
                            List<dynamic> Incomes =
                                userData['IncomeData'] ?? [];
                            Incomes.forEach((e) {
                              print(e['date'].toDate());
                              print("Full");
                              if (e['date'].toDate().isAfter(firstDayOfMonth) &&
                                  e['date'].toDate().isBefore(lastDayOfMonth)) {
                                print(e['date'].toDate());
                                sum = sum + (int.parse(e['amount']));
                                totalIncome = sum;
                              }
                            });
                            print(sum);

                            return Text(
                              '₹ $sum',
                              style: TextStyle(
                                color: Color(0xFFFFBFCFE),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_upward,
                        size: 12,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Column(
                    children: [
                      Text(
                        'Expense Total',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Center(
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text('No data available');
                            }

                            // Extract expenses data from the user document
                            Map<String, dynamic> userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            int sum = 0;
                            List<dynamic> expenses =
                                userData['expenseData'] ?? [];
                            expenses.forEach((e) {
                              print(e['date'].toDate());
                              print("Full");
                              if (e['date'].toDate().isAfter(firstDayOfMonth) &&
                                  e['date'].toDate().isBefore(lastDayOfMonth)) {
                                print(e['date'].toDate());
                                sum = sum + (int.parse(e['amount']));
                                totalExpense = sum;
                              }
                            });
                            print(sum);
                            // Calculate total expense

                            return Text(
                              '₹ $sum',
                              style: TextStyle(
                                color: Color(0xFFFFBFCFE),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  )
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}
