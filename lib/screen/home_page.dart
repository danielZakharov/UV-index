import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  static const String apiKey = '69f9387f03ff4a1b8cf77e3c72da04de';
  SharedPreferences prefs;
  var whichskin = 0;
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
        prefs = await SharedPreferences.getInstance() ?? 0;
        whichskin = int.parse(prefs.get("type") ?? 0.toString());
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
        } else if (whichskin != 0) {
          return Result(snapshot.data, whichskin);
        } else
          return SkinScreen(snapshot.data, whichskin);
      },
    );
  }
}

// ignore: must_be_immutable
class SkinScreen extends StatefulWidget {
  WeatherbitResponse data;
  int selected;
  SkinScreen(this.data, this.selected);
  @override
  State<SkinScreen> createState() => _SkinScreen(data, selected);
}

class _SkinScreen extends State<SkinScreen> {
  SharedPreferences prefs;
  int selected;
  final WeatherbitResponse data;
  int selectedRadioTile;
  int selectedRadio;

  _SkinScreen(this.data, this.selected);
  @override
  void initState() {
    super.initState();
    selectedRadio = 0;
    selectedRadioTile = selected;
  }

  setSkinType(int val) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("type", val.toString());
  }

  getSkinType() async {
    prefs = await SharedPreferences.getInstance();
    return int.parse(prefs.get("type"));
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.only(top: 40),
      color: Colors.white10,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text("Выберите свой тип кожи!"),
            RadioListTile(
              value: 1,
              groupValue: selectedRadioTile,
              title: const Text("Type 1"),
              subtitle: const Text("Radio 1 Subtitle"),
              onChanged: (val) {
                setSkinType(val);
                setSelectedRadioTile(int.parse(val.toString()));
              },
              activeColor: Colors.black,
              secondary: Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 24.0,
                semanticLabel: 'Текст изображения типа кожи',
              ),
              selected: false,
            ),
            RadioListTile(
              value: 2,
              groupValue: selectedRadioTile,
              title: const Text("Type 2"),
              subtitle: const Text("Radio 2 Subtitle"),
              onChanged: (val) {
                setSkinType(val);
                setSelectedRadioTile(int.parse(val.toString()));
              },
              activeColor: Colors.black,
              /*secondary: OutlineButton(
            child: Text("Say Hi"),
            onPressed: () {
              print("Say Hello");
            },
          ),*/
              selected: false,
            ),
            ElevatedButton(
                onPressed: () {
                  if (selectedRadioTile == 0) {
                    simpleDialog(context);
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Result(data, selectedRadioTile)));
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  shadowColor: Colors.black,
                ),
                child: Text(' Продолжить')),
          ]),
    ));
  }
}

Future simpleDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: Text('ВНИМАНИЕ!')),
        content: Text('Вы должны выбрать тип кожи!'),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
