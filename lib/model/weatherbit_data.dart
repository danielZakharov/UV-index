class WeatherbitResponse {
  final String sunrise; // in GMT timezone
  final String sunset; // in GMT timezone
  final DateTime observeTime; // in GMT timezone
  final double uv;
  final String icon;
  final String code;
  String cityName;

  WeatherbitResponse(this.sunrise, this.sunset, this.observeTime, this.uv,
      this.icon, this.code,
      {this.cityName});

  factory WeatherbitResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    _Data data = list.map((i) => _Data.fromJson(i)).toList().first;
    Duration offset = DateTime.parse(data._observeTime).timeZoneOffset;
    DateTime localObserveTime = DateTime.parse(data._observeTime).add(offset);

    return WeatherbitResponse(
        _localizeTime(data._sunrise, offset.inHours),
        _localizeTime(data._sunset, offset.inHours),
        localObserveTime,
        data._uv,
        data._weather._icon,
        data._weather._code);
  }

  static String _localizeTime(String input, int offset) {
    List<String> values = input.split(':');
    int hour = int.parse(values.first) + offset;
    if (hour >= 24) hour -= 24;
    return '$hour:${values.last}';
  }

  @override
  String toString() {
    return 'UVIResponse: {\n\tuv: $uv,\n\tuv_time: ${observeTime.toString()},\n\tlocation: $cityName,\n\tsunrise: $sunrise,\n\tsunset: $sunset,\n\ticon: $icon,\n\tcode: $code\n}';
  }
}

class _Data {
  final String _sunrise; // in GMT timezone
  final String _sunset; // in GMT timezone
  final String _observeTime; // in GMT timezone
  final double _uv;
  final _Weather _weather;

  _Data(
      this._sunrise, this._sunset, this._observeTime, this._uv, this._weather);

  factory _Data.fromJson(Map<String, dynamic> json) {
    return _Data(
      json['sunrise'] as String,
      json['sunset'] as String,
      json['last_ob_time'] as String,
      json['uv'] as double,
      _Weather.fromJson(json['weather']),
    );
  }
}

class _Weather {
  final String _icon;
  final String _code;

  _Weather(this._icon, this._code);

  factory _Weather.fromJson(Map<String, dynamic> json) {
    return _Weather(json['icon'] as String, json['code'] as String);
  }
}
