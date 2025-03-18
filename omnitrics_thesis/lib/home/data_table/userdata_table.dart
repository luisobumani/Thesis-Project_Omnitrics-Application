import 'package:flutter/material.dart';
import 'package:flutter_circle_chart/flutter_circle_chart.dart';

/// A widget that shows a single CircleChart (using the gradient type) with separate data items.
Widget userData() {
  return Container(
    color: Colors.transparent, // Remove background color to make it see-through
    child: SingleChildScrollView(
      child: Column(
        children: [
          // Chart title for the gradient type.
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'You Are NOPIA',
              style: TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 8, 8, 8), // Keep text color visible
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // The CircleChart using the gradient chart type with transparent background.
          CircleChart(
            chartType: CircleChartType.gradient,
            backgroundColor: Colors.transparent, // <-- Make chart background transparent
            items: [
              CircleChartItemData(
                color: Colors.red,
                value: 30.0,
                name: 'PROTANOPIA',
                description: 'red-blind → Reduced sensitivity to red light',

              ),
              CircleChartItemData(
                color: Colors.green,
                value: 20.0,
                name: 'DEUTERANOPIA',
                description: 'green-blind → Reduced sensitivity to green light',
              ),
              CircleChartItemData(
                color: Colors.blue,
                value: 50.0,
                name: 'TRITANOPIA',
                description: 'blue-yellow blindness → Reduced sensitivity to blue light',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
