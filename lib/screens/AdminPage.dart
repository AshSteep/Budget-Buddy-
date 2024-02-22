import 'package:base_app/auth/LoginPage.dart';
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

  void updateItemName(BuildContext context, String itemId, String newItemName,
      String fieldname) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc('item')
          .update({
        // Use FieldValue.arrayRemove to remove the old item and FieldValue.arrayUnion to add the updated item
        fieldname: FieldValue.arrayRemove([itemId]),
      }).then((value) => FirebaseFirestore.instance
                  .collection('categories')
                  .doc('item')
                  .update({
                // Use FieldValue.arrayRemove to remove the old item and FieldValue.arrayUnion to add the updated item
                fieldname: FieldValue.arrayUnion([newItemName]),
              }));
      Navigator.of(context).pop(); // Close the dialog
    } catch (e) {
      print('Error updating item: $e');
      // Handle error
    }
  }

  void showEditDialog(BuildContext context, String itemId, String fieldname) {
    String newItemName = ''; // Variable to store the edited item name

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue:
                      itemId, // Display the current item name in the text field
                  decoration: InputDecoration(
                    labelText: 'New Item Name',
                  ),
                  onChanged: (value) {
                    // Update newItemName when the text field value changes
                    newItemName = value;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        // Implement update functionality
                        updateItemName(context, itemId, newItemName, fieldname);
                      },
                      child: Text('Update'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showOptionsDialog(
      BuildContext context, String itemId, String fieldname) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Options'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Delete'),
                  onTap: () async {
                    // Implement delete functionality
                    try {
                      await FirebaseFirestore.instance
                          .collection('categories')
                          .doc('item')
                          .update({
                        fieldname: FieldValue.arrayRemove([itemId])
                      });
                      Navigator.of(context).pop(); // Close the dialog
                    } catch (e) {
                      print('Error deleting item: $e');
                      // Handle error
                    }
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text('Edit'),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the initial dialog
                    showEditDialog(
                        context, itemId, fieldname); // Show the edit dialog
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
          width: 500,
          height: 200,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
            gradient: LinearGradient(
              colors: [Colors.white70, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .doc('item')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final data = snapshot.data?.data();
                  final categoryData = data?[category] as List<dynamic>? ?? [];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: categoryData.map<Widget>((item) {
                      return GestureDetector(
                        child: ListTile(
                          title: Text(
                            item.trim(),
                            style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Bradley Hand',
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          dense: true, // Make the tile smaller
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 2),
                          onTap: () {
                            showOptionsDialog(context, item, category);
                          },
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ),
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
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
              ),
            ),
            SizedBox(
              width: 10,
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
