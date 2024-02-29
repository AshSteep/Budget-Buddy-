import 'package:base_app/screens/userpage/expense_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser?.uid;

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
                      SizedBox(
                        width: 120,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.lightBlue,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: DropdownButton<String>(
                              value: 'This Month',
                              onChanged: (String? newValue) {},
                              items: <String>[
                                'This Month',
                                'This Day',
                                'This Year'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                              }).toList(),
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              elevation: 8,
                              underline: Container(),
                              isExpanded: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Center(
                  child: SizedBox(
                    width: 360.0,
                    height: 180.0,
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF6573D3),
                          borderRadius: BorderRadius.circular(10),
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
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 0),
                    child: Text(
                      'Expense List',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  // Wrap ExpenseWidget with Expanded to occupy remaining space
                  child: SingleChildScrollView(
                    // Wrap with SingleChildScrollView
                    child: ExpenseWidget(), // Make the ExpenseWidget scrollable
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext context) {
                // List to track button selection
                List<bool> isSelected = [true, false];
                return ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  child: Container(
                    height: 330,
                    width: 100,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ToggleButtons(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    'Income',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    'Expense',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                              isSelected: isSelected,
                              onPressed: (int newIndex) {
                                setState(() {
                                  for (int index = 0;
                                      index < isSelected.length;
                                      index++) {
                                    isSelected[index] = index == newIndex;
                                  }
                                });
                              },
                              color:
                                  Colors.grey.withOpacity(0.8), // Set the color
                              selectedColor:
                                  Colors.blue, // Set the color when selected
                              borderRadius: BorderRadius.circular(
                                  30), // Set the border radius
                              borderWidth: 2, // Set the border width
                              selectedBorderColor: Colors
                                  .blue, // Set the border color when selected
                              disabledBorderColor: Colors.grey.withOpacity(
                                  0.5), // Set the border color when disabled
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Image.asset('assets/icons/categories.png',
                                width: 30, height: 30),
                            SizedBox(width: 10),
                            Expanded(
                                child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Enter Amount',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType
                                  .number, // Set keyboard type to number
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter
                                    .digitsOnly // Accept only digits
                              ],
                            )),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter text',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Image.asset('assets/icons/calendar.png',
                                width: 30, height: 30),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ), // Spacer to push the ElevatedButton to the bottom
                        SizedBox(
                          width: 300,
                          height:
                              50, // Make the button fill the width of the container
                          child: ElevatedButton(
                            onPressed: () {
                              // Add your onPressed functionality here
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.green, // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Rounded corners
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12.0), // Padding inside button
                              child: Text(
                                'Submit',
                                style: TextStyle(fontSize: 16), // Text style
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.lightBlue, // Set the background color
          child: Icon(Icons.add), // Set the icon
        ),
      ),
    );
  }
}
