import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      'A': 100,
      'B': 200,
      'C': 300,
      'D': 400,
    };
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
              SizedBox(
                width: 120,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color(0xFFF6573D3),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: DropdownButton<String>(
                      value: 'This Month',
                      onChanged: (String? newValue) {},
                      items: <String>['This Month', 'This Day', 'This Year']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      elevation: 8,
                      underline: Container(),
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
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
                            Text(
                              'Statistics',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Center(
                                  child: Text(
                                    '₹ 2780 /',
                                    style: TextStyle(
                                        color: Colors
                                            .white, // Specify the text color
                                        fontSize: 30.0,
                                        fontWeight: FontWeight
                                            .bold // Specify the font size
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '₹ 3500 Per Month  ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    20), // Add some space between text and progress indicator
                            LinearProgressIndicator(
                              value: 2780 / 3500, // Calculate the progress
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
            padding:
                const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 10),
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
                SizedBox(
                  width: 120,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color(0xFFF6573D3),
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: DropdownButton<String>(
                        value: 'This Week',
                        onChanged: (String? newValue) {},
                        items: <String>['This Month', 'This Week', 'This Day']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        elevation: 8,
                        underline: Container(),
                        isExpanded: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 0),
            child: SizedBox(
              height: 280,
              width: 500,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 5),
                  child: PieChart(
                    dataMap: dataMap,
                    chartRadius:
                        200, // Adjust the chart radius according to your requirement
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    legendOptions: LegendOptions(
                      showLegendsInRow: true,
                      legendPosition: LegendPosition.bottom,
                      legendShape: BoxShape.circle,
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
                      color: Colors.transparent, // Choose your desired color
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
                                horizontal: 5), // Margin between containers
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      SizedBox(height: 5), // First Text Field
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
                                horizontal: 5), // Margin between containers
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      SizedBox(height: 5), // First Text Field
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
                                horizontal: 5), // Margin between containers
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset(
                                          'assets/icons/cinema.png')), // Icon
                                  SizedBox(
                                      width:
                                          10), // Spacer between icon and text fields
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Movies",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 5), // First Text Field
                                      Text(
                                        "- ₹170",
                                        style: TextStyle(
                                          fontSize: 20,
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
