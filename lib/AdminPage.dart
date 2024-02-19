import 'package:base_app/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Color(0xFF0336FF),
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
        child: ListView(
          children: [
            catergoryTab(incomeController, addIncomeCategory,
                "Add Income Categories", "Add income category", 'income_cat'),
            catergoryTab(expenseController, addExpenseCategory,
                "Add Expense Categories", "Add expense category", 'expense'),
          ],
        ),
      ),
    );
  }

  Widget catergoryTab(
      controllerValue, Function action, title, hint, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Shadow color
                  spreadRadius: 2, // Spread radius
                  blurRadius: 5, // Blur radius
                  offset: Offset(0, 3), // Shadow offset
                ),
              ],
              gradient: LinearGradient(
                colors: [Colors.white70, Colors.white], // Gradient colors
                begin: Alignment.topLeft, // Gradient start position
                end: Alignment.bottomRight, // Gradient end position
              ),
            ),
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .doc('item')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Return a loading indicator while waiting for data
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Return an error message if there's an error
                } else {
                  // Access the data from the snapshot and display it
                  final data =
                      snapshot.data?.data(); // Get the data from the snapshot
                  final categoryData = data?[category] as List<dynamic>? ?? [];
                  String dataList = categoryData.join(', ');
                  // Display the categories or any other UI based on your requirements
                  return Text(dataList);
                }
              },
            )),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controllerValue,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60)),
                  hintText: hint,
                  hintStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                action();
              },
              child: Text("Add"),
            ),
          ],
        ),
        SizedBox(
          height: 50,
        )
      ],
    );
  }
}
