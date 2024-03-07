import 'package:flutter/material.dart';

class ExpenseTotal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
<<<<<<< HEAD
      color: Color(0xFFF6573D3),
=======
>>>>>>> 55e3053c9b6f6e9f18e405be255ddd818b5a3a22
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
<<<<<<< HEAD
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/icons/money.png'),
                  alignment: Alignment.topRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expense Total',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                Text('₹ 3000',
                    style: TextStyle(
                        color: Color(0xFFFFBFCFE),
                        fontSize: 45,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      width: 60.0, // Specify the width
                      height: 30.0, // Specify the height
                      decoration: BoxDecoration(
                        color: Color(0xFFFDB6565), // Specify the color
                        borderRadius: BorderRadius.circular(
                            6.0), // Optional border radius
                      ),
                      padding: EdgeInsets.all(4.0), // Add padding
                      child: Center(
                        child: Text(
                          '+ ₹ 240 ',
                          style: TextStyle(
                            color: Colors.white, // Specify the text color
                            fontSize: 17.0, // Specify the font size
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Than last month ',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
=======
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF6573D3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/money.png'),
                    alignment: Alignment.topRight,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expense Total',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text('₹ 3000',
                      style: TextStyle(
                          color: Color(0xFFFFBFCFE),
                          fontSize: 45,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        width: 60.0, // Specify the width
                        height: 30.0, // Specify the height
                        decoration: BoxDecoration(
                          color: Color(0xFFFDB6565), // Specify the color
                          borderRadius: BorderRadius.circular(
                              6.0), // Optional border radius
                        ),
                        padding: EdgeInsets.all(4.0), // Add padding
                        child: Center(
                          child: Text(
                            '+ ₹ 240 ',
                            style: TextStyle(
                              color: Colors.white, // Specify the text color
                              fontSize: 17.0, // Specify the font size
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Than last month ',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
>>>>>>> 55e3053c9b6f6e9f18e405be255ddd818b5a3a22
      ),
    );
  }
}
