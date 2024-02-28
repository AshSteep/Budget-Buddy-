import 'dart:math';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);
  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<CategoryData> categories = []; // Initialize empty category list
  String selectedTime = 'Day';
  // final auth = FirebaseAuth.instance;
  // final User? user = auth.currentUser;
  Future<void> fetchDataForSelectedDate(DateTime selectedDate) async {
    // Assuming 'users' is your Firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Replace 'selectedDate' with the chosen date and format it as required
    DateTime startOfDay = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 0, 0, 0);
    DateTime endOfDay = DateTime(
        selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59);

    QuerySnapshot<Map<String, dynamic>> snapshot = await users
        .doc(
            'JgPyXAVm4cMYkMDv9TTWne3OhT92') // Replace with the user ID or document ID
        .collection(
            'yourCollection') // Replace with the collection name containing your data
        .where('date',
            isGreaterThanOrEqualTo: startOfDay, isLessThanOrEqualTo: endOfDay)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Process the fetched data here
      List<DocumentSnapshot> documents = snapshot.docs;
      for (var document in documents) {
        // Access document data and perform operations
        Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

        if (data != null) {
          // Now you can access the data safely using the 'data' variable
          print(data); // Example: Print the fetched data
        } else {
          print('No data found for the selected date');
        }

        print(data); // Example: Print the fetched data
      }
    } else {
      print('No data found for the selected date');
    }
  }

  DateTime selectedDate = DateTime.now(); // Initial selected date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000), // Set the start date for the date picker
      lastDate: DateTime.now(), // Set the end date for the date picker
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate; // Update the selectedDate variable
      });

      fetchDataForSelectedDate(
          selectedDate); // Fetch data for the selected date
    }
  }

  Future<void> fetchDataAndComputeTotal() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot<Map<String, dynamic>> userDoc = await users
        .doc('JFZG2UtxJgNUcTqnUKznGgMQ6Yl2')
        .get() as DocumentSnapshot<Map<String, dynamic>>;

    if (userDoc.exists) {
      Map<String, dynamic>? incomeRawData = userDoc.data();

      if (incomeRawData != null && incomeRawData.containsKey('IncomeData')) {
        List<dynamic> incomeData = incomeRawData['IncomeData'];
        Map<String, int> categoryTotals = {};

        incomeData.forEach((data) {
          if (data is Map<String, dynamic> &&
              data.containsKey('incomeType') &&
              data.containsKey('amount')) {
            String incomeType = data['incomeType'];
            int amount = int.parse(data['amount'].toString());

            if (categoryTotals.containsKey(incomeType)) {
              categoryTotals[incomeType] = categoryTotals[incomeType]! + amount;
            } else {
              categoryTotals[incomeType] = amount;
            }
          }
        });

        // Convert category totals to CategoryData objects
        List<CategoryData> updatedCategories =
            categoryTotals.entries.map((entry) {
          return CategoryData(
            category: entry.key,
            value: entry.value.toDouble(),
            color: getRandomColor(), // Implement your color logic here
          );
        }).toList();

        setState(() {
          categories = updatedCategories;
        });
      } else {
        print('IncomeData not found or is empty');
      }
    } else {
      print('Document does not exist');
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchDataAndComputeTotal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: Text(
            'Statistics',
            style: TextStyle(
              color: const Color.fromARGB(255, 30, 28, 28),
              fontSize: 23,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color getRandomColor() {
    // Generating random values for red, green, and blue channels
    final Random random = Random();
    final int r = random.nextInt(256);
    final int g = random.nextInt(256);
    final int b = random.nextInt(256);

    // Creating a color from random values
    return Color.fromARGB(255, r, g, b);
  }
}

class CategoryData {
  final String category;
  final double value;
  final Color color;

  CategoryData({
    required this.category,
    required this.value,
    required this.color,
  });
}
