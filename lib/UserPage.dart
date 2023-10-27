import 'package:flutter/material.dart';

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

class _UserPageState extends State<UserPage> {
  final List<Transaction> transactions = [];
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController textController = TextEditingController();
  String? selectedCategory;
  DateTime selectedDate = DateTime.now();

  List<Category> categories = [
    Category(id: '1', name: 'Income'),
    Category(id: '2', name: 'Expense'),
  ];

  void addTransaction() {
    final double amount = double.tryParse(amountController.text) ?? 0.0;
    final String description = descriptionController.text;

    if (amount > 0 && selectedCategory != null) {
      transactions.add(
          Transaction(
            date: selectedDate,
            amount: amount,
            description: description,
            category: selectedCategory!,
          ));
      setState(() {
        amountController.clear();
        descriptionController.clear();
      });
    }
  }

  Future<void> _addCategory() async {
    String newCategory = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Category"),
          content: TextField(
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(labelText: "Category Name"),
            onSubmitted: (value) {
              Navigator.pop(context, value);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context, null);
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                Navigator.pop(context, textController.text);
              },
            ),
          ],
        );
      },
    );

    if (newCategory != null) {
      final uniqueId = UniqueKey().toString();
      setState(() {
        categories.add(Category(id: uniqueId, name: newCategory));
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Buddy'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text("Date: ${selectedDate.toLocal()}".split(' ')[0]),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select date'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: categories.map((Category category) {
                    return DropdownMenuItem<String>(
                      value: category.name,
                      child: Text(category.name),
                    );
                  }).toList(),
                ),
                TextButton(
                  onPressed: _addCategory,
                  child: Text("Add Category"),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: addTransaction,
              child: Text('Add Transaction'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  elevation: 2,
                  child: ListTile(
                    title: Text(transactions[index].description),
                    subtitle: Text(
                      '${transactions[index].category}: \$${transactions[index].amount.toStringAsFixed(2)}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          transactions.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});
}