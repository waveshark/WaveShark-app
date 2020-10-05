import "package:flutter/material.dart";
import 'package:waveshark/waveshark_bluetooth.dart';
// import "package:waveshark/waveshark_bluetooth.dart"

// TODO: Convert to StatefulWidget
class Messaging extends StatelessWidget {
  WavesharkBluetooth _wavesharkBluetooth;

  Messaging(wavesharkBluetooth)
  {
    _wavesharkBluetooth = wavesharkBluetooth;
    _wavesharkBluetooth.setOnMessageReceived(onMessageReceived);
  }

  void onMessageReceived(message)
  {
    // TODO: Add to List<String> of messages, call setState()
    print("Message received from BLE server [" + message + "]");
  }

  // TODO: Add to List<String> of messages, call setState()
  void sendTestMessage() {
    _wavesharkBluetooth.sendMessage("Test message");
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
