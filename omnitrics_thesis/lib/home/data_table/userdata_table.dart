import 'package:flutter/material.dart';
import 'package:flutter_circle_chart/flutter_circle_chart.dart';

/// A widget that shows a single CircleChart (using the gradient type) with separate data items.
Widget userData() {
  return Container(
    color: const Color(0xff4C2882), // Optional background color
    child: SingleChildScrollView(
      child: Column(
        children: [
          // Chart title for the gradient type.
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Gradient',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // The CircleChart using the gradient chart type with separate data.
          CircleChart(
            chartType: CircleChartType.gradient,
            items: [
              CircleChartItemData(
                color: Colors.red,
                value: 30.0,
                name: 'Data A',
                description: 'PRE MAY PULANG MATA KA XD',
              ),
              CircleChartItemData(
                color: Colors.green,
                value: 20.0,
                name: 'Data B',
                description: 'IKAW SI LOLONG LOL',
              ),
              CircleChartItemData(
                color: Colors.blue,
                value: 50.0,
                name: 'Data C',
                description: 'ZAIDO KA BES??',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
