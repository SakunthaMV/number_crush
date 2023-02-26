class Stage {
  int _id;
  int _toUnlock;
  int _stars;

  Stage(this._id, this._stars, this._toUnlock);

  int get id => _id;
  int get toUnlock => _toUnlock;
  int get stars => _stars;

  set toUnlock(int newToUnlock) {
    _toUnlock = newToUnlock;
  }

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

  fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _toUnlock = map['toUnlock'];
    _stars = map['stars'];
  }
}
