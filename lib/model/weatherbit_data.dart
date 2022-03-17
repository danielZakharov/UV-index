class WeatherbitResponse {
  /*final String sunrise; // in GMT timezone
  final String sunset; // in GMT timezone*/
  final DateTime observeTime; // in GMT timezone
  final double uv;
  final double temp;
  final String icon;
  final String description;
  String cityName;

  WeatherbitResponse(/*this.sunrise, this.sunset,*/ this.observeTime, this.uv,
      this.temp, this.icon, this.description,
      {this.cityName});

  factory WeatherbitResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    DateTime now = new DateTime.now();
    _Data data = list.map((i) => _Data.fromJson(i)).toList().first;
    /*Duration offset =
        DateTime.parse(data._observeTime ?? now.toString()).timeZoneOffset;*/
    DateTime localObserveTime =
        DateTime.parse(data._observeTime ?? now.toString()) /*.add(offset)*/;

    return WeatherbitResponse(
        /*_localizeTime(data._sunrise, offset.inHours.toDouble()),
        _localizeTime(data._sunset, offset.inHours.toDouble()),*/
        localObserveTime,
        data._uv,
        data._temp,
        data._weather._icon,
        data._weather._description);
  }

  /*static String _localizeTime(String input, double offset) {
    List<String> values = input.split(':');
    double hour = double.parse(values.first) + offset;
    if (hour >= 24) hour -= 24;
    return '$hour:${values.last}';
  }*/

  @override
  String toString() {
    // return 'UVIResponse: {\n\tuv: $uv,\n\tuv_time: ${observeTime.toString()},\n\tlocation: $cityName,\n\tsunrise: $sunrise,\n\tsunset: $sunset,\n\ticon: $icon,\n\tdescription: $description\n}';
    return 'UVIResponse: {\n\tuv: $uv,\n\tuv_time: ${observeTime.toString()},\n\tlocation: $cityName,\n\ticon: $icon,\n\tdescription: $description\n\ttemp: $temp\n}';
  }
}

class _Data {
  /* final String _sunrise; // in GMT timezone
  final String _sunset; // in GMT timezone*/
  final String _observeTime; // in GMT timezone
  final double _uv;
  final double _temp;
  final _Weather _weather;

  _Data(/* this._sunrise, this._sunset,*/ this._observeTime, this._uv,
      this._temp, this._weather);

  factory _Data.fromJson(Map<String, dynamic> json) {
    return _Data(
      /* json['sunrise'] as String,
      json['sunset'] as String,*/
      json['last_ob_time'] as String,
      json['uv'] == null ? 0.0 : json['uv'].toDouble(),
      json['temp'] == null ? 0.0 : json['uv'].toDouble(),
      _Weather.fromJson(json['weather']),
    );
  }
}

class _Weather {
  final String _icon;
  final String _description;
  _Weather(this._icon, this._description);

  factory _Weather.fromJson(Map<String, dynamic> json) {
    return _Weather(json['icon'].toString(), (json['description'].toString()));
  }
}
