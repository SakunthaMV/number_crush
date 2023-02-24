class Question {
  int _id;
  int _levelId;
  int _questionNumber;
  String _question;
  int _ans_1;
  int _ans_2;
  int _ans_3;
  int _ans_4;
  int _correctAns;

  Question(this._id, this._levelId, this._questionNumber, this._question,
      this._ans_1, this._ans_2, this._ans_3, this._ans_4, this._correctAns);

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
    var map = Map<String, dynamic>();
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

  fromMap(Map<String, dynamic> map) {
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
}
