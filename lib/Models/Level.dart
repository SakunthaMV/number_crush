class Level {
  int _stageId = 0;
  int _stars = 0;
  double _time = 0.0;
  double _fullTime = 0;
  double _doubleStar = 0.0;

  Level(this._stageId);

  double get fullTIme => _fullTime;
  int get stars => _stars;
  int get stageId => _stageId;
  double get times => _time;
  double get doubleStar => _doubleStar;

  set stats(int newStars) {
    _stars = newStars;
  }

  set time(double newTime) {
    _time = newTime;
  }

  Level.fromMap(Map<String, dynamic> map) {
    _stars = map['stars'];
    _stageId = map['stageId'];
    _time = map['time'];
    _fullTime = map['fullTime'];
    _doubleStar = map['doubleStar'];
  }
}
