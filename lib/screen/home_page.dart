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
  static const String apiKey =
      '69f9387f03ff4a1b8cf77e3c72da04de'; // TODO Add your api key here

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
      final response = await http
          .get(
            'https://api.weatherbit.io/v2.0/current?lat=${locationData.latitude}&lon=${locationData.longitude}&key=$apiKey',
          )
          .timeout(Duration(seconds: 5));

      debugPrint(response.body);

      if (response.statusCode == 200) {
        var addresses = await Geocoder.local.findAddressesFromCoordinates(
            Coordinates(locationData.latitude, locationData.longitude));
        var first = addresses.first;
        WeatherbitResponse uviResponse =
            WeatherbitResponse.fromJson(json.decode(response.body));
        uviResponse.cityName =
            '${first.subAdminArea} - ${first.adminArea} - ${first.countryName}';
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
