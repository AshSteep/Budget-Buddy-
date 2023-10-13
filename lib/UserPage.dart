import 'package:base_app/LoginPage.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextEditingController amountController = TextEditingController();
  List<String> incomeRecords = [];
  List<String> expenseRecords = [];

  void _addRecord(String category) {
    String value = amountController.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        if (category == "Income") {
          incomeRecords.add(value);
        } else if (category == "Expense") {
          expenseRecords.add(value);
        }
      });
      amountController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Budget Buddy"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Income",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      for (var record in incomeRecords)
                        Text(record),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Expense",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      for (var record in expenseRecords)
                        Text(record),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _addRecord("Income"),
            child: Text("Add Income"),
          ),
          ElevatedButton(
            onPressed: () => _addRecord("Expense"),
            child: Text("Add Expense"),
          ),
        ],
      ),
    );
  }
}
