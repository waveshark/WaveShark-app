import "package:flutter_blue/flutter_blue.dart";

class WavesharkBluetooth {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;

  WavesharkBluetooth(bluetoothDevice, readCharacteristic, writeCharacteristic) {
    _bluetoothDevice = bluetoothDevice;
    _readCharacteristic = readCharacteristic;
    _writeCharacteristic = writeCharacteristic;
  }
}