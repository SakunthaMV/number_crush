class Stage {
  int _id = 0;
  int _toUnlock = 0;
  int _stars = 0;

  Stage(this._id, this._toUnlock);

  int get id => _id;
  int get toUnlock => _toUnlock;
  int get stars => _stars;

  set stats(int newStars) {
    _stars = newStars;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map['id'] = _id;
    map['toUnlock'] = _toUnlock;
    map['stars'] = _stars;

    return map;
  }

  Stage.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _toUnlock = map['toUnlock'];
    _stars = map['stars'];
  }
}
