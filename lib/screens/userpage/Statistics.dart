import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int TravelExp = 0;
  int FoodExp = 0;
  int EntertainmentExp = 0;
  int FuelExp = 0;
  int OutingExp = 0;
  int totalExpense = 0;
  int MedicalExp = 0;
  int sum = 0;
  TextEditingController _textEditingController = TextEditingController();
  double _limit = 0;
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    _loadLimit();
  }

  Future<void> pageData() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      print('this is data ${data['expenseData']}');
      data['expenseData'].forEach((e) {
        print(e);
        setState(() {
          if (e['category'] == 'Food') {
            FoodExp = FoodExp + (int.parse(e['amount']));
          }
          if (e['category'] == 'Travel') {
            TravelExp = TravelExp + (int.parse(e['amount']));
          }
          if (e['category'] == 'Entertainment') {
            EntertainmentExp = EntertainmentExp + (int.parse(e['amount']));
          }
          if (e['category'] == 'Fuel') {
            FuelExp = FuelExp + (int.parse(e['amount']));
          }
          if (e['category'] == 'Outing') {
            OutingExp = OutingExp + (int.parse(e['amount']));
          }
          if (e['category'] == 'Medical') {
            MedicalExp = MedicalExp + (int.parse(e['amount']));
          }
        });
      });
    } else {
      print('No data found for this user.');
    }
  }

  void _loadLimit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _limit = prefs.getDouble('limit') ?? 0.0;
      _textEditingController = TextEditingController(text: _limit.toString());
      isloading = false;
    });
    pageData();
  }

  // Save the limit value to shared preferences
  void _saveLimit(double limit) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('limit', limit);
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    String uid = _auth.currentUser!.uid;
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    print(FoodExp);
    print(TravelExp);
    Map<String, double> dataMap = {
      'Travel': double.parse(TravelExp.toString()),
      'Food': double.parse(FoodExp.toString()),
      'Entertainment': double.parse(EntertainmentExp.toString()),
      'Fuel': double.parse(FuelExp.toString()),
      'Outing': double.parse(OutingExp.toString()),
      'Medical': double.parse(MedicalExp.toString())
    };
    print('this is datamap;$dataMap');
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        title: Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              Image.asset(
                'assets/icons/wallet.png',
                width: 60,
                height: 40,
              ),
              SizedBox(width: 0), // Add some spacing between the icon and text
              Text(
                'Statistics',
                style: TextStyle(
                  color: const Color.fromARGB(255, 30, 28, 28),
                  fontSize: 23,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(), // This will push the IconButton to the right side
            ],
          ),
        ),
      ),
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 360.0,
                    height: 140.0,
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFF6573D3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Statistics',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Set Limit'),
                                                content: TextField(
                                                  controller:
                                                      _textEditingController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      labelText: 'Enter Limit'),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Set'),
                                                    onPressed: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      setState(() {
                                                        prefs.setDouble(
                                                            'limit',
                                                            double.parse(
                                                                _textEditingController
                                                                    .text));
                                                      });
                                                      setState(() {
                                                        _limit = double.tryParse(
                                                                _textEditingController
                                                                    .text) ??
                                                            0.0;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Image.asset(
                                          'assets/icons/Limiter.png',
                                          height: 30,
                                          width: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Center(
                                        child: StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(uid)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            }
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Error: ${snapshot.error}');
                                            }
                                            if (!snapshot.hasData ||
                                                !snapshot.data!.exists) {
                                              return Text('No data available');
                                            }

                                            // Extract expenses data from the user document
                                            Map<String, dynamic> userData =
                                                snapshot.data!.data()
                                                    as Map<String, dynamic>;
                                            int sum = 0;
                                            List<dynamic> expenses =
                                                userData['expenseData'] ?? [];
                                            expenses.forEach((e) {
                                              print(e['date'].toDate());
                                              print("Full");
                                              if (e['date'].toDate().isAfter(
                                                      firstDayOfMonth) &&
                                                  e['date'].toDate().isBefore(
                                                      lastDayOfMonth)) {
                                                print(e['date'].toDate());
                                                sum = sum +
                                                    (int.parse(e['amount']));
                                              }
                                            });
                                            print(sum);
                                            // Calculate total expense
                                            totalExpense = expenses.fold(
                                                0,
                                                (previousValue, expense) =>
                                                    previousValue +
                                                    (int.parse(
                                                        expense['amount'])));
                                            print(totalExpense);
                                            return Text(
                                              '₹ $sum',
                                              style: TextStyle(
                                                color: Color(0xFFFFBFCFE),
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '/ ₹ $_limit Per Month  ',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  // Add some space between text and progress indicator
                                  LinearProgressIndicator(
                                    value: totalExpense /
                                        _limit, // Calculate the progress
                                    backgroundColor: Colors.white,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors
                                          .orange, // Choose your desired progress color
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 15, right: 20, left: 20, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expense Breakdown',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Limit ₹ 1000 per week ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 104, 102, 102),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //   SizedBox(
                      //     width: 120,
                      //     height: 40,
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         shape: BoxShape.rectangle,
                      //         color: Color(0xFFF6573D3),
                      //         border: Border.all(color: Colors.grey),
                      //         borderRadius: BorderRadius.circular(8.0),
                      //       ),
                      //       child: Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      //         child: DropdownButton<String>(
                      //           value: 'This Week',
                      //           onChanged: (String? newValue) {},
                      //           items: <String>['This Month', 'This Week', 'This Day']
                      //               .map<DropdownMenuItem<String>>((String value) {
                      //             return DropdownMenuItem<String>(
                      //               value: value,
                      //               child: Text(
                      //                 value,
                      //                 style: TextStyle(
                      //                   fontSize: 16.0,
                      //                   color: Colors.white,
                      //                 ),
                      //               ),
                      //             );
                      //           }).toList(),
                      //           style: TextStyle(
                      //             fontSize: 16.0,
                      //             color: Colors.black,
                      //           ),
                      //           icon: Icon(
                      //             Icons.arrow_drop_down,
                      //             color: Colors.white,
                      //           ),
                      //           elevation: 8,
                      //           underline: Container(),
                      //           isExpanded: true,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, right: 15, left: 15, bottom: 0),
                  child: SizedBox(
                    height: 300,
                    width: 500,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 0),
                        child: PieChart(
                          dataMap: dataMap,
                          chartRadius:
                              350, // Adjust the chart radius according to your requirement
                          chartType: ChartType.disc,
                          ringStrokeWidth: 32,
                          legendOptions: LegendOptions(
                            showLegendsInRow: true,
                            legendPosition: LegendPosition.bottom,
                            legendShape: BoxShape.circle,
                          ),
                          chartValuesOptions: ChartValuesOptions(
                            showChartValueBackground: true,
                            chartValueBackgroundColor: Color(0xFFF6573D3),
                            showChartValues: true,
                            showChartValuesInPercentage:
                                true, // Show percentage values instead of actual amounts
                            showChartValuesOutside: true,
                            decimalPlaces: 0,
                            chartValueStyle: TextStyle(
                              color: Colors.white, // Change text color
                              fontSize: 16, // Adjust font size
                              fontWeight: FontWeight.bold, // Adjust font weight
                              // Adjust font style
                            ), // Adjust decimal places for percentage values
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 15, right: 15, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          // Wrap with a Container for left alignment
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Spending Details',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 5), // Add some space between the texts
                        Container(
                          // Wrap with a Container for left alignment
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Expenses In categories ',
                            style: TextStyle(
                                color: const Color.fromARGB(255, 92, 87, 87),
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 25),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            height:
                                100, // Adjust height according to your requirement
                            color:
                                Colors.transparent, // Choose your desired color
                            width:
                                540, // Set a fixed width or use double.infinity for full width
                            child: Row(
                              children: [
                                // List of small rectangular containers
                                Container(
                                  width: 170, // Width of the small container
                                  height: double
                                      .infinity, // Match the height of the parent container
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 2), // Increase border thickness
                                    borderRadius: BorderRadius.circular(
                                        15), // Make corners round
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          5), // Margin between containers
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: 60,
                                            width: 60,
                                            child: Image.asset(
                                                'assets/icons/cart.png')), // Icon
                                        SizedBox(
                                            width:
                                                10), // Spacer between icon and text fields
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Shop",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                                height: 5), // First Text Field
                                            Text(
                                              "- ₹300",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 70, 68, 68),
                                              ),
                                            ), // Second Text Field
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 170, // Width of the small container
                                  height: double
                                      .infinity, // Match the height of the parent container
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black,
                                        width: 2), // Increase border thickness
                                    borderRadius: BorderRadius.circular(
                                        15), // Make corners round
                                  ),
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          5), // Margin between containers
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 10,
                                        bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Image.asset(
                                                'assets/icons/bus.png')), // Icon
                                        SizedBox(
                                            width:
                                                10), // Spacer between icon and text fields
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Transportation",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                                height: 5), // First Text Field
                                            Text(
                                              "- ₹250",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(
                                                    255, 70, 68, 68),
                                              ),
                                            ), // Second Text Field
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // Add more containers as needed
                              ],
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
    );
  }
}
