import "package:flutter/material.dart";

import "package:waveshark/waveshark_bluetooth.dart";

class MessagingState extends State<Messaging> {
  Function _getWavesharkBluetooth;

  MessagingState(getWavesharkBluetooth)
  {
    _getWavesharkBluetooth = getWavesharkBluetooth;
  }

  // TODO: Add to List<String> of messages, call setState()
  void sendTestMessage() {
    _getWavesharkBluetooth().sendMessage("Test message");
  }

  // TODO: Display incoming and outgoing messages
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

class Messaging extends StatefulWidget {
  Function getWavesharkBluetooth;

  Messaging({this.getWavesharkBluetooth});

  @override
  MessagingState createState() =>
      MessagingState(getWavesharkBluetooth);
}