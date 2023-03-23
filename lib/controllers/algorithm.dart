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
    const double scale = 1.1;
    switch (type) {
      case 0:
        int t = 3 + size_1 * size_2 * 1;
        return t / scale;
      case 1:
        int t = 2 + size_1 * size_2 * 4;
        return t / scale;
      case 2:
        int t = 3 + size_1 * size_2 * 3;
        return t / scale;
      case 3:
        int t = 2 + size_1 * size_2 * 2;
        return t / scale;
    }
    return 0.0;
  }

  int _questionRange(int level) {
    if (0 < level && level <= 10) {
      return 1;
    } else if (10 < level && level <= 50) {
      return 2;
    } else if (50 < level && level <= 100) {
      return 3;
    } else if (100 < level && level <= 200) {
      return 4;
    } else if (200 < level && level <= 500) {
      return 5;
    } else if (500 < level && level <= 1000) {
      return 6;
    } else if (1000 < level && level <= 2000) {
      return 7;
    } else {
      return 8;
    }
  }

  Question _questionGenerator(Map<String, dynamic> dataMap) {
    final String operator =
        dataMap['operators'][random.nextInt(dataMap['operators'].length)];
    final int operatorType = _findTypeOfOperator(_operatorList, operator);
    final int operandDigit = dataMap['maxOparand'][operatorType];
    int operand_1 = random.nextInt(operandDigit);
    int operand_2 = 1 + random.nextInt(operandDigit - 1);
    final double t = double.parse((_timeForQuesion(
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
        final int temp = operand_1;
        operand_1 = operand_2;
        operand_2 = temp;
      }
    } else if (operator == '*') {
      result = operand_1 * operand_2;
    } else if (operator == '/') {
      result = operand_1 * operand_2;
      final int temp = result;
      result = operand_1;
      operand_1 = temp;
    } else if (operator == 'squre') {
      result = pow(operand_1, 2) as int;
    } else if (operator == 'squreRoot') {
      result = pow(operand_1, 2) as int;
      final int temp = result;
      result = operand_1;
      operand_1 = temp;
    } else {
      if (operand_1 > operand_2) {
        result = pow(operand_1, operand_2) as int;
      } else {
        result = pow(operand_2, operand_1) as int;
        final int temp = operand_1;
        operand_1 = operand_2;
        operand_2 = temp;
      }
      final int temp = result;
      result = operand_2;
      operand_2 = temp;
    }
    final Map<String, dynamic> map = {
      'operator': operator,
      'operand_1': operand_1,
      'operand_2': operand_2,
      'correctAns': result,
      'time': t,
    };
    final Question question = Question.fromMap(map);
    return question;
  }

  List<Question> questionList(int level) {
    List<Question> questionList = [];
    final int range = _questionRange(level);
    final int numberOfQuestion =
        2 + random.nextInt(_data[range]['numberOfQuestion'] - 1);
    for (int i = 0; i < numberOfQuestion; i++) {
      Question question = _questionGenerator(_data[range]);
      question.levelId = level;
      question = _answerGenerator(question);
      questionList.add(question);
    }
    return questionList;
  }

  List<int> _answerList(int lastDigit, int sameDigitAns, int result) {
    Set<int> answerSet = {};
    if (result < 15) {
      while (answerSet.length != 3) {
        final int ans = random.nextInt(15);
        if (ans == result) {
          continue;
        }
        answerSet.add(ans);
      }
    } else if (result > 135) {
      while (answerSet.length != sameDigitAns) {
        final int ans =
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
      final int ans =
          (result * 0.85 + random.nextInt((result * 0.3).round())).round();
      if (ans == result) {
        continue;
      }
      answerSet.add(ans);
    }
    return answerSet.toList();
  }

  Question _answerGenerator(Question question) {
    final int result = question.correctAns;
    final int lastDigit = result % 10;
    List<int> answer = [];
    if (question.levelId < 100) {
      answer = _answerList(lastDigit, 0, result);
    } else if (question.levelId < 200) {
      answer = _answerList(lastDigit, 1, result);
    } else if (question.levelId < 500) {
      answer = _answerList(lastDigit, 2, result);
    } else {
      answer = _answerList(lastDigit, 3, result);
    }
    question.setAnswer(answer);
    return question;
  }

  int startValue(int stageId) {
    return 112 * (stageId - 1);
  }

  int toUnlockStar(int level) {
    final int stageId = (level / 50).ceil();
    final int levelId = (level % 50);
    if (levelId == 0) {
      return startValue(stageId) + 110;
    } else if (levelId == 1) {
      return startValue(stageId);
    } else if (levelId < 11) {
      return startValue(stageId) + levelId;
    } else if (levelId < 31) {
      return startValue(stageId) + 2 * (levelId - 10) + 10;
    } else {
      return startValue(stageId) + 3 * (levelId - 30) + 50;
    }
  }

  final DatabaseFunctions db = DatabaseFunctions();
  Future<Stage> stageGenerator(int stageId) async {
    Stage stage = Stage(startValue(stageId) - 2 - await db.getStars());
    return stage;
  }

  Future<double> calculateStars(
    List<bool> result,
    int level,
    double usedTime,
  ) async {
    final List<Question> questions = await db.getQuestions(level);
    double givenTime = 0.0;
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
