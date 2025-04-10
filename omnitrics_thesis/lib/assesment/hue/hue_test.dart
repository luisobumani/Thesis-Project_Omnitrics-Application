import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/homepage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// A simple helper data class that packages a color and the original slot index in the right column.
class DraggableTileData {
  final Color color;
  final int fromIndex;
  DraggableTileData(this.color, this.fromIndex);
}

class HueTest extends StatefulWidget {
  const HueTest({Key? key}) : super(key: key);

  @override
  _HueTestState createState() => _HueTestState();
}

class _HueTestState extends State<HueTest> {
  // The 14 draggable reference colors.
  List<Color> referenceColors = [
    const Color(0xFF6D7C54),
    const Color(0xFF627E78),
    const Color(0xFF8D7D6F),
    const Color(0xFF927B8D),
    const Color(0xFF877C99),
    const Color(0xFF5E8394),
    const Color(0xFF6A7CA8),
    const Color(0xFF746D8E),
    const Color(0xFF8F859D),
    const Color(0xFF718790),
    const Color(0xFF7577A3),
    const Color(0xFF867792),
    const Color(0xFF9A8A8E),
    const Color(0xFF997D66),
  ];

  List<Color?> testColors = [
    const Color(0xFF396FB3), 
    ...List<Color?>.filled(14, null),
  ];

  final double tileSize = 35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hue Test',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30
        ),),
        backgroundColor: Colors.deepPurple,
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
      body: Container(
        color: Colors.grey[300],
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        child: Column(
          children: [
            Text(
              'Drag the Colors in the correct order!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              ),
            SizedBox(height: 10.h,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       SizedBox(height: 8.h),
                        Expanded(
                          child: ListView.builder(
                            itemCount: referenceColors.length,
                            itemBuilder: (context, index) {
                              final color = referenceColors[index];
                              return Draggable<Color>(
                                data: color,
                                feedback: _buildTile(color),
                                childWhenDragging: Opacity(
                                  opacity: 0.3,
                                  child: _buildTile(color),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Center(
                                    child: SizedBox(
                                      width: tileSize,
                                      height: tileSize,
                                      child: _buildTile(color),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8.h),
                        Expanded(
                          child: ListView.builder(
                            itemCount: testColors.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Center(
                                    child: SizedBox(
                                      width: tileSize,
                                      height: tileSize,
                                      child: _buildTile(testColors[index] ?? Colors.white),
                                    ),
                                  ),
                                );
                              }
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Center(
                                  child: DragTarget<Object>(
                                    onWillAccept: (incomingData) {
                                      if (incomingData is Color) {
                                        return testColors[index] == null;
                                      }
                                      if (incomingData is DraggableTileData) {
                                        return true;
                                      }
                                      return false;
                                    },
                                    onAccept: (incomingData) {
                                      setState(() {
                                        if (incomingData is DraggableTileData) {
                                          if (testColors[index] == null) {
                                            testColors[index] = incomingData.color;
                                            testColors[incomingData.fromIndex] = null;
                                          } else {
                                            final temp = testColors[index];
                                            testColors[index] = incomingData.color;
                                            testColors[incomingData.fromIndex] = temp;
                                          }
                                        } else if (incomingData is Color) {
                                          if (testColors[index] == null) {
                                            testColors[index] = incomingData;
                                            referenceColors.remove(incomingData);
                                          }
                                        }
                                      });
                                    },
                                    builder: (context, candidateData, rejectedData) {
                                      final isActive = candidateData.isNotEmpty;
                                      final currentColor = testColors[index];
                                      // If there's a tile here, wrap it in a Draggable to support reordering.
                                      Widget innerTile;
                                      if (currentColor != null) {
                                        innerTile = Draggable<DraggableTileData>(
                                          data: DraggableTileData(currentColor, index),
                                          feedback: _buildTile(currentColor),
                                          childWhenDragging: Opacity(
                                            opacity: 0.3,
                                            child: _buildTile(currentColor),
                                          ),
                                          child: _buildTile(currentColor),
                                        );
                                      } else {
                                        innerTile = _buildTile(Colors.white);
                                      }
                                      return Container(
                                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                                        width: tileSize,
                                        height: tileSize,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: isActive ? Colors.green : Colors.black12,
                                            width: isActive ? 2 : 1,
                                          ),
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: innerTile,
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0.h),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => HomePage()));
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.deepPurple.shade900;
                      }
                      return Colors.deepPurple;
                    }
                  ),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 16.h
                    )
                  ),
                  elevation: WidgetStateProperty.all<double>(
                    10
                  )
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(Color color) {
    return Container(
      width: tileSize,
      height: tileSize,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(
          color: Colors.black12,
          width: 1.w,
        ),
      ),
    );
  }
}