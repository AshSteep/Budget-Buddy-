import 'package:base_app/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  final FirebaseFirestore fire = FirebaseFirestore.instance;
  List<dynamic> incomeCategories = [];
  List<dynamic> expenseCategories = [];

  void addIncomeCategory() {
    final String newCategory = incomeController.text.trim();
    if (newCategory.isNotEmpty) {
      // Get a reference to the 'categories' document
      DocumentReference categoriesRef =
          fire.collection('categories').doc('item');

      // Use Firestore's arrayUnion to add the new category to the array
      categoriesRef.update({
        'income_cat': FieldValue.arrayUnion([newCategory]),
      }).then((_) {
        // Clear the input field
        incomeController.clear();

        // Print the updated list (optional)
        print('Category added: $newCategory');
      }).catchError((error) {
        // Handle any errors here
        print('Error adding category: $error');
      });
    }
  }

  void addExpenseCategory() {
    final String newCategory = expenseController.text.trim();
    if (newCategory.isNotEmpty) {
      // Get a reference to the 'categories' document
      DocumentReference categoriesRef = fire
          .collection('categories')
          .doc('item'); // Change 'item' to 'expense'

      // Use Firestore's arrayUnion to add the new category to the array
      categoriesRef.update({
        'expense': FieldValue.arrayUnion([newCategory]),
      }).then((_) {
        // Clear the input field
        expenseController.clear();

        // Print the updated list (optional)
        print('Expense category added: $newCategory');
      }).catchError((error) {
        // Handle any errors here
        print('Error adding expense category: $error');
      });
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
                builder: (context) => LoginPage(),
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
              "Add Income Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: incomeController,
                    decoration: InputDecoration(
                      hintText: "Enter new income category",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: addIncomeCategory,
                  child: Text("Add"),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "Add Expense Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: expenseController,
                    decoration: InputDecoration(
                      hintText: "Enter new expense category",
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: addExpenseCategory,
                  child: Text("Add"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
