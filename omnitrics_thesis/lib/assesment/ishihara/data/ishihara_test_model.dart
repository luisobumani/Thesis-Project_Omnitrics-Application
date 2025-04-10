class IshiharaTestModel {
  final List<int> answers;

  IshiharaTestModel({int totalPlates = 12})
  : answers = List<int>.filled(totalPlates, -1, growable: false);

  void updateAnswer({required int plateIndex, required int selectedOption}) {
    if (plateIndex < 0 || plateIndex >= answers.length) {
      throw RangeError('plateIndex out of range');
    }
    answers[plateIndex] = selectedOption;
  }

  bool get isComplete {
    return !answers.contains(-1);
  }

  void reset() {
    for (int i=0; i < answers.length; i++) {
      answers[i] = -1;
    }
  }

  @override
  String toString() {
    return 'IshiharaTestModel(answers: $answers)';
  }
}