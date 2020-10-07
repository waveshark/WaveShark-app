import "package:flutter/material.dart";

import "package:flutter_blue/flutter_blue.dart";
import "package:shared_preferences/shared_preferences.dart";
import "dart:convert";

import "package:waveshark/waveshark_bluetooth.dart";

class BluetoothPair extends StatefulWidget {
  Function setWavesharkBluetooth;
  Function getPaired;
  Function setPaired;

  BluetoothPair(
      {@required this.setWavesharkBluetooth,
      @required this.getPaired,
      @required this.setPaired});

  @override
  BluetoothPairState createState() => BluetoothPairState(
      setWavesharkBluetooth: setWavesharkBluetooth,
      getPaired: getPaired,
      setPaired: setPaired);
}

class BluetoothPairState extends State<BluetoothPair> {
  bool _scanning = true;

  Function setWavesharkBluetooth;
  Function getPaired;
  Function setPaired;

  BluetoothPairState(
      {@required this.setWavesharkBluetooth,
      @required this.getPaired,
      @required this.setPaired});

  String _deviceName;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    WidgetsBinding.instance.addPostFrameCallback((_) => scanForDevices());
  }

  void _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _deviceName = (prefs.getString('deviceName') ?? null);
    });
  }

  void _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("deviceName", _deviceName);
  }

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
    List<BluetoothService> services =
        await _devices[deviceName].discoverServices();

    // Find desired service and desired characteristics
    services.forEach((service) {
      if (service.uuid.toString() == _desiredServiceUUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() ==
              _desiredReadCharacteristicUUID) {
            _readCharacteristic = characteristic;
          }

          if (characteristic.uuid.toString() ==
              _desiredWriteCharacteristicUUID) {
            _writeCharacteristic = characteristic;
          }
        });
      }
    });

    // We're paired now
    setWavesharkBluetooth(WavesharkBluetooth(
        _devices[deviceName], _readCharacteristic, _writeCharacteristic));
    _deviceName = deviceName;
    await _saveSettings();
    setPaired(true);
  }

  void scanForDevices() {
    // Start scanning
    // TODO: Make scan time (currently 5 seconds) a constant
    FlutterBlue flutterBlue = FlutterBlue.instance;
    flutterBlue.startScan(timeout: Duration(seconds: 5)).then((value) {
      // Stop scanning
      setState(() {
        _scanning = false;
      });
      flutterBlue.stopScan();
      // subscription.cancel(); // TODO: Is this needed?
    });

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name.startsWith("WaveShark ")) {
          setState(() {
            _devices.putIfAbsent(r.device.name, () => r.device);
          });

          // Auto-connect if this is the device name stored in settings
          if (r.device.name == _deviceName) {
            // TODO: Handle case where the stored device name is not available for connection
            connectToDevice(_deviceName);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _scanning
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("Scanning for devices"),
              CircularProgressIndicator()
            ],
          )
        : Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text("Choose a device to pair with"),
            ..._devices.keys.map((deviceName) {
              return FlatButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: () => connectToDevice(deviceName),
                  child: Text(deviceName));
            })
          ]);
  }
}
