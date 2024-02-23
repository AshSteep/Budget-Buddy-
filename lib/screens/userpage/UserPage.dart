import 'package:base_app/screens/pie_chart.dart';
import 'package:base_app/screens/userpage/dailytab.dart';
import 'package:base_app/screens/userpage/monthlytab.dart';
import 'package:base_app/screens/userpage/yearlytab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/LoginPage.dart';

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

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime selectedDate = DateTime.now();
  List<String> expenses = []; // Initialize an empty list
  List<String> income = []; // Initialize an empty list
  String selectedExpense = ''; // Initialize an empty string
  String selectedIncome = ''; // Initialize an empty string
  String amount = ''; // New DateTime variable for selected date
  String subject = ''; // New DateTime variable for selected date
  String extraNotes = ''; // New DateTime variable for selected date
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchExpensesFromServer(); // Fetch expenses from a server
  }

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

  Future<void> deleteIncomeRecord(String incomeRecordId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users') // Replace 'users' with your collection name
          .doc('items') // Replace 'uid' with your user's document ID
          .update({
        'IncomeData': FieldValue.arrayRemove([
          {
            'id': incomeRecordId
          } // Assuming 'id' is the field to identify records
        ])
      });
      // Optionally, display a success message or perform other actions after deletion
      print('Income record deleted successfully!');
    } catch (e) {
      // Handle errors, e.g., show an error message or handle exception
      print('Error deleting income record: $e');
    }
  }

  Future<void> deleteExpenseRecord(String expenseRecordId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users') // Replace 'users' with your collection name
          .doc('items') // Replace 'uid' with your user's document ID
          .update({
        'ExpenseData': FieldValue.arrayRemove([
          {
            'id': expenseRecordId
          } // Assuming 'id' is the field to identify records
        ])
      });
      // Optionally, display a success message or perform other actions after deletion
      print('Expense record deleted successfully!');
    } catch (e) {
      // Handle errors, e.g., show an error message or handle exception
      print('Error deleting expense record: $e');
    }
  }

  String? validateValue(int? value) {
    if (value == null) {
      return 'Value cannot be null';
    }

    if (value > 100000) {
      return 'Value must be less than or equal to 100000';
    }

    // Return null if the value is valid
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context)!.settings.arguments as String;
    print(uid);

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Color(0xFF0336FF),
        title: Text('Budget Buddy'),
        actions: <Widget>[
          PopupMenuButton(
            color: Colors.blue[900],
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  child: Container(
                    padding: EdgeInsets
                        .zero, // Removes the white space at the margins
                    color: Colors.blue[900], // Example background color
                    child: ListTile(
                      leading: Icon(
                        Icons.pie_chart,
                        color: Colors.white,
                      ),
                      title: Text(
                        'Charts',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChartPage()), // Replace PieChartPage with your actual page
                    );
                  },
                ),

                PopupMenuItem(
                  child: Container(
                    margin: EdgeInsets
                        .zero, // Removes the white space at the margins
                    color: Colors.blue[900],
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Action for the Profile
                  },
                ),
                PopupMenuItem(
                  child: Container(
                    margin: EdgeInsets.zero,
                    color: Colors.blue[900],
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    bool confirmLogout = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.grey[400],
                        title: Text('Confirm Logout'),
                        content: Text('Are you sure you want to log out?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text('Logout'),
                          ),
                        ],
                      ),
                    );

                    if (confirmLogout == true && confirmLogout) {
                      // Log out user from Firebase
                      await FirebaseAuth.instance.signOut();

                      // Redirect to login page
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                    }
                  },
                ),

                // Add more options as needed
              ];
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Daily'),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Dailytab(),
          MonthlyTab(),
          Yearlytab(),
        ],
      ),
    );
  }
}
