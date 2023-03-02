class Question {
  int _id = 0;
  int _levelId = 0;
  int _questionNumber = 0;
  String _question = '';
  int _ans_1 = 0;
  int _ans_2 = 0;
  int _ans_3 = 0;
  int _ans_4 = 0;
  int _correctAns = 0;

  Question(this._id, this._levelId, this._questionNumber, this._question);

  Question.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _levelId = map['levelId'];
    _questionNumber = map['questionNumber'];
    _question = map['question'];
    _ans_1 = map['ans_1'];
    _ans_2 = map['ans_2'];
    _ans_3 = map['ans_3'];
    _ans_4 = map['ans_4'];
    _correctAns = map['correctAns'];
  }

  int get id => _id;
  int get levelId => _levelId;
  int get questionNumber => _questionNumber;
  String get question => _question;
  int get ans_1 => _ans_1;
  int get ans_2 => _ans_2;
  int get ans_3 => _ans_3;
  int get ans_4 => _ans_4;
  int get correctAns => _correctAns;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = _id;
    map['levelId'] = _levelId;
    map['questionNumber'] = _questionNumber;
    map['question'] = _question;
    map['ans_1'] = _ans_1;
    map['ans_2'] = _ans_2;
    map['ans_3'] = _ans_3;
    map['ans_4'] = _ans_4;
    map['correctAns'] = _correctAns;

    return map;
  }
}
