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
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_04.jpg',
    options: ['1', '5', '2', '3'],
    correctAnswerIndex: 2,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_05.jpg',
    options: ['1', '4', '9', '7'],
    correctAnswerIndex: 3,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_06.jpg',
    options: ['5', '6', '2', '7'],
    correctAnswerIndex: 0,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_07.jpg',
    options: ['8', '0', '3', '9'],
    correctAnswerIndex: 0,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_08.jpg',
    options: ['8', '2', '3', '0'],
    correctAnswerIndex: 2,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_09.jpg',
    options: ['29', '36', '57', '19'],
    correctAnswerIndex: 0,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_10.jpg',
    options: ['75', '32', '55', '45'],
    correctAnswerIndex: 3,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_11.jpg',
    options: ['67', '97', '86', '91'],
    correctAnswerIndex: 1,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_12.jpg',
    options: ['72', '23', '42', '35'],
    correctAnswerIndex: 2,
  ),
];
