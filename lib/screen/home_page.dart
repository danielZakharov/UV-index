import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:uvindex/component//error_announcement.dart';
import 'package:uvindex/component//loading.dart';
import 'package:uvindex/component//result.dart';
import 'package:uvindex/localization/app_localizations.dart';
import 'package:uvindex/model/weatherbit_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String apiKey = ''; // Add your api key here

  Future<LocationData> _getLocationData() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    debugPrint('Location: $_locationData');

    return _locationData;
  }

  Future<WeatherbitResponse> _getUVIndex() async {
    LocationData locationData = await _getLocationData();
    if (locationData != null) {
      final response = await http.get(
        'https://api.weatherbit.io/v2.0/current?lat=${locationData.latitude}&lon=${locationData.longitude}&key=$apiKey',
      ).timeout(Duration(seconds: 5));

//      http.Response response = http.Response('''{
//              "result": {
//                "uv": 5.3487,
//                "uv_time": "2020-05-13T02:29:11.757Z",
//                "uv_max": 12.2315,
//                "uv_max_time": "2020-05-13T04:54:28.013Z",
//                "ozone": 296.6,
//                "ozone_time": "2020-05-13T00:08:18.263Z",
//                "safe_exposure_time": {
//                  "st1": 23,
//                  "st2": 27,
//                  "st3": 36,
//                  "st4": 45,
//                  "st5": 73,
//                  "st6": 136
//                },
//                "sun_info": {
//                  "sun_times": {
//                    "solarNoon": "2020-05-13T04:54:28.013Z",
//                    "nadir": "2020-05-12T16:54:28.013Z",
//                    "sunrise": "2020-05-12T22:21:15.501Z",
//                    "sunset": "2020-05-13T11:27:40.524Z",
//                    "sunriseEnd": "2020-05-12T22:23:41.355Z",
//                    "sunsetStart": "2020-05-13T11:25:14.671Z",
//                    "dawn": "2020-05-12T21:57:30.099Z",
//                    "dusk": "2020-05-13T11:51:25.926Z",
//                    "nauticalDawn": "2020-05-12T21:29:23.527Z",
//                    "nauticalDusk": "2020-05-13T12:19:32.499Z",
//                    "nightEnd": "2020-05-12T21:00:31.971Z",
//                    "night": "2020-05-13T12:48:24.055Z",
//                    "goldenHourEnd": "2020-05-12T22:52:11.213Z",
//                    "goldenHour": "2020-05-13T10:56:44.813Z"
//                  },
//                  "sun_position": {
//                    "azimuth": -1.6052433170950107,
//                    "altitude": 0.9769808507485805
//                    }
//                  }
//                }
//              }''', _reload ? 200 : 400);

      debugPrint(response.body);

      if (response.statusCode == 200) {
        var addresses = await Geocoder.local.findAddressesFromCoordinates(
            Coordinates(locationData.latitude, locationData.longitude));
        var first = addresses.first;
        WeatherbitResponse uviResponse =
            WeatherbitResponse.fromJson(json.decode(response.body));
        uviResponse.cityName =
            '${first.subAdminArea} : ${first.adminArea} : ${first.countryName}';
        debugPrint(uviResponse.toString());
        return uviResponse;
      } else {
        debugPrint(
            'API response: ${response.statusCode} : ${response.reasonPhrase}');
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherbitResponse>(
      future: _getUVIndex(),
      builder:
          (BuildContext context, AsyncSnapshot<WeatherbitResponse> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else if (snapshot.hasError || !snapshot.hasData) {
          debugPrint('Error: ${snapshot.error}');
          return ErrorAnnouncement(
            AppLocalizations.of(context).translate('error_message'),
            reloadCallback: () => setState(() {}),
          );
        } else {
          return Result(snapshot.data);
        }
      },
    );
  }
}
