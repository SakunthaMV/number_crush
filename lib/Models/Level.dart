class Level {
  int _id = 0;
  int _toUnlock = 0;
  int _stageId = 0;
  int _stars = 0;
  double _time = 0.0;
  String _status = 'Locked';

  Level(this._id, this._toUnlock, this._stageId);

  int get id => _id;
  int get toUnlock => _toUnlock;
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
    map['id'] = _id;
    map['toUnlock'] = _toUnlock;
    map['stars'] = _stars;
    map['stageId'] = _stageId;
    map['time'] = _time;
    map['status'] = _status;

    return map;
  }

  Level.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _toUnlock = map['toUnlock'];
    _stars = map['stars'];
    _stageId = map['stageId'];
    _time = map['time'];
    _status = map['status'];
  }
}
