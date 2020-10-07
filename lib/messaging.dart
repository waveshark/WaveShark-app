import "package:flutter/material.dart";

import "package:flutter_blue/flutter_blue.dart";
import "dart:convert";

class Messaging extends StatefulWidget {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;

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
      print("Message received from BLE server [" + message + "]");
    });
  }

  @override
  MessagingState createState() =>
      MessagingState(_bluetoothDevice, _readCharacteristic, _writeCharacteristic);
}

class MessagingState extends State<Messaging> {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;

  MessagingState(bluetoothDevice, readCharacteristic, writeCharacteristic)
  {
    _bluetoothDevice = bluetoothDevice;
    _readCharacteristic = readCharacteristic;
    _writeCharacteristic = writeCharacteristic;
  }

  void sendTestMessage() async {
    await _writeCharacteristic.write(utf8.encode("Test message"));
  }

  // TODO: Display incoming messages
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