class TestConfig {
  final String imagePath;
  final List<String> options;
  final int correctAnswerIndex;
  final int? deutanAnswerIndex;
  final int? protanAnswerIndex;
  final int? tritanAnswerIndex;


  TestConfig({
    required this.imagePath,
    required this.options,
    required this.correctAnswerIndex,
    this.deutanAnswerIndex,
    this.protanAnswerIndex,
    this.tritanAnswerIndex,
  });
}

final List<TestConfig> testConfigs = [
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_01.png',
    options: ['12', '13', '16', '15'],
    correctAnswerIndex: 1,
    deutanAnswerIndex: 1,
    protanAnswerIndex: 1,
    tritanAnswerIndex: 1,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_02.jpg',
    options: ['3', '6', '5', '7'],
    correctAnswerIndex: 1,
    deutanAnswerIndex: 2,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_03.jpg',
    options: ['0', '3', '2', '8'],
    correctAnswerIndex: 3,
    deutanAnswerIndex: 1,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_04.jpg',
    options: ['1', '5', '2', '3'],
    correctAnswerIndex: 1,
    deutanAnswerIndex: 2,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_05.jpg',
    options: ['3', '4', '5', '6'],
    correctAnswerIndex: 0,
    deutanAnswerIndex: 2,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_06.jpg',
    options: ['15', '16', '17', '19'],
    correctAnswerIndex: 0,
    deutanAnswerIndex: 2,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_07.jpg',
    options: ['21', '32', '36', '74'],
    correctAnswerIndex: 3,
    deutanAnswerIndex: 0,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_08.jpg',
    options: ['8', '2', '3', '0'],
    correctAnswerIndex: 1,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_09.jpg',
    options: ['29', '45', '57', '19'],
    correctAnswerIndex: 1,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_10.jpg',
    options: ['97', '32', '55', '45'],
    correctAnswerIndex: 0,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_11.jpg',
    options: ['11', '13', '16', '15'],
    correctAnswerIndex: 2,
  ),
  TestConfig(
    imagePath: 'assets/images/ishihara/ishihara_12.jpg',
    options: ['4', '2', '42', '24'],
    correctAnswerIndex: 2,
  ),
];
