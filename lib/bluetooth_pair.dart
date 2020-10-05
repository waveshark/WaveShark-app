import "package:flutter/material.dart";

import "package:flutter_blue/flutter_blue.dart";
import "dart:convert";

import "package:waveshark/waveshark_bluetooth.dart";

class BluetoothPair extends StatefulWidget {
  Function getPaired;
  Function setPaired;
  Function setWavesharkBluetooth;

  BluetoothPair({@required this.getPaired, @required this.setPaired, @required this.setWavesharkBluetooth});

  @override
  BluetoothPairState createState() => BluetoothPairState(getPaired: getPaired, setPaired: setPaired, setWavesharkBluetooth: setWavesharkBluetooth);
}

class BluetoothPairState extends State<BluetoothPair> {
  Function getPaired;
  Function setPaired;
  Function setWavesharkBluetooth;

  BluetoothPairState({@required this.getPaired, @required this.setPaired, @required this.setWavesharkBluetooth});

  final String _desiredServiceUUID             = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  final String _desiredReadCharacteristicUUID  = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
  final String _desiredWriteCharacteristicUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";

  final Map<String, BluetoothDevice> _devices = Map<String, BluetoothDevice>();

  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;

  void connectToDevice(String deviceName) async {
    print("Attempting to connect to device [" + deviceName + "]");

    // Connect to device
    await _devices[deviceName].connect();
    print("Connected to device [" + deviceName + "]");

    // Discover services
    List<BluetoothService> services = await _devices[deviceName].discoverServices();

    // Find desired service and desired characteristics
    services.forEach((service) {
      if (service.uuid.toString() == _desiredServiceUUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == _desiredReadCharacteristicUUID) {
            _readCharacteristic = characteristic;
          }

          if (characteristic.uuid.toString() == _desiredWriteCharacteristicUUID) {
            _writeCharacteristic = characteristic;
          }
        });
      }
    });

    // We're paired now
    var wavesharkBluetooth = new WavesharkBluetooth(_devices[deviceName], _readCharacteristic, _writeCharacteristic);
    wavesharkBluetooth.subscribeToNotifications();
    setWavesharkBluetooth(wavesharkBluetooth);
    setPaired(true);
  }

  void scanForDevices() async {
    // Start scanning
    FlutterBlue flutterBlue = FlutterBlue.instance;
    await flutterBlue.startScan(timeout: Duration(seconds: 5));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name.startsWith("WaveShark ")) {
          setState(() {
            _devices.putIfAbsent(r.device.name, () => r.device);
          });
        }
      }
    });

    // TODO: Stop scanning
    // subscription.cancel();
    // flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    return getPaired()
        ? Text("You are paired with a WaveShark device")
        : Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: scanForDevices,
                    child: Text("Tap to scan for WaveShark devices")),
                ..._devices.keys.map((deviceName) {
                  return FlatButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () => connectToDevice(deviceName),
                      child: Text("Pair with " + deviceName));
                })
              ]));
  }
}
