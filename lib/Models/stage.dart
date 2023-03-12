class Stage {
  int _id = 0;
  int _toUnlock = 0;
  int _stars = 0;
  String _status = 'Locked';

  Stage(this._toUnlock);

  int get id => _id;
  int get toUnlock => _toUnlock;
  int get stars => _stars;
  String get status => _status;

  Stage.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _toUnlock = map['toUnlock'];
    _stars = map['stars'];
    _status = map['status'];
  }
}
