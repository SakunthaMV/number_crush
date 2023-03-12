class Stage {
  int _toUnlock = 0;
  int _stars = 0;
  String _status = 'Locked';

  Stage(this._toUnlock);

  int get toUnlock => _toUnlock;
  int get stars => _stars;
  String get status => _status;

  set stats(int newStars) {
    _stars = newStars;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['toUnlock'] = _toUnlock;
    map['stars'] = _stars;
    map['status'] = _status;

    return map;
  }

  Stage.fromMap(Map<String, dynamic> map) {
    _toUnlock = map['toUnlock'];
    _stars = map['stars'];
    _status = map['status'];
  }
}
