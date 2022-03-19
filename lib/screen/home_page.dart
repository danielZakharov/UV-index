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
            const Text(
              "Выберите свой тип кожи",
              style: TextStyle(fontSize: 20),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                    "Шкала Фитцпатрика включает 6 типов кожи, которые по-разному реагируют на солнечное воздействие."),
              ),
            ),
            RadioListTile(
              value: 1,
              groupValue: selectedRadioTile,
              title: const Text("Type I"),
              subtitle: const Text(
                  "Очень светлая кожа, белая; рыжие или светлые волосы; светлые глаза; вероятны веснушки."),
              onChanged: (val) {
                setSkinType(val);
                setSelectedRadioTile(int.parse(val.toString()));
              },
              activeColor: Colors.black,
              secondary: Image.asset("images/type1.png"),
              selected: false,
            ),
            RadioListTile(
              value: 2,
              groupValue: selectedRadioTile,
              title: const Text("Type II"),
              subtitle: const Text(
                  "Светлая кожа, белая; светлые глаза; светлые волосы."),
              onChanged: (val) {
                setSkinType(val);
                setSelectedRadioTile(int.parse(val.toString()));
              },
              activeColor: Colors.black,
              secondary: Image.asset("images/type2.png"),
              selected: false,
            ),
            RadioListTile(
              value: 3,
              groupValue: selectedRadioTile,
              title: const Text("Type III"),
              subtitle: const Text(
                  "Светлая кожа, кремово-белый; любой цвет глаз или волос (очень распространенный тип кожи)."),
              onChanged: (val) {
                setSkinType(val);
                setSelectedRadioTile(int.parse(val.toString()));
              },
              activeColor: Colors.black,
              secondary: Image.asset("images/type3.png"),
              selected: false,
            ),
            RadioListTile(
              value: 4,
              groupValue: selectedRadioTile,
              title: const Text("Type IV"),
              subtitle: const Text(
                  "Оливковая кожа, типичная кожа средиземноморских кавказцев; темно-коричневые волосы; пигментация от средней до сильной."),
              onChanged: (val) {
                setSkinType(val);
                setSelectedRadioTile(int.parse(val.toString()));
              },
              activeColor: Colors.black,
              secondary: Image.asset("images/type4.png"),
              selected: false,
            ),
            RadioListTile(
              value: 5,
              groupValue: selectedRadioTile,
              title: const Text("Type V"),
              subtitle: const Text(
                  "Коричневая кожа, типичная кожа Ближнего Востока; темные волосы; редко чувствиетелен к солнцу."),
              onChanged: (val) {
                setSkinType(val);
                setSelectedRadioTile(int.parse(val.toString()));
              },
              activeColor: Colors.black,
              secondary: Image.asset("images/type5.png"),
              selected: false,
            ),
            RadioListTile(
              value: 6,
              groupValue: selectedRadioTile,
              title: const Text("Type VI"),
              subtitle: const Text("Темная кожа; редко чувствителен к солнцу."),
              onChanged: (val) {
                setSkinType(val);
                setSelectedRadioTile(int.parse(val.toString()));
              },
              activeColor: Colors.black,
              secondary: Image.asset("images/type6.png"),
              selected: false,
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton(
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
                ),
              ),
            )
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
