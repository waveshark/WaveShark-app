import "package:flutter/material.dart";

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
  BluetoothPair _bluetoothPair;

  _MyHomePageState() {
    _messaging = Messaging();
    _bluetoothPair = BluetoothPair(getMessaging, setPaired);
  }

  Messaging getMessaging() {
    return _messaging;
  }

  void setPaired(paired) {
    setState(() {
      _paired = paired;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Column(children: <Widget>[
                  Visibility(visible: !_paired, child: _bluetoothPair),
                  Visibility(visible: _paired, child: _messaging)
                ]))));
  }
}
