import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'LoginPage.dart';

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

  Future<void> selectDate(BuildContext context) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Budget Buddy'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.pie_chart),
                    title: Text('Charts'),
                    onTap: () {
                      // Action for the Pie Chart
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      // Action for the Profile
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
                    },
                  ),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue[900],
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        selectDate(context);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Balance :',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Card(
                // New Card
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue[900],
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
              Flexible(
                flex: 0, // Initial size
                child: Container(
                  height: 40,
                  width: 500,
                  color: Colors.blueGrey[900], // Example background color
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: Text(
                      'Income details displayed here ',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Card(
                // New Card
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue[900],
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
              Flexible(
                flex: 0, // Initial size
                child: Container(
                  height: 40,
                  width: 500,
                  color: Colors.blueGrey[900], // Example background color
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: Text(
                      'Expense details displayed here ',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(child: Center(child: Text('Daily Content'))),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 80,
                      child: FloatingActionButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 350, // Customize the height as needed
                                color: Colors
                                    .blueGrey[700], // Set the desired color
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
                                              padding:
                                                  const EdgeInsets.all(16.0),
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
                                                              selectDate(
                                                                  context);
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
                                                              // Add function to select category for income
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        labelText: 'Amount'),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        labelText: 'Text'),
                                                  ),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            'Extra Notes'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
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
                                                              selectDate(
                                                                  context);
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
                                                              // Add function to select category for income
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        labelText: 'Amount'),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        labelText: 'Text'),
                                                  ),
                                                  TextField(
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            'Extra Notes'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Add function for submitting the data
                                        },
                                        child: Text('Submit'),
                                      ),
                                    ],
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
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue[900],
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        selectDate(context);
                      },
                      child: Text(
                        DateFormat('MMMM y').format(selectedDate),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Center(child: Text('Monthly Content'))),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 80,
                    child: FloatingActionButton(
                      onPressed: () {
                        // Action for the Monthly FAB
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white70,
                      splashColor: Colors.grey,
                      elevation: 6,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Colors.blue[900],
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        selectDate(context);
                      },
                      child: Text(
                        DateFormat('y').format(selectedDate),
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Center(child: Text('Yearly Content'))),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 80,
                    child: FloatingActionButton(
                      onPressed: () {
                        // Action for the Yearly FAB
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white70,
                      splashColor: Colors.grey,
                      elevation: 6,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'LoginPage.dart';
//
// class Transaction {
//   final DateTime date;
//   final double amount;
//   final String description;
//   final String category;
//
//   Transaction({
//     required this.date,
//     required this.amount,
//     required this.description,
//     required this.category,
//   });
// }

// class UserPage extends StatefulWidget {
//   @override
//   _UserPageState createState() => _UserPageState();
// }
//
// class _UserPageState extends State<UserPage> {
//   List<String> expenses = []; // Initialize an empty list
//   List<String> income = []; // Initialize an empty list
//   String selectedExpense = ''; // Initialize an empty string
//   String selectedIncome = ''; // Initialize an empty string
//   String amount = '';
//   @override
//   void initState() {
//     super.initState();
//     _fetchExpensesFromServer(); // Fetch expenses from a server
//   }
//
//   // Function to fetch expenses from a server or any other source
//   void _fetchExpensesFromServer() async {
//     // Simulated data fetching or initialization of the expenses list
//     try {
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('categories')
//           .doc('item')
//           .get();
//
//       if (userSnapshot.exists) {
//         Map<String, dynamic> userData =
//             userSnapshot.data() as Map<String, dynamic>;
//         setState(() {
//           expenses = List<String>.from(userData['expense'] ?? []);
//           selectedExpense = expenses.isNotEmpty ? expenses[0] : '';
//           income = List<String>.from(userData['income_cat'] ?? []);
//           selectedIncome = income.isNotEmpty ? income[0] : '';
//         });
//       } else {
//         // Handle document not found
//       }
//     } catch (e) {
//       // Handle errors
//       print("Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final String uid = ModalRoute.of(context)!.settings.arguments as String;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Budget Buddy"),
//         actions: <Widget>[
//           IconButton(
//               onPressed: () {
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(
//                   builder: (context) => LoginPage(),
//                 ));
//               },
//               icon: Icon(Icons.pie_chart)),
//           IconButton(
//             icon: Icon(Icons.logout),
//             // You can change the icon to your preferred logout icon
//             onPressed: () {
//               // Implement your logout logic here
//               // For example, you can sign out the user and navigate to the login page
//               // Example:
//               // FirebaseAuth.instance.signOut();
//               Navigator.of(context).pushReplacement(MaterialPageRoute(
//                 builder: (context) => LoginPage(),
//               ));
//             },
//           ),
//         ],
//       ),
//       body: DefaultTabController(
//         length: 2,
//         child: Column(
//           children: <Widget>[
//             ButtonsTabBar(
//               backgroundColor: Colors.red[900],
//               borderWidth: 2,
//               borderColor: Colors.black,
//               labelStyle: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//               unselectedLabelStyle: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//               tabs: [
//                 Tab(text: 'Expense'), // Expense Tab
//                 Tab(text: 'Income'), // Income Tab
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   // Expense Tab View
//                   Container(
//                     color: Colors.grey[200],
//                     child: Column(
//                       children: [
//                         if (expenses.isNotEmpty)
//                           Column(
//                             children: [
//                               DropdownButton<String>(
//                                 value: selectedExpense,
//                                 items: expenses.map((dynamic value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value as String,
//                                     child: Text(value.toString()),
//                                   );
//                                 }).toList(),
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     selectedExpense = newValue!;
//                                   });
//                                 },
//                               ),
//                               SizedBox(height: 20),
//                               TextField(
//                                 decoration: InputDecoration(
//                                   hintText: 'Enter Amount',
//                                   border: OutlineInputBorder(),
//                                 ),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     amount = value;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         if (expenses.isEmpty)
//                           Center(child: CircularProgressIndicator()),
//                         ElevatedButton(
//                             onPressed: () async {
//                               try {
//                                 await FirebaseFirestore.instance
//                                     .collection('users')
//                                     .doc(uid)
//                                     .set({
//                                   'expenseData': FieldValue.arrayUnion([
//                                     {
//                                       'amount': amount,
//                                       'expenseType': selectedExpense,
//                                     }
//                                   ])
//                                 }, SetOptions(merge: true));
//                                 // Success message or further handling can be added here
//                               } catch (e) {
//                                 // Handle errors or exceptions here
//                                 print("Error: $e");
//                               }
//                             },
//                             child: Text("Add Expense")), // Loading indicator
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Expanded(
//                           child: StreamBuilder<DocumentSnapshot>(
//                             stream: FirebaseFirestore.instance
//                                 .collection('users')
//                                 .doc(uid)
//                                 .snapshots(),
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<DocumentSnapshot> snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return Center(
//                                     child: CircularProgressIndicator());
//                               } else if (snapshot.hasError) {
//                                 return Center(
//                                     child: Text('Error: ${snapshot.error}'));
//                               } else if (!snapshot.hasData ||
//                                   !snapshot.data!.exists) {
//                                 return Center(
//                                     child: Text('Document does not exist'));
//                               } else {
//                                 final Map<String, dynamic> expenseData =
//                                     snapshot.data!.data()
//                                         as Map<String, dynamic>;
//                                 List<dynamic> expenseDataList =
//                                     expenseData['expenseData'];
//
//                                 return Scaffold(
//                                   appBar: AppBar(
//                                     title: Text('Expense Data List'),
//                                   ),
//                                   body: ListView.builder(
//                                     itemCount: expenseDataList.length,
//                                     itemBuilder: (context, index) {
//                                       final dynamic expense =
//                                           expenseDataList[index];
//
//                                       if (expense is Map<String, dynamic>) {
//                                         return ListTile(
//                                           title: Text(
//                                               'Amount: ${expense['amount']} - Type: ${expense['expenseType']}'),
//                                           // Other tile settings/styles as needed
//                                         );
//                                       } else {
//                                         return ListTile(
//                                           title: Text('Invalid Expense Data'),
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 );
//                               }
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   // Income Tab View
//                   Container(
//                     color: Colors.grey[200],
//                     child: Column(
//                       children: [
//                         if (income.isNotEmpty)
//                           Column(
//                             children: [
//                               DropdownButton<String>(
//                                 value: selectedIncome,
//                                 items: income.map((dynamic value) {
//                                   return DropdownMenuItem<String>(
//                                     value: value as String,
//                                     child: Text(value.toString()),
//                                   );
//                                 }).toList(),
//                                 onChanged: (newValue) {
//                                   setState(() {
//                                     selectedIncome = newValue!;
//                                   });
//                                 },
//                               ),
//                               SizedBox(height: 20),
//                               TextField(
//                                 decoration: InputDecoration(
//                                   hintText: 'Enter Amount',
//                                   border: OutlineInputBorder(),
//                                 ),
//                                 onChanged: (value) {
//                                   setState(() {
//                                     amount = value;
//                                   });
//                                 },
//                               ),
//                             ],
//                           ),
//                         if (income.isEmpty)
//                           Center(child: CircularProgressIndicator()),
//                         ElevatedButton(
//                             onPressed: () async {
//                               try {
//                                 await FirebaseFirestore.instance
//                                     .collection('users')
//                                     .doc(uid)
//                                     .set({
//                                   'IncomeData': FieldValue.arrayUnion([
//                                     {
//                                       'amount': amount,
//                                       'IncomeType': selectedIncome,
//                                     }
//                                   ])
//                                 }, SetOptions(merge: true));
//                                 // Success message or further handling can be added here
//                               } catch (e) {
//                                 // Handle errors or exceptions here
//                                 print("Error: $e");
//                               }
//                             },
//                             child: Text("Add Income")), // Loading indicator
//                         SizedBox(
//                           height: 15,
//                         ),
//                         Expanded(
//                           child: StreamBuilder<DocumentSnapshot>(
//                             stream: FirebaseFirestore.instance
//                                 .collection('users')
//                                 .doc(uid)
//                                 .snapshots(),
//                             builder: (BuildContext context,
//                                 AsyncSnapshot<DocumentSnapshot> snapshot) {
//                               if (snapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return Center(
//                                     child: CircularProgressIndicator());
//                               } else if (snapshot.hasError) {
//                                 return Center(
//                                     child: Text('Error: ${snapshot.error}'));
//                               } else if (!snapshot.hasData ||
//                                   !snapshot.data!.exists) {
//                                 return Center(
//                                     child: Text('Document does not exist'));
//                               } else {
//                                 final Map<String, dynamic> IncomeData =
//                                     snapshot.data!.data()
//                                         as Map<String, dynamic>;
//                                 List<dynamic> IncomeDataList =
//                                     IncomeData['IncomeData'];
//
//                                 return Scaffold(
//                                   appBar: AppBar(
//                                     title: Text('Income Data List'),
//                                   ),
//                                   body: ListView.builder(
//                                     itemCount: IncomeDataList.length,
//                                     itemBuilder: (context, index) {
//                                       final dynamic Income =
//                                           IncomeDataList[index];
//
//                                       if (Income is Map<String, dynamic>) {
//                                         return ListTile(
//                                           title: Text(
//                                               'Amount: ${Income['amount']} - Type: ${Income['IncomeType']}'),
//                                           // Other tile settings/styles as needed
//                                         );
//                                       } else {
//                                         return ListTile(
//                                           title: Text('Invalid Income Data'),
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 );
//                               }
//                             },
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class Category {
//   final String id;
//   final String name;
//
//   Category({required this.id, required this.name});
// }
