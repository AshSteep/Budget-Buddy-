import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
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
        title: Text('Finance Statistics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                  sections: categories.map((category) {
                    return PieChartSectionData(
                      color: category.color,
                      value: category.value,
                      title: '${category.category}: ${category.value.toInt()}',
                      radius: 100,
                      titleStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Center(child: Text('Content for Tab 2')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to refresh the data when needed
          fetchDataAndComputeTotal();
        },
        child: Icon(Icons.refresh),
      ),
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
