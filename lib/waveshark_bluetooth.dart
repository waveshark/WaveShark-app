import "package:flutter_blue/flutter_blue.dart";

import "dart:convert";

class WavesharkBluetooth {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;

  WavesharkBluetooth(bluetoothDevice, readCharacteristic, writeCharacteristic) {
    _bluetoothDevice = bluetoothDevice;
    _readCharacteristic = readCharacteristic;
    _writeCharacteristic = writeCharacteristic;
  }

  void subscribeToNotifications() async
  {
    // Get notifications on server value changes
    await _readCharacteristic.setNotifyValue(true);
    _readCharacteristic.value.listen((event) {
      print("Message received from BLE server [" + String.fromCharCodes(event.toList()) + "]");
    });
  }

  void sendMessage(message) async
  {
    await _writeCharacteristic.write(utf8.encode(message));
  }
}