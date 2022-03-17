class OpenUVResponse {
  double uv;
  double temp;
  String uvTime;
  String cityName;

  OpenUVResponse({this.uv, this.temp, this.uvTime, this.cityName});

  factory OpenUVResponse.fromJson(Map<String, dynamic> json) {
    return OpenUVResponse(
        uv: null ? null : _Result.fromJson(json['result'])._uv,
        temp: null ? null : _Result.fromJson(json['result'])._temp,
        uvTime: _Result.fromJson(json['result'])._uvTime);
  }

  @override
  String toString() {
    return 'UVIResponse: {\n\tuv: $uv,\n\ttenp: $temp,\n\tuv_time: $uvTime, \n\tlocation: $cityName\n}';
  }
}

class _Result {
  final double _uv;
  final double _temp;
  final String _uvTime;

  _Result(this._uv, this._temp, this._uvTime);

  factory _Result.fromJson(Map<String, dynamic> json) {
    return _Result(json['uv'] as double, json['temp'] as double,
        json['uv_time'] as String);
  }
}
