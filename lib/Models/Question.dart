import 'package:number_crush/Models/Level.dart';

class Question {
  int _levelId = 0;
  int _operand_1 = 0;
  String _operator = '';
  int _operand_2 = 0;
  int _ans_1 = 0;
  int _ans_2 = 0;
  int _ans_3 = 0;
  int _correctAns = 0;
  double _time = 0;

  Question.fromMap(Map<String, dynamic> data) {
    _operator = data['operator'];
    _operand_1 = data['operand_1'];
    _operand_2 = data['operand_2'];
    _correctAns = data['correctAns'];
    _time = data['time'];
  }

  set levelId(int levelId) {
    _levelId = levelId;
  }

  int get levelId => _levelId;
  int get operand_1 => _operand_1;
  int get operand_2 => _operand_2;
  String get operator => _operator;
  int get ans_1 => _ans_1;
  int get ans_2 => _ans_2;
  int get ans_3 => _ans_3;
  int get correctAns => _correctAns;
  double get time => _time;

  void setAnswer(List<int> answers) {
    _ans_1 = answers[0];
    _ans_2 = answers[1];
    _ans_3 = answers[2];
  }

  Question.fromDatabase(Map<String, dynamic> map) {
    _levelId = map['levelId'];
    _operand_1 = map['operand_1'];
    _operator = map['operator'];
    _operand_2 = map['operand_2'];
    _ans_1 = map['ans_1'];
    _ans_2 = map['ans_2'];
    _ans_3 = map['ans_3'];
    _correctAns = map['correctAns'];
    _time = map['time'];
  }
}
