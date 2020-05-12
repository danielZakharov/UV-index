class UVIResponse {
  final double lat;
  final double lon;
  String cityName;
  final String dateIso;
  final int date;
  final double value;

  UVIResponse({this.lat, this.lon, this.cityName, this.dateIso, this.date, this.value});

  factory UVIResponse.fromJson(Map<String, dynamic> json) {
    return UVIResponse(
      lat: json['lat'],
      lon: json['lon'],
      dateIso: json['date_iso'],
      date: json['date'],
      value: json['value'],
    );
  }

  @override
  String toString() {
    return 'UVIResponse: {\n\tlat: $lat,\n\tlon: $lon,\n\tlocation; $cityName,\n\tdate_iso: $dateIso,\n\tdate: $date,\n\tvalue: $value\n}';
  }
}
