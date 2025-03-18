class TestConfig {
  final String imagePath;
  final List<String> options;
  final int correctAnswerIndex;

  TestConfig({
    required this.imagePath,
    required this.options,
    required this.correctAnswerIndex,
  });
}

final List<TestConfig> testConfigs = [
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_01.jpg',
    options: ['16', '8', '6', '15'],
    correctAnswerIndex: 0,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_02.jpg',
    options: ['42', '12', '74', '21'],
    correctAnswerIndex: 2,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_03.jpg',
    options: ['7', '6', '2', '9'],
    correctAnswerIndex: 1,
  ),
];
