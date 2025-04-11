import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/assesment/ishihara/data/ishihara_test_model.dart';
import 'package:omnitrics_thesis/assesment/ishihara/data/plates_config.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_06.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IshiharaTest05 extends StatefulWidget {
  final IshiharaTestModel testModel;
  const IshiharaTest05({Key? key, required this.testModel}) : super(key: key);

  @override
  _IshiharaTest05State createState() => _IshiharaTest05State();
}

class _IshiharaTest05State extends State<IshiharaTest05> {
  final TestConfig config = testConfigs[4];
  int selectedOption = -1;
  bool answerSubmitted = false;
  Color? nextButtonColor;

  void _handleOptionTap(int index) {
    if (answerSubmitted) return;
    setState(() {
      selectedOption = index;
    });
  }

  void _handleNextTap() {
    if (selectedOption == -1 || answerSubmitted) return;

    setState(() {
      answerSubmitted = true;
      if (selectedOption == config.correctAnswerIndex) {
        nextButtonColor = Colors.green;
      } else {
        nextButtonColor = Colors.red;
      }
    });
    //Update model
    widget.testModel.updateAnswer(plateIndex: 4, selectedOption: selectedOption);

    //Navigate to next page
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IshiharaTest06(testModel: widget.testModel),)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ishihara Test',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30.sp,
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          children: [
            // Image section
            Expanded(
              flex: 4,
              child: Center(
                child: Image.asset(
                  config.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
           SizedBox(height: 16.h),
            // Options section
            Expanded(
              flex: 3,
              child: ListView.separated(
                itemCount: config.options.length,
                separatorBuilder: (context, index) =>
                   SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300.w),
                      child: ElevatedButton(
                        onPressed: () => _handleOptionTap(index),
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (states) {
                              if (selectedOption == index) {
                                return Colors.deepPurple.shade700;
                              }
                              return Colors.deepPurple.shade200;
                            },
                          ),
                          foregroundColor:
                              WidgetStateProperty.resolveWith<Color>(
                            (states) {
                              if (selectedOption == index) {
                                return Colors.white;
                              }
                              return Colors.black;
                            },
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          minimumSize:
                              WidgetStateProperty.all(Size(300.w, 50.h)),
                        ),
                        child: Text(
                          config.options[index],
                          style: TextStyle(fontSize: 18.sp),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Next button
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300.w),
                child: ElevatedButton(
                  onPressed: selectedOption != -1 && !answerSubmitted
                      ? _handleNextTap
                      : null,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color>(
                      (states) {
                        if (answerSubmitted && nextButtonColor != null) {
                          return nextButtonColor!;
                        }
                        return Colors.deepPurple.shade200;
                      },
                    ),
                    foregroundColor:
                        WidgetStateProperty.resolveWith<Color>(
                      (states) {
                        if (answerSubmitted && nextButtonColor != null) {
                          return Colors.white;
                        }
                        return Colors.black;
                      },
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    minimumSize:
                        WidgetStateProperty.all(Size(300.w, 50.h)),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 18.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
