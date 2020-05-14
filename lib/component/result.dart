import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uvindex/custom/theme.dart' as AppTheme;
import 'package:uvindex/localization/app_localizations.dart';
import 'package:uvindex/model/weatherbit_data.dart';

class Result extends StatelessWidget {
//  final OpenUVResponse data;
  final WeatherbitResponse data;

  static const List<String> weekdays = [
    "",
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  static const List<String> months = [
    "",
    "jan",
    "feb",
    "mar",
    "apr",
    "may",
    "jun",
    "jul",
    "aug",
    "sep",
    "oct",
    "nov",
    "dec"
  ];

  Result(this.data);

  @override
  Widget build(BuildContext context) {
    AppTheme.Theme theme = AppTheme.Theme(data.uv.round(), context);

    String _formatNumber(int number) {
      String ret = '0' + number.toString();
      return ret.substring(ret.length - 2, ret.length);
    }

    String _formatDate() {
      DateTime date = data.observeTime;
      String weekday =
          AppLocalizations.of(context).translate(weekdays[date.weekday]);
      String month = AppLocalizations.of(context).translate(months[date.month]);
      return '$weekday, ${_formatNumber(date.day)} $month ${date.year} @ ${_formatNumber(date.hour)}:${_formatNumber(date.minute)}';
    }

    return Scaffold(
      backgroundColor: theme.secondary,
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('UV Index', style: TextStyle(color: theme.text)),
        ),
        backgroundColor: theme.primary,
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      data.cityName,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.text),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      '${_formatDate()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: theme.text),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: ImageIcon(
                            AssetImage('images/icons8-sunrise-64.png'),
                            color: theme.text,
                          )),
                          TextSpan(
                            text: '${data.sunrise}',
                            style: TextStyle(color: theme.text),
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          WidgetSpan(
                              child: ImageIcon(
                            AssetImage('images/icons8-sunset-64.png'),
                            color: theme.text,
                          )),
                          TextSpan(
                              text: '${data.sunset}',
                              style: TextStyle(color: theme.text)),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              '${data.uv.round()}',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.text, fontSize: 60.0),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    theme.riskLevel,
                    style: TextStyle(color: theme.text, fontSize: 40.0),
                  ),
                  Text(
                    '${theme.description}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.text, fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
