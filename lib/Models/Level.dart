import 'dart:ffi';

class Level {
  int _id;
  int _toUnlock;
  int _stars;
  int _stageId;
  Float _time;

  Level(this._id, this._stars, this._toUnlock, this._stageId, this._time);

  int get id => _id;
  int get toUnlock => _toUnlock;
  int get stars => _stars;
  int get stageId => _stageId;
  Float get time => _time;

  set toUnlock(int newToUnlock) {
    _toUnlock = newToUnlock;
  }

  set stats(int newStars) {
    _stars = newStars;
  }

  set stageId(int newStageId) {
    _stageId = newStageId;
  }

  set time(Float newTime) {
    _time = newTime;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['toUnlock'] = _toUnlock;
    map['stars'] = _stars;
    map['stageId'] = _stageId;
    map['time'] = _time;

    return map;
  }

  fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _toUnlock = map['toUnlock'];
    _stars = map['stars'];
    _stageId = map['stageId'];
    _time = map['time'];
  }
}
