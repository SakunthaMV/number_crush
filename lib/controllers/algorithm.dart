import 'dart:math';

class Algorithm {
  Random random = Random();

  final Map<int, dynamic> _data = {
    1: {
      'operators': ['+', '-'],
      'maxOparand': [10],
      'maxAnsDigit': 2,
      'numberOfQuestion': 2
    },
    2: {
      'operators': ['+', '-', '*'],
      'maxOparand': [100, 10],
      'maxAnsDigit': 3,
      'numberOfQuestion': 3
    },
    3: {
      'operators': ['+', '-', '*', '/'],
      'maxOparand': [100, 10],
      'maxAnsDigit': 3,
      'numberOfQuestion': 3
    },
    4: {
      'operators': ['+', '-', '*', '/'],
      'maxOparand': [1000, 100],
      'maxAnsDigit': 4,
      'numberOfQuestion': 4
    },
    5: {
      'operators': ['+', '-', '*', '/', 'squre'],
      'maxOparand': [1000, 100, 100],
      'maxAnsDigit': 4,
      'numberOfQuestion': 4
    },
    6: {
      'operators': ['+', '-', '*', '/', 'squre', 'squreRoot'],
      'maxOparand': [10000, 100, 100],
      'maxAnsDigit': 5,
      'numberOfQuestion': 4
    },
    7: {
      'operators': ['+', '-', '*', '/', 'squre', 'squreRoot', 'log'],
      'maxOparand': [10000, 100, 100, 100],
      'maxAnsDigit': 5,
      'numberOfQuestion': 5
    },
    8: {
      'operators': ['+', '-', '*', '/', 'squre', 'squreRoot', 'log'],
      'maxOparand': [100000, 1000, 100, 10],
      'maxAnsDigit': 6,
      'numberOfQuestion': 6
    }
  };

  final Map<int, List<String>> _operatorList = {
    0: ['+', '-'],
    1: ['*', '/'],
    2: ['squre', 'squreRoot'],
    3: ['log']
  };

  int _findTypeOfOperator(Map<int, List<String>> operator, String element) {
    for (var entry in operator.entries) {
      if (entry.value.contains(element)) {
        return entry.key;
      }
    }
    return -1;
  }

  int _questionRange(int questionNumber) {
    return 0 < questionNumber && questionNumber < 11
        ? 1
        : 10 < questionNumber && questionNumber < 51
            ? 2
            : 50 < questionNumber && questionNumber < 101
                ? 3
                : 100 < questionNumber && questionNumber < 201
                    ? 4
                    : 200 < questionNumber && questionNumber < 501
                        ? 5
                        : 500 < questionNumber && questionNumber < 1001
                            ? 6
                            : 1000 < questionNumber && questionNumber < 2001
                                ? 7
                                : 8;
  }

  List<String> _questionGenerator(Map<String, dynamic> dataMap) {
    String operator =
        dataMap['operators'][random.nextInt(dataMap['operators'].length)];
    int operandDigit = _findTypeOfOperator(_operatorList, operator);
    int firstValue = random.nextInt(dataMap['maxOparand'][operandDigit]);
    int secondValue = random.nextInt(dataMap['maxOparand'][operandDigit]);
    List<String> question = [
      firstValue.toString(),
      secondValue.toString(),
      operator
    ];

    return question;
  }

  Map<int, List<String>> _dataList(int questionNumber) {
    Map<int, List<String>> questionsMap = {};
    switch (_questionRange(questionNumber)) {
      case 1:
        {
          int numberOfQuestion = 2;
          for (int i = 0; i < numberOfQuestion; i++) {
            List<String> question = _questionGenerator(_data[1]);
            questionsMap[i + 1] = question;
          }
          return questionsMap;
        }
      case 2:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[2]['numberOfQuestion'] - 2);
          for (int i = 0; i < numberOfQuestion; i++) {
            List<String> question = _questionGenerator(_data[2]);
            questionsMap[i + 1] = question;
          }
          return questionsMap;
        }
      case 3:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[3]['numberOfQuestion'] - 2);
          for (int i = 0; i < numberOfQuestion; i++) {
            List<String> question = _questionGenerator(_data[3]);
            questionsMap[i + 1] = question;
          }
          return questionsMap;
        }
      case 4:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[4]['numberOfQuestion'] - 2);
          for (int i = 0; i < numberOfQuestion; i++) {
            List<String> question = _questionGenerator(_data[4]);
            questionsMap[i + 1] = question;
          }
          return questionsMap;
        }
      case 5:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[5]['numberOfQuestion'] - 2);
          for (int i = 0; i < numberOfQuestion; i++) {
            List<String> question = _questionGenerator(_data[5]);
            questionsMap[i + 1] = question;
          }
          return questionsMap;
        }
      case 6:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[6]['numberOfQuestion'] - 2);
          for (int i = 0; i < numberOfQuestion; i++) {
            List<String> question = _questionGenerator(_data[6]);
            questionsMap[i + 1] = question;
          }
          return questionsMap;
        }
      case 7:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[7]['numberOfQuestion'] - 2);
          for (int i = 0; i < numberOfQuestion; i++) {
            List<String> question = _questionGenerator(_data[7]);
            questionsMap[i + 1] = question;
          }
          return questionsMap;
        }
      case 8:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[8]['numberOfQuestion'] - 2);
          for (int i = 0; i < numberOfQuestion; i++) {
            List<String> question = _questionGenerator(_data[8]);
            questionsMap[i + 1] = question;
          }
          return questionsMap;
        }
      default:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[8]['numberOfQuestion'] - 2);
          for (int i = 0; i < numberOfQuestion; i++) {
            List<String> question = _questionGenerator(_data[8]);
            questionsMap[i + 1] = question;
          }
          return questionsMap;
        }
    }
  }

  Map<int, List<dynamic>> getQuestions(int questionNumber) {
    Map<int, List<dynamic>> dataMap = _dataList(questionNumber);
    Map<int, List<dynamic>> questions = {};
    for (var entry in dataMap.entries) {
      String operator = entry.value[2];
      int result = 0;
      int operand_1 = int.parse(entry.value[0]);
      int operand_2 = int.parse(entry.value[1]);
      if (operator == '+') {
        result = operand_1 + operand_2;
      } else if (operator == '-') {
        if (operand_1 > operand_2) {
          result = operand_1 - operand_2;
        } else {
          result = operand_2 - operand_1;
        }
      } else if (operator == '*') {
        result = operand_1 * operand_2;
      } else if (operator == '/') {
        result = operand_1 * operand_2;
        int temp = result;
        operand_1 = result;
        result = temp;
      } else if (operator == 'squre') {
        result = pow(operand_1, 2) as int;
      } else if (operator == 'squreRoot') {
        result = pow(operand_1, 2) as int;
        int temp = result;
        result = operand_1;
        operand_1 = temp;
      } else {
        if (operand_1 > operand_2) {
          result = pow(operand_1, operand_2) as int;
        } else {
          result = pow(operand_2, operand_1) as int;
          int temp = operand_1;
          operand_1 = operand_2;
          operand_2 = temp;
        }
        int temp = result;
        result = operand_2;
        operand_2 = temp;
      }

      questions[entry.key] = [operand_1, operator, operand_2, result];
    }
    return questions;
  }
}
