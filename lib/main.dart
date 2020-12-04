import 'dart:io';
import "package:flutter/material.dart";
import 'package:flutter/services.dart' show rootBundle;

import "package:waveshark/htportal.dart";
import "package:waveshark/messaging.dart";
import "package:waveshark/bluetooth_pair.dart";

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
  bool _paired = false;
  Messaging _messaging;
  HypertextPortal _htportal;
  BluetoothPair _bluetoothPair;

  _MyHomePageState()
  {
    _messaging = Messaging();
    _bluetoothPair = BluetoothPair(getMessaging, setPaired);
    _htportal = HypertextPortal();
  }

  Messaging getMessaging()
  {
    return _messaging;
  }

  void setPaired(paired)
  {
    setState(() {
      _paired = paired;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (true) {
      body = _htportal;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: body
    );
  }
}
