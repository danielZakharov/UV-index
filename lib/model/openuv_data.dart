class OpenUVResponse {
  double uv;
  double temp;
  String uvTime;
  String cityName;
  String sunrise;
  String sunset;

  OpenUVResponse(
      {this.uv,
      this.temp,
      this.uvTime,
      this.cityName,
      this.sunrise,
      this.sunset});

  factory OpenUVResponse.fromJson(Map<String, dynamic> json) {
    return OpenUVResponse(
        uv: null ? null : _Result.fromJson(json['result'])._uv,
        temp: null ? null : _Result.fromJson(json['result'])._temp,
        uvTime: _Result.fromJson(json['result'])._uvTime,
        sunrise: _Result.fromJson(json['result'])._sunInfo._sunTimes._sunrise,
        sunset: _Result.fromJson(json['result'])._sunInfo._sunTimes._sunset);
  }

  @override
  String toString() {
    return 'UVIResponse: {\n\tuv: $uv,\n\ttenp: $temp,\n\tuv_time: $uvTime, \n\tlocation: $cityName, \n\tsunrise: $sunrise, \n\tsunset: $sunset\n}';
  }
}

class _Result {
  final double _uv;
  final double _temp;
  final String _uvTime;
  final _SunInfo _sunInfo;

  _Result(this._uv, this._temp, this._uvTime, this._sunInfo);

  factory _Result.fromJson(Map<String, dynamic> json) {
    return _Result(json['uv'] as double, json['temp'] as double,
        json['uv_time'] as String, _SunInfo.fromJson(json['sun_info']));
  }
}

class _SunInfo {
  final _SunTimes _sunTimes;

  _SunInfo(this._sunTimes);

  factory _SunInfo.fromJson(Map<String, dynamic> json) {
    return _SunInfo(_SunTimes.fromJson(json['sun_times']));
  }
}

class _SunTimes {
  final String _sunrise;
  final String _sunset;

  _SunTimes(this._sunrise, this._sunset);

  factory _SunTimes.fromJson(Map<String, dynamic> json) {
    return _SunTimes(json['sunrise'] as String, json['sunset'] as String);
  }
}
