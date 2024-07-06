

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pf_project/src/models/user_model.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pie Chart Demo',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.lightBlue),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _fetchExpenseData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final Map<String, dynamic>? expenseData = snapshot.data;
              if (expenseData == null || expenseData.isEmpty) {
                return Text('No expense data found');
              }

              // Debug print to check expenseData contents
              print('Expense Data: $expenseData');

              return PieChart(
                PieChartData(
                  sections: _generatePieChartSections(expenseData),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 80,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchExpenseData() async {
    final expenseData = <String, dynamic>{};

    try {
      final currentUserEmail = FirebaseAuth.instance.currentUser!.email;
      final userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: currentUserEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userData = user_model.fromSnapshot(userSnapshot.docs.first);
        final expenseSnapshot = await FirebaseFirestore.instance
            .collection('expense')
            .where('phone', isEqualTo: userData.phone)
            .get();

        if (expenseSnapshot.docs.isNotEmpty) {
          expenseSnapshot.docs.forEach((doc) {
            final data = doc.data() as Map<String, dynamic>;

            // Accumulate expenses excluding documents with 'phone' key
            data.forEach((key, value) {
              if (value is int || value is double) {
                expenseData[key] = (expenseData[key] ?? 0) + value;
              }
            });
          });
        }
      }
    } catch (e) {
      print('Error fetching expense data: $e');
    }

    return expenseData;
  }

// Define a list of colors
  List<Color> colorList = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
    Colors.amber,
    // Add more colors as needed
  ];

  List<PieChartSectionData> _generatePieChartSections(Map<String, dynamic> expenseData) {
    final List<PieChartSectionData> sections = [];
    int index = 0;

    expenseData.forEach((key, value) {
      // Use colors from the colorList
      final color = colorList[index % colorList.length];
      index++;

      sections.add(PieChartSectionData(
        color: color,
        value: value.toDouble(),
        title: '₹$value',
        radius: 60,
        titleStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    });

    return sections;
  }


}
