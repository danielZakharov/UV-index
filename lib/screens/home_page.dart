import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:uvindex/uvi.dart';
import 'package:uvindex/components//error_announcement.dart';
import 'package:uvindex/components//loading.dart';
import 'package:uvindex/components//result.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String apiKey = 'MjFkOTdhZDU3NjYyNmEwN2ZkZGM1OTRkNGVjY2I1MjI=';

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

  Future<UVIResponse> _getUVIndex() async {
    LocationData locationData = await _getLocationData();
    if (locationData != null) {
      final response = await http.get(
          'http://api.openweathermap.org/data/2.5/uvi?appid=${utf8.fuse(base64).decode(apiKey)}&lat=${locationData.latitude}&lon=${locationData.longitude}');
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          Coordinates(locationData.latitude, locationData.longitude));
      var first = addresses.first;

      if (response.statusCode == 200) {
        UVIResponse uviResponse =
            UVIResponse.fromJson(json.decode(response.body));
        uviResponse.cityName = '${first.subAdminArea} : ${first.adminArea} : ${first.countryName}';
        print(uviResponse);
        return uviResponse;
      } else {
        print('failed query for UV index');
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UVIResponse>(
      future: _getUVIndex(),
      builder: (BuildContext context, AsyncSnapshot<UVIResponse> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return ErrorAnnouncement('Something went wrong!');
        } else {
          return Result(snapshot.data);
        }
      },
    );
  }
}
