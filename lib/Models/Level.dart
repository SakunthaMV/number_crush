class Level {
  int _forUnlock = 0;
  int _stageId = 0;
  int _stars = 0;
  double _time = 0.0;
  String _status = 'Locked';
  int _fullTime = 0;

  Level(this._forUnlock, this._stageId);
  Level.withStatus(this._stageId, this._status);

  int get forUnlock => _forUnlock;
  int get fullTIme => _fullTime;
  int get stars => _stars;
  int get stageId => _stageId;
  String get status => _status;
  double get times => _time;

  set stats(int newStars) {
    _stars = newStars;
  }

  set time(double newTime) {
    _time = newTime;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['forUnlock'] = _forUnlock;
    map['stars'] = _stars;
    map['stageId'] = _stageId;
    map['time'] = _time;
    map['status'] = _status;

    return map;
  }

  Level.fromMap(Map<String, dynamic> map) {
    _forUnlock = map['forUnlock'];
    _stars = map['stars'];
    _stageId = map['stageId'];
    _time = map['time'];
    _status = map['status'];
    _fullTime = map['fullTime'];
  }
}
