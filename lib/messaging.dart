import "package:flutter/material.dart";

import "package:flutter_blue/flutter_blue.dart";
import "dart:convert";
import "dart:async";

const String BLE_CHUNK_EOM = "<<<<<EOM>>>>>";
const int BLE_CHUNK_SIZE = 20;
const int BLE_DELAY_BETWEEN_CHUNKS_MILLIS = 100;

class Messaging extends StatefulWidget {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;
  List<String> _messages = new List<String>();
  String _currentMessage = "";

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
      var chunk = String.fromCharCodes(event.toList());
      print("Chunk received from BLE server [" + chunk + "]");

      if (chunk == BLE_CHUNK_EOM) {
        _messages.add(_currentMessage);
        print("Message received from BLE server [" + _currentMessage + "]");
        _currentMessage = "";
      }
      else {
        _currentMessage = _currentMessage + chunk;
      }
    });
  }

  @override
  MessagingState createState() =>
      MessagingState(_bluetoothDevice, _readCharacteristic, _writeCharacteristic, _messages);
}

class MessagingState extends State<Messaging> {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;
  List<String> _messages;
  String _currentMessage;

  final textController = TextEditingController();

  MessagingState(bluetoothDevice, readCharacteristic, writeCharacteristic, messages)
  {
    _bluetoothDevice = bluetoothDevice;
    _readCharacteristic = readCharacteristic;
    _writeCharacteristic = writeCharacteristic;
    _messages = messages;

    // TODO: Terrible hack, use something like an Observable List?
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_messages.length > 10) {
        _messages.removeAt(0);
      }

      setState(() {
        _messages;
      });
    });
  }

  void sendMessage() async {
    // No message to send?
    if (textController.text == null || textController.text == "") {
      return;
    }

    var message = textController.text.replaceAll("\n", "");
    textController.clear();

    // Send BLE message in chunks
    var numChunks = message.length ~/ BLE_CHUNK_SIZE + 1;
    for (var chunkNum = 0; chunkNum < numChunks; chunkNum++) {
      // Chunk range
      var startIndex = chunkNum * BLE_CHUNK_SIZE;
      var endIndex   = startIndex + BLE_CHUNK_SIZE;
      if (endIndex >= message.length) endIndex = message.length;

      // Create the chunk
      var chunk = message.substring(startIndex, endIndex);

      // Send chunk to BLE server
      await _writeCharacteristic.write(utf8.encode(chunk));
      await Future.delayed(Duration(milliseconds: BLE_DELAY_BETWEEN_CHUNKS_MILLIS));
    }

    // Send EOM chunk to BLE server
    await _writeCharacteristic.write(utf8.encode(BLE_CHUNK_EOM));
    await Future.delayed(Duration(milliseconds: BLE_DELAY_BETWEEN_CHUNKS_MILLIS));
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ..._messages.map((message) {
        return Text(message);
      }),
      TextField(
        controller: textController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 2,
        onChanged: (text) { if (text.contains("\n")) sendMessage(); },
        decoration: InputDecoration(
          hintText: "Enter your message"
        )
      ),
      FlatButton(
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: sendMessage,
        child: Text("Send")
      )
    ]);
  }
}