import "package:flutter/material.dart";
import 'package:waveshark/waveshark_bluetooth.dart';
// import "package:waveshark/waveshark_bluetooth.dart"

class Messaging extends StatelessWidget {
  final WavesharkBluetooth wavesharkBluetooth;

  Messaging({this.wavesharkBluetooth});

  void sendTestMessage() {
    wavesharkBluetooth.sendMessage("Test message");
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: sendTestMessage,
          child: Text("Send test message")),
    ]);
  }
}
