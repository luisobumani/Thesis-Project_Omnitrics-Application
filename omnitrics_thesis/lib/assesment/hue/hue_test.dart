import 'package:flutter/material.dart';
import 'dart:math';

class HueTestGrid extends StatefulWidget {
  const HueTestGrid({Key? key}) : super(key: key);

  @override
  State<HueTestGrid> createState() => _HueTestGridState();
}

class _HueTestGridState extends State<HueTestGrid> {
  final List<Color> _colors = [...initialColors]..shuffle(Random());

  bool _isCorrectOrder() {
    final hues = _colors.map((c) => HSLColor.fromColor(c).hue).toList();
    for (int i = 0; i < hues.length - 1; i++) {
      if (hues[i] > hues[i + 1]) {
        return false;
      }
    }
    return true;
  }

  void _swapColors(Color draggedColor, int targetIndex) {
    setState(() {
      final draggedIndex = _colors.indexOf(draggedColor);
      if (draggedIndex == -1 || targetIndex == -1) return;

      final temp = _colors[draggedIndex];
      _colors[draggedIndex] = _colors[targetIndex];
      _colors[targetIndex] = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text(
          'Hue Test',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepPurple.shade700,
                Colors.deepPurple.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
        body: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _colors.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // 4 columns across
                    mainAxisSpacing: 8.0, // vertical spacing
                    crossAxisSpacing: 8.0, // horizontal spacing
                    childAspectRatio: 1.0, // keep squares
                  ),
                  itemBuilder: (context, index) {
                    final color = _colors[index];

                    // Wrap each tile in a DragTarget that accepts a Color.
                    return DragTarget<Color>(
                      onWillAccept: (data) => true,
                      onAccept: (draggedColor) {
                        // Swap the dragged color with whatever is at this target index.
                        _swapColors(draggedColor, index);
                      },
                      builder: (context, candidateData, rejectedData) {
                        // The tile itself is a Draggable.
                        return Draggable<Color>(
                          data: color,
                          feedback: _buildTile(color, isDragging: true),
                          childWhenDragging: _buildTile(color.withOpacity(0.4),
                              isDragging: false),
                          child: _buildTile(color, isDragging: false),
                        );
                      },
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  _isCorrectOrder()
                      ? 'Tiles are in the correct hue order!'
                      : 'Arrange tiles by ascending hue.',
                  style: TextStyle(
                    color: _isCorrectOrder() ? Colors.green : Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildTile(Color color, {bool isDragging = false}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.grey.shade800, width: 1),
      ),
    );
  }
}

final List<Color> initialColors = [
  Color.fromARGB(255, 117, 31, 31), 
  Color(0xFF8B0000), 
  Color(0xFFFF0000), 
  Color(0xFFFF4500), 
  Color(0xFFFF7F7F), 
];