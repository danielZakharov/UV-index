import 'package:flutter/material.dart';
import 'package:uvindex/custom/theme.dart' as AppTheme;
import 'package:uvindex/uvi.dart';

class Result extends StatelessWidget {
  static const List<String> weekdays = [
    '',
    '',
    'Thứ hai',
    'Thứ ba',
    'Thứ tư',
    'Thứ năm',
    'Thứ sáu',
    'Thứ bảy',
    'Chủ nhật',
  ];

  final UVIResponse data;

  Result(this.data);

  @override
  Widget build(BuildContext context) {
    AppTheme.Theme theme = AppTheme.Theme(data.value.round());

    String _formatNumber(int number) {
      String ret = '0' + number.toString();
      return ret.substring(ret.length - 2, ret.length);
    }

    String _formatDate() {
      DateTime date = DateTime.parse(data.dateIso);
      return '${weekdays[date.weekday]} ${_formatNumber(date.day)} - ${_formatNumber(date.month)} - ${date.year} @ ${_formatNumber(date.hour)} : ${_formatNumber(date.minute)}';
    }

    return Scaffold(
      backgroundColor: theme.primary,
      appBar: AppBar(
        title: Text('UV Index'),
        backgroundColor: theme.secondary,
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: theme.text, fontSize: 14.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: data.cityName,
                        ),
                        TextSpan(
                          text: '\n${_formatDate()}',
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${data.value}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.text, fontSize: 60.0),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    theme.riskLevel,
                    style: TextStyle(color: theme.text, fontSize: 40.0),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    '${theme.description}\n\n\n\n\n\n',
                    style: TextStyle(color: theme.text, fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
