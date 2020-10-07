import "package:flutter/material.dart";

import "package:flutter_blue/flutter_blue.dart";
import "dart:convert";
import "dart:async";

class Messaging extends StatefulWidget {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;
  List<String> _messages = new List<String>();

  void setBluetoothDevice(bluetoothDevice)
  {
    _bluetoothDevice = bluetoothDevice;
  }

  void setReadCharacteristic(readCharacteristic)
  {
    _readCharacteristic = readCharacteristic;
  }

  void setWriteCharacteristic(writeCharacteristic)
  {
    _writeCharacteristic = writeCharacteristic;
  }

  void subscribeToNotifications() async
  {
    // Get notifications on server value changes
    await _readCharacteristic.setNotifyValue(true);
    _readCharacteristic.value.listen((event) {
      var message = String.fromCharCodes(event.toList());
      _messages.add(message);
      print("Message received from BLE server [" + message + "]");
    });
  }

  @override
  MessagingState createState() =>
      MessagingState(_bluetoothDevice, _readCharacteristic, _writeCharacteristic, _messages);
}

class MessagingState extends State<Messaging> {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;
  List<String> _messages;

  MessagingState(bluetoothDevice, readCharacteristic, writeCharacteristic, messages)
  {
    _bluetoothDevice = bluetoothDevice;
    _readCharacteristic = readCharacteristic;
    _writeCharacteristic = writeCharacteristic;
    _messages = messages;

    // TODO: Terrible hack, use something like an Observable List?
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_messages.length > 10) {
        _messages.removeAt(0);
      }

      setState(() {
        _messages;
      });
    });
  }

  void sendTestMessage() async {
    await _writeCharacteristic.write(utf8.encode("Test message"));
  }

  // TODO: Display incoming messages
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ..._messages.map((message) {
        return Text(message);
      }),
      FlatButton(
          color: Colors.blue,
          textColor: Colors.white,
          onPressed: sendTestMessage,
          child: Text("Send test message")),
    ]);
  }
}