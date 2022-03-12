import 'package:flutter/material.dart';
import 'package:uvindex/custom/theme.dart' as AppTheme;
import 'package:uvindex/localization/app_localizations.dart';
import 'package:uvindex/model/weatherbit_data.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 201, 201, 201),
      child: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text("1"),
                Text("2"),
                Text("2"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
