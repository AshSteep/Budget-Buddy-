import 'package:base_app/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String selectedIncomeCategory =
      ""; // Initialize with an empty string or a default category
  String selectedExpenseCategory =
      ""; // Initialize with an empty string or a default category
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();

  List<String> incomeCategories = [];
  List<String> expenseCategories = [];

  @override
  void initState() {
    super.initState();
    // Fetch income and expense categories from Firestore
    fetchCategories();
  }

  void fetchCategories() {
    // Fetch income categories
    FirebaseFirestore.instance
        .collection('categories')
        .doc('item') // Change 'item' to 'income' for income categories
        .get()
        .then((DocumentSnapshot incomeSnapshot) {
      if (incomeSnapshot.exists) {
        setState(() {
          Map<String, dynamic> incomeList =
              incomeSnapshot.data() as Map<String, dynamic>;
          incomeCategories = List.from(incomeList['cat_items']);

          // Check if the initial selectedIncomeCategory is empty or not in the list
          if (selectedIncomeCategory.isEmpty ||
              !incomeCategories.contains(selectedIncomeCategory)) {
            // Set the initial value to the first item in the list or any default category
            selectedIncomeCategory = incomeCategories.isNotEmpty
                ? incomeCategories[0]
                : "Default Income Category";
          }
        });
      }
    });

    // Fetch expense categories
    FirebaseFirestore.instance
        .collection('categories')
        .doc('item') // Change 'item' to 'expense' for expense categories
        .get()
        .then((DocumentSnapshot expenseSnapshot) {
      if (expenseSnapshot.exists) {
        setState(() {
          Map<String, dynamic> expenseList =
              expenseSnapshot.data() as Map<String, dynamic>;
          expenseCategories = List.from(expenseList['expense']);

          // Check if the initial selectedExpenseCategory is empty or not in the list
          if (selectedExpenseCategory.isEmpty ||
              !expenseCategories.contains(selectedExpenseCategory)) {
            // Set the initial value to the first item in the list or any default category
            selectedExpenseCategory = expenseCategories.isNotEmpty
                ? expenseCategories[0]
                : "Default Expense Category";
          }
        });
      }
    });
  }

// ...

  void addIncomeRecord() {
    final String newIncome = incomeController.text.trim();
    if (newIncome.isNotEmpty && selectedIncomeCategory.isNotEmpty) {
      // Implement logic to add the income record to the database
      // You can use newIncome and selectedIncomeCategory here
      // Then clear the input fields
      incomeController.clear();
      selectedIncomeCategory = "";
    }
  }

  void addExpenseRecord() {
    final String newExpense = expenseController.text.trim();
    if (newExpense.isNotEmpty && selectedExpenseCategory.isNotEmpty) {
      // Implement logic to add the expense record to the database
      // You can use newExpense and selectedExpenseCategory here
      // Then clear the input fields
      expenseController.clear();
      selectedExpenseCategory = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Buddy"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons
                .logout), // You can change the icon to your preferred logout icon
            onPressed: () {
              // Implement your logout logic here
              // For example, you can sign out the user and navigate to the login page
              // Example:
              // FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add Income Record",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedIncomeCategory,
              hint: Text("Select Income Category"),
              items: incomeCategories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedIncomeCategory = value!;
                });
              },
            ),
            TextField(
              controller: incomeController,
              decoration: InputDecoration(
                hintText: "Enter income amount",
              ),
            ),
            ElevatedButton(
              onPressed: addIncomeRecord,
              child: Text("Add Income"),
            ),
            SizedBox(height: 16),
            Text(
              "Add Expense Record",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedExpenseCategory,
              hint: Text("Select Expense Category"),
              items: expenseCategories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedExpenseCategory = value!;
                });
              },
            ),
            TextField(
              controller: expenseController,
              decoration: InputDecoration(
                hintText: "Enter expense amount",
              ),
            ),
            ElevatedButton(
              onPressed: addExpenseRecord,
              child: Text("Add Expense"),
            ),
          ],
        ),
      ),
    );
  }
}
