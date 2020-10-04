import "package:flutter/material.dart";
import 'package:waveshark/waveshark_bluetooth.dart';
// import "package:waveshark/waveshark_bluetooth.dart"

class Messaging extends StatelessWidget {
  final WavesharkBluetooth wavesharkBluetooth;

  Messaging({this.wavesharkBluetooth});

  @override
  Widget build(BuildContext context) {
    return Text("TODO: Send/receive messages");
  }
}