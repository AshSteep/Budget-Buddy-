import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import package for date formatting

class ExpenseTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser!.uid;
    return Card(
      color: Color(0xFFF6573D3),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/money.png'),
                  alignment: Alignment.topRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expense Total',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('expenseData')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    // Filter expenses for the current month
                    final currentMonthExpenses =
                        snapshot.data!.docs.where((expense) {
                      DateTime expenseDate =
                          (expense['date'] as Timestamp).toDate();
                      return expenseDate.year == DateTime.now().year &&
                          expenseDate.month == DateTime.now().month;
                    });

                    // Calculate total expense for the current month
                    int totalExpense = 0;
                    currentMonthExpenses.forEach((expense) {
                      totalExpense += (expense['amount'] ?? 0) as int;
                    });

                    return Text(
                      '₹ $totalExpense',
                      style: TextStyle(
                        color: Color(0xFFFFBFCFE),
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      width: 60.0,
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFFDB6565),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      padding: EdgeInsets.all(4.0),
                      child: Center(
                        child: Text(
                          '+ ₹ 240 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Than last month ',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
