import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<String> expenses = []; // Initialize an empty list
  List<String> income = []; // Initialize an empty list
  String selectedExpense = ''; // Initialize an empty string
  String selectedIncome = ''; // Initialize an empty string
  String amount = '';
  @override
  void initState() {
    super.initState();
    _fetchExpensesFromServer(); // Fetch expenses from a server
  }

  // Function to fetch expenses from a server or any other source
  void _fetchExpensesFromServer() async {
    // Simulated data fetching or initialization of the expenses list
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('categories')
          .doc('item')
          .get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        setState(() {
          expenses = List<String>.from(userData['expense'] ?? []);
          selectedExpense = expenses.isNotEmpty ? expenses[0] : '';
          income = List<String>.from(userData['income_cat'] ?? []);
          selectedIncome = income.isNotEmpty ? income[0] : '';
        });
      } else {
        // Handle document not found
      }
    } catch (e) {
      // Handle errors
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Buddy'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            ButtonsTabBar(
              backgroundColor: Colors.red,
              borderWidth: 2,
              borderColor: Colors.black,
              labelStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              tabs: [
                Tab(text: 'Expense'), // Expense Tab
                Tab(text: 'Income'), // Income Tab
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Expense Tab View
                  Container(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        if (expenses.isNotEmpty)
                          Column(
                            children: [
                              DropdownButton<String>(
                                value: selectedExpense,
                                items: expenses.map((dynamic value) {
                                  return DropdownMenuItem<String>(
                                    value: value as String,
                                    child: Text(value.toString()),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedExpense = newValue!;
                                  });
                                },
                              ),
                              SizedBox(height: 20),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter Amount',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    amount = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        if (expenses.isEmpty)
                          Center(child: CircularProgressIndicator()),
                        ElevatedButton(
                            onPressed: () async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .set({
                                  'expenseData': FieldValue.arrayUnion([
                                    {
                                      'amount': amount,
                                      'expenseType': selectedExpense,
                                    }
                                  ])
                                }, SetOptions(merge: true));
                                // Success message or further handling can be added here
                              } catch (e) {
                                // Handle errors or exceptions here
                                print("Error: $e");
                              }
                            },
                            child: Text("Add income")), // Loading indicator
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                                return Center(child: Text('Document does not exist'));
                              } else {
                                final Map<String,dynamic> expenseData = snapshot.data!.data() as Map<String,dynamic>;
                                List<dynamic> expenseDataList=expenseData['expenseData'];

                                return Scaffold(
                                  appBar: AppBar(
                                    title: Text('Expense Data List'),
                                  ),
                                  body: ListView.builder(
                                    itemCount: expenseDataList.length,
                                    itemBuilder: (context, index) {
                                      final dynamic expense = expenseDataList[index];

                                      if (expense is Map<String, dynamic>) {
                                        return ListTile(
                                          title: Text('Amount: ${expense['amount']} - Type: ${expense['expenseType']}'),
                                          // Other tile settings/styles as needed
                                        );
                                      } else {
                                        return ListTile(
                                          title: Text('Invalid Expense Data'),
                                        );
                                      }
                                    },
                                  ),
                                );
                              }
                            },
                          ),
                        )

                      ],
                    ),
                  ),
                  // Income Tab View
                  Container(
                    color: Colors.grey[200],
                    child: Column(
                      children: [
                        if (income.isNotEmpty)
                          DropdownButton<String>(
                            value: selectedIncome,
                            items: income.map((dynamic value) {
                              return DropdownMenuItem<String>(
                                value: value as String,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedIncome = newValue!;
                              });
                            },
                          ),
                        if (income.isEmpty)
                          Center(
                              child:
                                  CircularProgressIndicator()), // Loading indicator
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});
}
