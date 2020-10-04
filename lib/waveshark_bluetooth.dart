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

  void sendMessage(message) async
  {
    // await _writeCharacteristic.setNotifyValue(true);
    await _writeCharacteristic.write(utf8.encode(message));
    print("Test message sent to server");
  }
}