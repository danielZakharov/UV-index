import 'package:flutter/material.dart';
import 'package:uvindex/localization/app_localizations.dart';

class Theme {
  Color primary;
  Color secondary;
  Color text;
  String riskLevel;
  String description;

  final int uvIndex;
  final BuildContext context;

  Theme(this.uvIndex, this.context) {
    if (uvIndex <= 2) {
      primary = Colors.green.shade800;
      secondary = Colors.green.shade700;
      text = Colors.green.shade200;
      riskLevel = AppLocalizations.of(context).translate('risk_level_low');
      description = AppLocalizations.of(context).translate('message_low');
    } else if (uvIndex <= 5) {
      primary = Colors.yellow.shade800;
      secondary = Colors.yellow.shade700;
      text = Colors.yellow.shade200;
      riskLevel = AppLocalizations.of(context).translate('risk_level_moderate');
      description = AppLocalizations.of(context).translate('message_moderate') +
          AppLocalizations.of(context).translate('message_general');
    } else if (uvIndex <= 7) {
      primary = Colors.orange.shade800;
      secondary = Colors.orange.shade700;
      text = Colors.orange.shade200;
      riskLevel = AppLocalizations.of(context).translate('risk_level_high');
      description = AppLocalizations.of(context).translate('message_high') +
          AppLocalizations.of(context).translate('message_general');
    } else if (uvIndex <= 10) {
      primary = Colors.red.shade800;
      secondary = Colors.red.shade700;
      text = Colors.red.shade200;
      riskLevel =
          AppLocalizations.of(context).translate('risk_level_very_high');
      description =
          AppLocalizations.of(context).translate('message_very_high') +
              AppLocalizations.of(context).translate('message_general');
    } else {
      primary = Colors.purple.shade800;
      secondary = Colors.purple.shade700;
      text = Colors.purple.shade200;
      riskLevel = AppLocalizations.of(context).translate('risk_level_extreme');
      description = AppLocalizations.of(context).translate('message_extreme') +
          AppLocalizations.of(context).translate('message_general');
    }
  }
}
