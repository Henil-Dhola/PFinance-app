import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartDemo extends StatefulWidget {
  @override
  _PieChartDemoState createState() => _PieChartDemoState();
}

class _PieChartDemoState extends State<PieChartDemo> {
  int? touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pie Chart Demo'),
      ),
      body: Center(
        child: PieChart(
          PieChartData(
            sections: _generateSections(),
            borderData: FlBorderData(show: false),
            sectionsSpace: 0,
            centerSpaceRadius: 80,
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections() {
    final double fontSize = 16;
    final double radius = 60;

    return [
      PieChartSectionData(
        color: Colors.red,
        value: 3000,
        title: '₹3000',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      ),
      PieChartSectionData(
        color: Colors.brown,
        value: 100,
        title: '₹100',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: 0,
        title: '0%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 0,
        title: '0%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      ),
    ];
  }
}
