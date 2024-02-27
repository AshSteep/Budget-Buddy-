import 'package:base_app/screens/Statistics.dart';
import 'package:base_app/screens/userpage/dailytab.dart';
import 'package:base_app/screens/userpage/monthlytab.dart';
import 'package:base_app/screens/userpage/yearlytab.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    //HomePage(), // First page (Home Page)
    ChartPage(), // Second page (Pie Chart Page)
    Container(color: Colors.blue), // Third page
    Container(color: Colors.yellow), // Fourth page
  ];
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              Image.asset(
                'assets/icons/wallet.png',
                width: 60,
                height: 40,
              ),
              SizedBox(width: 0), // Add some spacing between the icon and text
              Text(
                'Budget Buddy',
                style: TextStyle(
                  color: const Color.fromARGB(255, 30, 28, 28),
                  fontSize: 23,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(), // This will push the IconButton to the right side
              IconButton(
                icon: Image.asset(
                  'assets/icons/user.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {}, // Empty onPressed action
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
      body: Container()
    );
  }
}
