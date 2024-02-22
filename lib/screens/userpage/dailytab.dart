import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class Dailytab extends StatefulWidget {
  const Dailytab({super.key});

  @override
  State<Dailytab> createState() => _DailytabState();
}

class _DailytabState extends State<Dailytab>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  List<String> expenses = []; // Initialize an empty list
  List<String> income = []; // Initialize an empty list
  String selectedExpense = ''; // Initialize an empty string
  String selectedIncome = ''; // Initialize an empty string
  String amount = ''; // New DateTime variable for selected date
  String subject = ''; // New DateTime variable for selected date
  String extraNotes = ''; // New DateTime variable for selected date
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Future<void> pickDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked; // Update the selected date
        });
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

    final FirebaseAuth _auth = FirebaseAuth.instance;

    String uid = _auth.currentUser!.uid;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 10),
        Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color(0xFF0336FF),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              height: 40,
              width: double.infinity,
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  pickDate(context); // Invoke the date picker
                },
                child: Text(
                  DateFormat('EEEE, MMMM d, y').format(selectedDate),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 10), // Adding space after the card
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Center(child: Text('Document does not exist'));
            } else {
              final Map<String, dynamic>? data =
                  snapshot.data!.data() as Map<String, dynamic>?;

              if (data == null ||
                  !data.containsKey('IncomeData') ||
                  !data.containsKey('expenseData')) {
                return Center(
                    child: Text('Insufficient data to compute balance'));
              }

              List<dynamic> incomeDataList = data['IncomeData'];
              List<dynamic> expenseDataList = data['expenseData'];

// Compute the total income
              double totalIncome =
                  incomeDataList.fold(0, (previousValue, element) {
                if (element is Map<String, dynamic>) {
                  // Convert 'amount' from string to double before addition
                  return previousValue +
                      (double.tryParse(element['amount']) ?? 0);
                }
                return previousValue;
              });

// Compute the total expense
              double totalExpense =
                  expenseDataList.fold(0, (previousValue, element) {
                if (element is Map<String, dynamic>) {
                  // Convert 'amount' from string to double before addition
                  return previousValue +
                      (double.tryParse(element['amount']) ?? 0);
                }
                return previousValue;
              });

              // Calculate the balance
              double balance = totalIncome - totalExpense;

              return Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Balance : ${balance.toStringAsFixed(2)}', // Displaying balance with two decimal places
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: balance < 0
                              ? Colors.red
                              : Colors
                                  .white, // Check if the balance is negative
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),

        SizedBox(height: 8),
        Card(
          // New Card
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color(0xFF0336FF),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              height: 40,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                'Income',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('Document does not exist'));
                } else {
                  final Map<String, dynamic>? incomeData =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  if (incomeData == null ||
                      !incomeData.containsKey('IncomeData')) {
                    return Center(child: Text('No Income Data Found'));
                  }

                  List<dynamic> incomeDataList = incomeData['IncomeData'];

                  // Filter and sort the income data based on the selected date
                  incomeDataList = incomeDataList.where((income) {
                    if (income is Map<String, dynamic>) {
                      DateTime incomeDate = income['date'].toDate();
                      return incomeDate.day == selectedDate.day &&
                          incomeDate.month == selectedDate.month &&
                          incomeDate.year == selectedDate.year;
                    }
                    return false;
                  }).toList();

                  // Sort by date
                  incomeDataList.sort((a, b) {
                    DateTime dateA = a['date'].toDate();
                    DateTime dateB = b['date'].toDate();
                    return dateA.compareTo(dateB);
                  });

                  return ListView.separated(
                    itemCount: incomeDataList.length,
                    itemBuilder: (context, index) {
                      final dynamic income = incomeDataList[index];
                      if (income is Map<String, dynamic>) {
                        DateTime date = income['date'].toDate();
                        // ignore: unused_local_variable
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(date);
                        return SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${income['text']}',
                                    style: TextStyle(
                                        fontSize:
                                            16, // Adjust the font size as desired
                                        color: Colors.white,
                                        fontWeight: FontWeight
                                            .bold // Change the text color if needed
                                        // Other text styles (fontWeight, fontStyle, etc.) can be added here
                                        ),
                                  ),
                                  Text(
                                    '${income['incomeType']}',
                                    style: TextStyle(
                                        fontSize:
                                            12, // Adjust the font size as desired
                                        color: Colors.white,
                                        fontWeight: FontWeight
                                            .normal // Change the text color if needed
                                        // Other text styles (fontWeight, fontStyle, etc.) can be added here
                                        ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.currency_rupee,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Text(
                                    '${income['amount']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        return Card(
                          elevation: 4, // Set the elevation to your preference
                          margin:
                              EdgeInsets.all(8), // Adjust the margins as needed
                          child: ListTile(
                            title: Text('Invalid Income Data'),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.grey,
                    ),
                  );
                }
              },
            ),
          ),
        ),

        Card(
          // New Card
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color(0xFF0336FF),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              height: 40,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              child: Text(
                'Expense',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text('Document does not exist'));
                } else {
                  final Map<String, dynamic>? expenseData =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  if (expenseData == null ||
                      !expenseData.containsKey('expenseData')) {
                    return Center(child: Text('No Expense Data Found'));
                  }

                  List<dynamic> expenseDataList = expenseData['expenseData'];

                  // Filter and sort the expense data based on the selected date
                  expenseDataList = expenseDataList.where((expense) {
                    if (expense is Map<String, dynamic>) {
                      DateTime expenseDate = expense['date'].toDate();
                      return expenseDate.day == selectedDate.day &&
                          expenseDate.month == selectedDate.month &&
                          expenseDate.year == selectedDate.year;
                    }
                    return false;
                  }).toList();

                  // Sort by date
                  expenseDataList.sort((a, b) {
                    DateTime dateA = a['date'].toDate();
                    DateTime dateB = b['date'].toDate();
                    return dateA.compareTo(dateB);
                  });

                  return ListView.separated(
                    itemCount: expenseDataList.length,
                    itemBuilder: (context, index) {
                      final dynamic expense = expenseDataList[index];
                      if (expense is Map<String, dynamic>) {
                        DateTime date = expense['date'].toDate();
                        // ignore: unused_local_variable
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(date);
                        return SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${expense['text']}',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${expense['expenseType']}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.currency_rupee,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  Text(
                                    '${expense['amount']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            title: Text('Invalid Expense Data'),
                          ),
                        );
                      }
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      color: Colors.grey,
                    ),
                  );
                }
              },
            ),
          ),
        ),

        Expanded(child: Center(child: Text(''))),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 80,
                child: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Container(
                              height: 350, // Customize the height as needed
                              color:
                                  Colors.blueGrey[700], // Set the desired color
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
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: IconButton(
                                                          icon: Icon(Icons
                                                              .calendar_today),
                                                          onPressed: () async {
                                                            // Await the result of the asynchronous operation
                                                            final dynamic
                                                                result =
                                                                await selectDate(
                                                                    context);

                                                            // Check if the result is of type DateTime
                                                            if (result
                                                                is DateTime) {
                                                              // Cast the result to DateTime and update the selectedDate
                                                              setState(() {
                                                                selectedDate =
                                                                    result;
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
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.category),
                                                          onPressed: () {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
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
                                                                            items:
                                                                                income.map((dynamic value) {
                                                                              return DropdownMenuItem<String>(
                                                                                value: value as String,
                                                                                child: Text(value.toString()),
                                                                              );
                                                                            }).toList(),
                                                                            onChanged:
                                                                                (newValue) {
                                                                              setState(() {
                                                                                selectedIncome = newValue!;
                                                                              });
                                                                              Navigator.pop(context); // Close the bottom sheet on selection
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
                                                  keyboardType:
                                                      TextInputType.number,
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
                                                      labelText: 'Extra Notes'),
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
                                                    // if (_formKey
                                                    //     .currentState!
                                                    //     .validate()) {

                                                    // }
                                                    try {
                                                      // Add logic to handle income data insertion to Firestore
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(uid)
                                                          .set(
                                                              {
                                                            'IncomeData':
                                                                FieldValue
                                                                    .arrayUnion([
                                                              {
                                                                'amount':
                                                                    amount, // Replace with your income amount data
                                                                'incomeType':
                                                                    selectedIncome, // Replace with selected income type
                                                                'date':
                                                                    selectedDate,
                                                                'text': subject,
                                                                'extraNotes':
                                                                    extraNotes, // Replace with selected date
                                                              }
                                                            ])
                                                          },
                                                              SetOptions(
                                                                  merge: true));
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
                                              key: _formKey,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: IconButton(
                                                            icon: Icon(Icons
                                                                .calendar_today),
                                                            onPressed: () {
                                                              selectedDate =
                                                                  selectDate(
                                                                          context)
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
                                                            icon: Icon(
                                                                Icons.category),
                                                            onPressed: () {
                                                              showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Column(
                                                                    children: [
                                                                      if (expenses
                                                                          .isNotEmpty)
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
                                                                                Navigator.pop(context); // Close the bottom sheet on selection
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
                                                          int.tryParse(
                                                              value ?? '');
                                                      return validateValue(
                                                          intValue);
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
                                                        labelText:
                                                            'Extra Notes'),
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
                                                            .set(
                                                                {
                                                              'expenseData':
                                                                  FieldValue
                                                                      .arrayUnion([
                                                                {
                                                                  'amount':
                                                                      amount, // Replace with your income amount data
                                                                  'expenseType':
                                                                      selectedExpense, // Replace with selected income type
                                                                  'date':
                                                                      selectedDate,
                                                                  'text':
                                                                      subject,
                                                                  'extraNotes':
                                                                      extraNotes, // Replace with selected date
                                                                }
                                                              ])
                                                            },
                                                                SetOptions(
                                                                    merge:
                                                                        true));
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

                                    // Loading indicator
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white70,
                  splashColor: Colors.grey,
                  elevation: 6,
                )),
          ],
        ),
      ],
    );
  }
}
