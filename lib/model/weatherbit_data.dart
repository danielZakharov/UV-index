class WeatherbitResponse {
  final String sunrise; // in GMT timezone
  final String sunset; // in GMT timezone
  final String observeTime; // in GMT timezone
  final double uv;
  String cityName;

  WeatherbitResponse(this.sunrise, this.sunset, this.observeTime, this.uv,
      {this.cityName});

  factory WeatherbitResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    _Data data = list.map((i) => _Data.fromJson(i)).toList().first;
    int offset = DateTime.parse(data._observeTime).timeZoneOffset.inHours;

    return WeatherbitResponse(
        _localizeTime(data._sunrise, offset), _localizeTime(data._sunset, offset), data._observeTime, data._uv);
  }

  static String _localizeTime(String input, int offset) {
    List<String> values = input.split(':');
    int hour = int.parse(values.first) + offset;
    if (hour >= 24) hour -= 24;
    return '$hour:${values.last}';
  }
}

class _Data {
  final String _sunrise; // in GMT timezone
  final String _sunset; // in GMT timezone
  final String _observeTime; // in GMT timezone
  final double _uv;

  _Data(this._sunrise, this._sunset, this._observeTime, this._uv);

  factory _Data.fromJson(Map<String, dynamic> json) {
    return _Data(json['sunrise'] as String, json['sunset'] as String,
        json['last_ob_time'] as String, json['uv'] as double);
  }
}
