import 'package:flutter/material.dart';

class ErrorAnnouncement extends StatelessWidget {
  final String error;
  final Function reloadCallback;

  ErrorAnnouncement(this.error, {this.reloadCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                        child: Icon(
                      Icons.announcement,
                      color: Colors.red,
                    )),
                    TextSpan(
                        text: '\n$error',
                        style: TextStyle(color: Colors.red, fontSize: 30.0)),
                  ],
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              FlatButton(
                color: Colors.transparent,
                child: Icon(
                  Icons.refresh,
                  size: 48,
                  color: Colors.white,
                ),
                onPressed: reloadCallback,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
