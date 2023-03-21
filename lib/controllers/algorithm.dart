import 'dart:math';
import 'package:number_crush/Models/Question.dart';
import 'package:number_crush/Services/database_functions.dart';

import '../Models/stage.dart';

class Algorithm {
  Random random = Random();

  final Map<int, dynamic> _data = {
    1: {
      'operators': ['+', '-'],
      'maxOparand': [10],
      'numberOfQuestion': 2
    },
    2: {
      'operators': ['+', '-', '*'],
      'maxOparand': [100, 10],
      'numberOfQuestion': 3
    },
    3: {
      'operators': ['+', '-', '*', '/'],
      'maxOparand': [100, 10],
      'numberOfQuestion': 3
    },
    4: {
      'operators': ['+', '-', '*', '/'],
      'maxOparand': [1000, 100],
      'numberOfQuestion': 4
    },
    5: {
      'operators': ['+', '-', '*', '/', 'squre'],
      'maxOparand': [1000, 100, 100],
      'numberOfQuestion': 4
    },
    6: {
      'operators': ['+', '-', '*', '/', 'squre', 'squreRoot'],
      'maxOparand': [10000, 100, 100],
      'numberOfQuestion': 4
    },
    7: {
      'operators': ['+', '-', '*', '/', 'squre', 'squreRoot', 'log'],
      'maxOparand': [10000, 100, 100, 10],
      'numberOfQuestion': 5
    },
    8: {
      'operators': ['+', '-', '*', '/', 'squre', 'squreRoot', 'log'],
      'maxOparand': [100000, 1000, 100, 10],
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

  double _timeForQuesion(int type, int size_1, int size_2) {
    double scale = 1.3;
    switch (type) {
      case 0:
        {
          int t = 3 + size_1 * size_2 * 1;
          return t / scale;
        }
      case 1:
        {
          int t = 2 + size_1 * size_2 * 4;
          return t / scale;
        }
      case 2:
        {
          int t = 3 + size_1 * size_2 * 3;
          return t / scale;
        }
      case 3:
        {
          int t = 2 + size_1 * size_2 * 2;
          return t / scale;
        }
    }
    return 0.0;
  }

  int _questionRange(int level) {
    return 0 < level && level < 11
        ? 1
        : 10 < level && level < 51
            ? 2
            : 50 < level && level < 101
                ? 3
                : 100 < level && level < 201
                    ? 4
                    : 200 < level && level < 501
                        ? 5
                        : 500 < level && level < 1001
                            ? 6
                            : 1000 < level && level < 2001
                                ? 7
                                : 8;
  }

  Question _questionGenerator(Map<String, dynamic> dataMap) {
    String operator =
        dataMap['operators'][random.nextInt(dataMap['operators'].length)];
    int operatorType = _findTypeOfOperator(_operatorList, operator);
    int operandDigit = dataMap['maxOparand'][operatorType];
    int operand_1 = random.nextInt(operandDigit);
    int operand_2 = 1 + random.nextInt(operandDigit - 1);
    double t = double.parse((_timeForQuesion(
            operatorType, '$operand_1'.length, '$operand_2'.length))
        .toStringAsFixed(2));
    int result = 0;
    if (operator == '+') {
      result = operand_1 + operand_2;
    } else if (operator == '-') {
      if (operand_1 > operand_2) {
        result = operand_1 - operand_2;
      } else {
        result = operand_2 - operand_1;
        int temp = operand_1;
        operand_1 = operand_2;
        operand_2 = temp;
      }
    } else if (operator == '*') {
      result = operand_1 * operand_2;
    } else if (operator == '/') {
      result = operand_1 * operand_2;
      int temp = result;
      result = operand_1;
      operand_1 = temp;
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
    Map<String, dynamic> map = {
      'operator': operator,
      'operand_1': operand_1,
      'operand_2': operand_2,
      'correctAns': result,
      'time': t,
    };
    Question question = Question.fromMap(map);
    return question;
  }

  List<Question> questionList(int level) {
    List<Question> questionList = [];
    switch (_questionRange(level)) {
      case 1:
        {
          int numberOfQuestion = 2;
          for (int i = 0; i < numberOfQuestion; i++) {
            Question question = _questionGenerator(_data[1]);
            question.levelId = level;
            question = _answerGenerator(question);
            questionList.add(question);
          }
          return questionList;
        }
      case 2:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[2]['numberOfQuestion'] - 1);
          for (int i = 0; i < numberOfQuestion; i++) {
            Question question = _questionGenerator(_data[2]);
            question.levelId = level;
            question = _answerGenerator(question);
            questionList.add(question);
          }
          return questionList;
        }
      case 3:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[3]['numberOfQuestion'] - 1);
          for (int i = 0; i < numberOfQuestion; i++) {
            Question question = _questionGenerator(_data[3]);
            question.levelId = level;
            question = _answerGenerator(question);
            questionList.add(question);
          }
          return questionList;
        }
      case 4:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[4]['numberOfQuestion'] - 1);
          for (int i = 0; i < numberOfQuestion; i++) {
            Question question = _questionGenerator(_data[4]);
            question.levelId = level;
            question = _answerGenerator(question);
            questionList.add(question);
          }
          return questionList;
        }
      case 5:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[5]['numberOfQuestion'] - 1);
          for (int i = 0; i < numberOfQuestion; i++) {
            Question question = _questionGenerator(_data[5]);
            question.levelId = level;
            question = _answerGenerator(question);
            questionList.add(question);
          }
          return questionList;
        }
      case 6:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[6]['numberOfQuestion'] - 1);
          for (int i = 0; i < numberOfQuestion; i++) {
            Question question = _questionGenerator(_data[6]);
            question.levelId = level;
            question = _answerGenerator(question);
            questionList.add(question);
          }
          return questionList;
        }
      case 7:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[7]['numberOfQuestion'] - 1);
          for (int i = 0; i < numberOfQuestion; i++) {
            Question question = _questionGenerator(_data[7]);
            question.levelId = level;
            question = _answerGenerator(question);
            questionList.add(question);
          }
          return questionList;
        }
      case 8:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[8]['numberOfQuestion'] - 1);
          for (int i = 0; i < numberOfQuestion; i++) {
            Question question = _questionGenerator(_data[8]);
            question.levelId = level;
            question = _answerGenerator(question);
            questionList.add(question);
          }
          return questionList;
        }
      default:
        {
          int numberOfQuestion =
              2 + random.nextInt(_data[8]['numberOfQuestion'] - 1);
          for (int i = 0; i < numberOfQuestion; i++) {
            Question question = _questionGenerator(_data[8]);
            question.levelId = level;
            question = _answerGenerator(question);
            questionList.add(question);
          }
          return questionList;
        }
    }
  }

  List<int> _answerList(int lastDigit, int sameDigitAns, int result) {
    Set<int> answerSet = {};
    if (result < 15) {
      while (answerSet.length != sameDigitAns) {
        int ans = random.nextInt(15);
        if (ans == result) {
          continue;
        }
        answerSet.add(ans);
      }
    } else if (result < 135) {
      while (answerSet.length != sameDigitAns) {
        int ans =
            (result * 0.85 + random.nextInt((result * 0.3).round())).round();
        if (ans == result) {
          continue;
        }
        answerSet.add(ans);
      }
    } else {
      int lastDigit = result % 10;
      while (answerSet.length != sameDigitAns) {
        int ans =
            (result * 0.85 + random.nextInt((result * 0.3).round())).round();
        if (ans == result) {
          continue;
        } else if (ans % 10 != lastDigit) {
          continue;
        }
        answerSet.add(ans);
      }
    }

    while (answerSet.length != 3) {
      int ans =
          (result * 0.85 + random.nextInt((result * 0.3).round())).round();
      if (ans == result) {
        continue;
      } else if (ans % 10 != lastDigit) {
        continue;
      }
      answerSet.add(ans);
    }

    return answerSet.toList();
  }

  Question _answerGenerator(Question question) {
    int result = question.correctAns;
    int lastDigit = result % 10;
    List<int> answer = [];
    if (question.levelId < 50) {
      answer = _answerList(lastDigit, 0, result);
    } else if (question.levelId < 100) {
      answer = _answerList(lastDigit, 1, result);
    } else if (question.levelId < 200) {
      answer = _answerList(lastDigit, 2, result);
    } else {
      answer = _answerList(lastDigit, 3, result);
    }
    question.setAnswer(answer);
    return question;
  }

  int startValue(int stageId) {
    return 102 * (stageId - 1);
  }

  int toUnlockStar(int level) {
    int stageId = (level / 50).ceil();
    int levelId = (level % 50);
    if (levelId == 0) {
      return startValue(stageId) + 100;
    } else if (levelId == 1) {
      return startValue(stageId);
    } else if (levelId < 11) {
      return startValue(stageId) + levelId;
    } else if (levelId < 41) {
      return startValue(stageId) + 2 * (levelId - 10) + 10;
    } else {
      return startValue(stageId) + 3 * (levelId - 40) + 70;
    }
  }

  Future<Stage> stageGenerator(int stageId) async {
    DatabaseFunctions db = DatabaseFunctions();
    Stage stage = Stage(startValue(stageId) - 2 - await db.getStars());
    return stage;
  }

  Future<double> calculateStars(
      List<bool> result, int level, double usedTime) async {
    DatabaseFunctions db = DatabaseFunctions();
    List<Question> questions = await db.getQuestions(level);
    double givenTime = 0;
    double correctTime = 0.0;
    for (int i = 0; i < questions.length; i++) {
      if (result[i]) {
        correctTime += questions[i].time;
      }
      givenTime += questions[i].time;
    }
    await db.updateLevelFullTime(level, givenTime);
    double value = 0.0;
    if (givenTime / usedTime > 1) {
      value = (1 - (usedTime / givenTime)) + (correctTime / givenTime) * 3;
    } else if (result.contains(true)) {
      value = (givenTime / usedTime) + (correctTime / givenTime);
    }
    return value;
  }
}
