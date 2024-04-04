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

class AddTransaction extends StatefulWidget {
  const AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  List<String> expenses = [];
  List<String> incomes = [];
  String selectedExpense = '';
  String selectedIncome = '';
  String amount = '';
  DateTime? selectedDate;
  String extraNotes = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  bool _isCategorySelected = false;
  bool dateSelected = false;
  bool _isTransaction = true;
  bool _isValidAmount(String value) {
    // Check if the value is a valid number with at most 5 digits and not starting with zero
    RegExp regex = RegExp(r'^[1-9]\d{0,4}$');
    return regex.hasMatch(value);
  }

  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchExpensesFromServer();
  }

  void dispose() {
    // Dispose of the TextEditingController when it's no longer needed
    _controller.dispose();
    super.dispose();
  }

  void _fetchExpensesFromServer() async {
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
          incomes = List<String>.from(userData['income_cat'] ?? []);
          selectedIncome = incomes.isNotEmpty ? incomes[0] : '';
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
    String uid = _auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/icons/wallet.png',
              width: 60,
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Add Transaction',
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Container(
                height: 50,
                width: 280,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  color: Color(0xFFF6573D3),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isTransaction = true; // Switch to income side
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _isTransaction
                                ? Color(0xFFF6573D3)
                                : Colors.grey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  40), // Adjust radius as needed
                              bottomLeft: Radius.circular(
                                  40), // Adjust radius as needed
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Income',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isTransaction = false; // Switch to expense side
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_isTransaction
                                ? Color(0xFFF6573D3)
                                : Colors.grey,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  40), // Adjust radius as needed
                              bottomRight: Radius.circular(
                                  40), // Adjust radius as needed
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Expense',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 55),
                child: TextField(
                  controller: _amountController, // Use the controller
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.currency_rupee,
                      size: 35,
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100.0),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      if (_isValidAmount(value)) {
                        amount = value;
                      } else {
                        // Clear the controller if the input is invalid
                        _amountController.clear();
                        amount = '';

                        // Show a SnackBar indicating that the amount is invalid
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Enter a valid amount below 10000',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor:
                                Colors.red, // Customize background color
                            duration:
                                Duration(seconds: 3), // Adjust display duration
                            action: SnackBarAction(
                              label: 'Close', // Customize action button text
                              textColor: Colors
                                  .white, // Change action button text color
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar(); // Close the SnackBar
                              },
                            ),
                          ),
                        );
                      }
                    });
                  },

                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Select Category',
                                style: TextStyle(
                                  color:
                                      Colors.blue, // Customize title text color
                                  fontWeight:
                                      FontWeight.bold, // Add bold font weight
                                  fontSize: 18, // Customize font size
                                ),
                              ),
                              backgroundColor: Color(
                                  0xFFF6573D3), // Set background color to purple
                              content: Container(
                                width: double.maxFinite,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final currentItem = _isTransaction
                                        ? incomes[index]
                                        : expenses[index];
                                    return ListTile(
                                      title: Text(
                                        currentItem,
                                        style: TextStyle(
                                          color: Colors
                                              .black, // Customize item text color
                                          fontSize: 16,
                                          fontWeight: FontWeight
                                              .bold, // Customize item font size
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          selectedExpense = currentItem;
                                          _isCategorySelected =
                                              true; // Category selected
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(height: 5);
                                  },
                                  itemCount: _isTransaction
                                      ? incomes.length
                                      : expenses.length,
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        height: 80,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFF6573D3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(Icons.category, color: Colors.white),
                                SizedBox(width: 10),
                                // Display selected category if available, otherwise display default text
                                Text(
                                  _isCategorySelected
                                      ? selectedExpense
                                      : 'Select Category',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showCalender(context);
                      },
                      child: Container(
                        height: 80,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFF6573D3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                // Display selected date if available, otherwise display default text
                                Text(
                                  selectedDate != null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(selectedDate!)
                                      : 'Calendar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Edit Notes'),
                              content: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter your notes...',
                                ),
                                maxLines: 3,
                                onChanged: (value) {
                                  setState(() {
                                    extraNotes = value;
                                  });
                                },
                              ),
                              actions: [
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
                      },
                      child: Container(
                        height: 80,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFF6573D3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.notes_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  extraNotes.isEmpty
                                      ? 'Notes'
                                      : extraNotes.split(' ').length <= 50
                                          ? extraNotes
                                          : 'Notes (Exceeded 50 words)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 60,
                width: 200,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedDate != null) {
                      if (_isCategorySelected) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Submitting...',
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );
                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .set({
                            _isTransaction ? 'IncomeData' : 'expenseData':
                                FieldValue.arrayUnion([
                              {
                                'amount': amount.toString(),
                                'category': selectedExpense,
                                'date': selectedDate,
                                'text': selectedExpense,
                                'extraNotes': extraNotes,
                              }
                            ])
                          }, SetOptions(merge: true));
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Submitted successfully'),
                              duration: Duration(seconds: 2),
                            ),
                          );

                          // Reset the form after successful submission
                          setState(() {
                            _amountController.clear();
                            amount = '';
                            selectedDate = null;
                            selectedExpense = '';
                            extraNotes = '';
                            _isCategorySelected = false;
                          });
                        } catch (e) {
                          print("Error: $e");
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please select a category.'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please select a date.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF6573D3),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    textStyle: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> _showCalender(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900), // Update this to the earliest selectable date
      lastDate: DateTime.now(), // Update this to the latest selectable date
      // You can add other parameters as needed, such as locale, builder, etc.
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
