import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/assesment/ishihara/data/ishihara_test_model.dart';
import 'package:omnitrics_thesis/assesment/ishihara/data/plates_config.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_08.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int _thisPageIndex = 6; 

class IshiharaTest07 extends StatefulWidget {
  final IshiharaTestModel testModel;
  const IshiharaTest07({Key? key, required this.testModel}) : super(key: key);

  @override
  _IshiharaTest07State createState() => _IshiharaTest07State();
}

class _IshiharaTest07State extends State<IshiharaTest07> {
  final TestConfig config = testConfigs[6];
  int selectedOption = -1;
  bool answerSubmitted = false;
  Color? nextButtonColor;

  void _handleOptionTap(int index) {
    if (answerSubmitted) return;
    setState(() {
      selectedOption = index;
    });
  }

  Future<void> _handleNextTap() async {
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
    widget.testModel.updateAnswer(plateIndex: 6, selectedOption: selectedOption);

    final prefs = await SharedPreferences.getInstance();
    // config.index is 0 for page1, 1 for page2, etc.
    await prefs.setInt('ishiharaLastPage', _thisPageIndex + 1);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0.r),
              side: BorderSide(color: Colors.deepPurple, width: 1.w),
            ),
            insetPadding: EdgeInsets.all(20.0.h),
            title: Text(
              'Result',
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
            content: Text(selectedOption == config.correctAnswerIndex
                ? 'Your answer is correct! Continue to the next plate!'
                : 'The correct answer is 74. Continue to the next plate!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IshiharaTest08(testModel: widget.testModel),
                    ),
                  );
                },
                style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.deepPurple.shade900;
                      }
                      return Colors.deepPurple;
                    }),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)))),
                child: Text('Continue'),
              )
            ],
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
        centerTitle: true,
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
