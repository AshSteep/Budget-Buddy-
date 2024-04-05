import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseTotal extends StatefulWidget {
  @override
  State<ExpenseTotal> createState() => _ExpenseTotalState();
}

class _ExpenseTotalState extends State<ExpenseTotal> {
  int totalExp = 0;
  int totalIncome = 0;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser!.uid;
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    return Card(
      color: Color(0xFFF6573D3),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Expense Total',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                      List<dynamic> expenses = userData['expenseData'] ?? [];
                      expenses.forEach((e) {
                        print(e['date'].toDate());
                        print("Full");
                        if (e['date'].toDate().isAfter(firstDayOfMonth) &&
                            e['date'].toDate().isBefore(lastDayOfMonth)) {
                          print(e['date'].toDate());
                          sum = sum + (int.parse(e['amount']));
                          totalExp = sum;
                        }
                      });
                      print(sum);
                      // Calculate total expense

                      return Text(
                        '₹ $sum',
                        style: TextStyle(
                          color: Color(0xFFFFBFCFE),
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                Center(
                  child: Text(
                    'Income Total',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(height: 5),
                Center(
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                      List<dynamic> Incomes = userData['IncomeData'] ?? [];
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
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  children: [
                    Center(
                      child: Text(
                        'Balance ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${totalIncome - totalExp}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
