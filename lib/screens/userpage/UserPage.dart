import 'package:base_app/Widgets/expense_total_widget.dart';
import 'package:base_app/Widgets/expense_widget.dart';
import 'package:base_app/screens/userpage/addtransaction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                            color: Color(0xFFF6573D3),
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
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
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
                                color: Colors.white,
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
                Row(
                  children: [
                    DropdownButton<int>(
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
                          child: Text(_getMonthName(index + 1)),
                        );
                      }),
                    ),
                    SizedBox(width: 10),
                    DropdownButton<int>(
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
                          child: Text((DateTime.now().year - index).toString()),
                        );
                      }),
                    ),
                  ],
                ),
                Center(
                  child: SizedBox(
                      width: 360.0, height: 180.0, child: ExpenseTotal()),
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
                SizedBox(height: 5),
                SizedBox(
                  height: 410, // Define the desired height
                  child: SingleChildScrollView(
                    // Wrap with SingleChildScrollView
                    child: ExpenseWidget(
                      month: selectedMonth,
                      year: selectedYear,
                    ), // Make the ExpenseWidget scrollable
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
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                Widget buildContent() {
                  return SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: Container(
                        height: 350, // Customize the height as needed
                        color: Color(0xFFF6573D3), // Set the desired color
                        child: DefaultTabController(
                          length: 2, // Number of tabs
                          child: Column(
                            children: <Widget>[
                              TabBar(
                                tabs: [
                                  Tab(text: 'Income'),
                                  Tab(text: 'Expense'),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: IconButton(
                                                    icon: Icon(
                                                        Icons.calendar_today),
                                                    onPressed: () async {
                                                      // Await the result of the asynchronous operation
                                                      final dynamic result =
                                                          await selectDate(
                                                              context);

                                                      // Check if the result is of type DateTime
                                                      if (result is DateTime) {
                                                        // Cast the result to DateTime and update the selectedDate
                                                        setState(() {
                                                          selectedDate = result;
                                                        });
                                                      } else {
                                                        // Handle unexpected result types or errors
                                                        print(
                                                            'Unexpected result type: $result');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: IconButton(
                                                    icon: Icon(Icons.category),
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return Column(
                                                            children: [
                                                              if (income
                                                                  .isNotEmpty)
                                                                Column(
                                                                  children: [
                                                                    DropdownButton<
                                                                        String>(
                                                                      value:
                                                                          selectedIncome,
                                                                      items: income.map(
                                                                          (dynamic
                                                                              value) {
                                                                        return DropdownMenuItem<
                                                                            String>(
                                                                          value:
                                                                              value as String,
                                                                          child:
                                                                              Text(value.toString()),
                                                                        );
                                                                      }).toList(),
                                                                      onChanged:
                                                                          (newValue) {
                                                                        setState(
                                                                            () {
                                                                          selectedIncome =
                                                                              newValue!;
                                                                        });
                                                                        Navigator.pop(
                                                                            context); // Close the bottom sheet on selection
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Amount',
                                            ),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              setState(() {
                                                amount =
                                                    value; // Use the value to update the desired state or variable.
                                              });
                                            },
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                                labelText: 'Text'),
                                            onChanged: (value) {
                                              setState(() {
                                                subject =
                                                    value; // Use the value to update the desired state or variable.
                                              });
                                            },
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Extra Notes',
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                extraNotes =
                                                    value; // Use the value to update the desired state or variable.
                                              });
                                            },
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                // Add logic to handle income data insertion to Firestore
                                                await FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(uid)
                                                    .set({
                                                  'IncomeData':
                                                      FieldValue.arrayUnion([
                                                    {
                                                      'amount':
                                                          amount, // Replace with your income amount data
                                                      'incomeType':
                                                          selectedIncome, // Replace with selected income type
                                                      'date': selectedDate,
                                                      'text': subject,
                                                      'extraNotes':
                                                          extraNotes, // Replace with selected date
                                                    }
                                                  ])
                                                }, SetOptions(merge: true));
                                                // Success message or further handling can be added here
                                              } catch (e) {
                                                // Handle errors or exceptions here
                                                print("Error: $e");
                                              }
                                            },
                                            child: Text("Submit"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Form(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                      icon: Icon(
                                                          Icons.calendar_today),
                                                      onPressed: () {
                                                        selectedDate =
                                                            selectDate(context)
                                                                as DateTime;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: IconButton(
                                                      icon:
                                                          Icon(Icons.category),
                                                      onPressed: () {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Column(
                                                              children: [
                                                                if (expenses
                                                                    .isNotEmpty)
                                                                  Column(
                                                                    children: [
                                                                      DropdownButton<
                                                                          String>(
                                                                        value:
                                                                            selectedExpense,
                                                                        items: expenses.map((dynamic
                                                                            value) {
                                                                          return DropdownMenuItem<
                                                                              String>(
                                                                            value:
                                                                                value as String,
                                                                            child:
                                                                                Text(value.toString()),
                                                                          );
                                                                        }).toList(),
                                                                        onChanged:
                                                                            (newValue) {
                                                                          setState(
                                                                              () {
                                                                            selectedExpense =
                                                                                newValue!;
                                                                          });
                                                                          Navigator.pop(
                                                                              context); // Close the bottom sheet on selection
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                labelText: 'Amount',
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                setState(() {
                                                  amount =
                                                      value; // Use the value to update the desired state or variable.
                                                });
                                              },
                                              validator: (value) {
                                                // Convert the input string to an integer for validation
                                                int? intValue =
                                                    int.tryParse(value ?? '');
                                                return validateValue(intValue);
                                              },
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                  labelText: 'Text'),
                                              onChanged: (value) {
                                                setState(() {
                                                  subject =
                                                      value; // Use the value to update the desired state or variable.
                                                });
                                              },
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Extra Notes',
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  extraNotes =
                                                      value; // Use the value to update the desired state or variable.
                                                });
                                              },
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                try {
                                                  // Add logic to handle income data insertion to Firestore
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(uid)
                                                      .set({
                                                    'expenseData':
                                                        FieldValue.arrayUnion([
                                                      {
                                                        'amount':
                                                            amount, // Replace with your income amount data
                                                        'expenseType':
                                                            selectedExpense, // Replace with selected income type
                                                        'date': selectedDate,
                                                        'text': subject,
                                                        'extraNotes':
                                                            extraNotes, // Replace with selected date
                                                      }
                                                    ])
                                                  }, SetOptions(merge: true));
                                                  // Success message or further handling can be added here
                                                } catch (e) {
                                                  // Handle errors or exceptions here
                                                  print("Error: $e");
                                                }
                                                
                                              },
                                              child: Text("Submit"),
                                            ),
                                          ],
                                        ),
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
                  );
                }

                return buildContent(); // Call the method to build the content
              },
            );
          },
          backgroundColor: Color(0xFFF6573D3), // Set the background color
          child: Icon(Icons.add), // Set the icon
        ),
      ),
    );
  }
}
