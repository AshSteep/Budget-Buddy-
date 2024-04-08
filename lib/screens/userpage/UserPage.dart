import 'package:base_app/Widgets/balance_widget.dart';
import 'package:base_app/Widgets/expense_widget.dart';
import 'package:base_app/Widgets/income_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  DateTime selectedDate = DateTime.now();
  List<String> expenses = []; // Initialize an empty list
  List<String> income = []; // Initialize an empty list
  String selectedExpense = ''; // Initialize an empty string
  String selectedIncome = ''; // Initialize an empty string
  String amount = ''; // New DateTime variable for selected date
  String subject = ''; // New DateTime variable for selected date
  String extraNotes = ''; // New DateTime variable for selected date
  late int selectedMonth;
  late int selectedYear;
  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now().month;
    selectedYear = DateTime.now().year;
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

  FirebaseAuth _auth = FirebaseAuth.instance;

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  void updateExpenses() {
    // Implement this method to update expenses based on the selected month and year
  }

  void _showDropDownDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose Options"),
          content: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6573D3), // Red background color for the box
                  borderRadius: BorderRadius.circular(
                      15), // You can adjust the border radius as needed
                ),
                child: DropdownButton<int>(
                  value: selectedMonth,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedMonth = newValue!;
                      // Call a method to update expenses based on the selected month
                      updateExpenses();
                    });
                  },
                  items: List.generate(12, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1, bottom: 1, left: 10, right: 0),
                        child: Text(_getMonthName(index + 1)),
                      ),
                    );
                  }),
                  style: TextStyle(
                    // Apply text style to the selected item
                    fontSize: 15, fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // You can add more styling properties as needed
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down, // You can change the icon as needed
                    color: Colors.white,
                  ),
                  elevation: 4, // Change the elevation of the dropdown menu
                  dropdownColor: Color(
                      0xFFF6573D3), // Change the background color of the dropdown menu
                  underline: Container(
                    // You can remove the underline by providing an empty Container
                    height: 0,
                    color: Colors.transparent,
                  ),
                  // You can add more properties to further customize the dropdown button
                ),
              ),
              SizedBox(width: 3),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6573D3), // Red background color for the box
                  borderRadius: BorderRadius.circular(
                      15), // You can adjust the border radius as needed
                ),
                child: DropdownButton<int>(
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedYear = newValue!;
                      // Call a method to update expenses based on the selected year
                      updateExpenses();
                    });
                  },
                  items: List.generate(10, (index) {
                    return DropdownMenuItem<int>(
                      value: DateTime.now().year - index,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0), // Adjust padding here
                        child: Text(
                          (DateTime.now().year - index).toString(),
                          style: TextStyle(
                            // Apply text style to the selected item
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            // You can add more styling properties as needed
                          ),
                        ),
                      ),
                    );
                  }),
                  style: TextStyle(
                    // Apply text style to the selected item
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    // You can add more styling properties as needed
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down, // You can change the icon as needed
                    color: Colors.white,
                  ),
                  elevation: 4, // Change the elevation of the dropdown menu
                  dropdownColor: Color(
                      0xFFF6573D3), // Change the background color of the dropdown menu
                  underline: Container(
                    // You can remove the underline by providing an empty Container
                    height: 0,
                    color: Colors.transparent,
                  ),
                  // You can add more properties to further customize the dropdown button
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = _auth.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
              SizedBox(width: 2),
              IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Confirm Logout"),
                        content: Text("Are you sure you want to log out?"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () async {
                              try {
                                // Close the dialog
                                Navigator.of(context).pop();
                                // Perform sign out
                                await FirebaseAuth.instance.signOut();
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('email', '');
                                // Navigate to login page
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              } catch (e) {
                                // Handle sign-out errors
                                print("Error signing out: $e");
                                // Perform error handling if necessary
                              }
                            },
                            child: Text("Yes"),
                          ),
                          TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: Text("No"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(top: 0), // Adjust the top padding as needed
          child: Container(
            height: MediaQuery.of(context)
                .size
                .height, // Set a fixed height for the container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  tileColor: Color.fromARGB(255, 255, 255, 255),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/icons/hacker.png',
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Ashin Steephan',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showDropDownDialog(context);
                        },
                        icon: Icon(
                          Icons.date_range_outlined,
                          color: Color(0xFFF6573D3),
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: SizedBox(
                      width: 360.0, height: 180.0, child: ExpenseTotal()),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2, // Number of tabs
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: Color(
                              0xFFF6573D3), // Background color for the selected tab indicator
                          labelColor: Color(
                              0xFFF6573D3), // Text color for the selected tab label
                          unselectedLabelColor:
                              Colors.black, // Text color for unselected tabs
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons
                                      .attach_money), // Icon for income tab
                                  SizedBox(
                                      width: 5), // Spacer between icon and text
                                  Text('Income'), // Text for income tab
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.money_off), // Icon for expense tab
                                  SizedBox(
                                      width: 5), // Spacer between icon and text
                                  Text('Expense'), // Text for expense tab
                                ],
                              ),
                            ),
                          ],
                        ),
                        // TabBarView to display different content based on selected tab
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Content for the 'Income' tab
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: IncomeWidget(
                                  month: selectedMonth,
                                  year: selectedYear,
                                ),
                              ),
                              // Content for the 'Expense' tab
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: ExpenseWidget(
                                  month: selectedMonth,
                                  year: selectedYear,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
