import "package:flutter/material.dart";
import "package:waveshark/messaging.dart";
import 'package:waveshark/waveshark_bluetooth.dart';

import "./bluetooth_pair.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WaveShark',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'WaveShark'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WavesharkBluetooth _wavesharkBluetooth;
  bool _paired = false; // TODO: Get from persistent storage?

  void setWavesharkBluetooth(wavesharkBluetooth)
  {
    _wavesharkBluetooth = wavesharkBluetooth;
  }

  bool getPaired() {
    return _paired;
  }

  void setPaired(paired) {
    setState(() {
      _paired = paired; // TODO: Place in persistent storage?
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                  child: _paired
                      ? Messaging(_wavesharkBluetooth)
                      : BluetoothPair(
                          getPaired: getPaired, setPaired: setPaired, setWavesharkBluetooth: setWavesharkBluetooth))
            ]),
      ),
    );
  }
}
