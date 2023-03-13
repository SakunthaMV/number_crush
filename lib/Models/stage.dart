class Stage {
  int _id = 0;
  int _forUnlock = 0;
  int _stars = 0;
  String _status = 'Locked';

  Stage(this._forUnlock);

  int get id => _id;
  int get forUnlock => _forUnlock;
  int get stars => _stars;
  String get status => _status;

  Stage.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _forUnlock = map['forUnlock'];
    _stars = map['stars'];
    _status = map['status'];
  }
}
