import "package:flutter/material.dart";

import "package:flutter_blue/flutter_blue.dart";
import "dart:convert";
import "dart:async";

const String BLE_CHUNK_EOM = "<<<<<EOM>>>>>";
const int BLE_CHUNK_SIZE = 20;
const int BLE_DELAY_BETWEEN_CHUNKS_MILLIS = 100;

bool hasNewMessage = false;

class Messaging extends StatefulWidget {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;
  List<String> _messages = new List<String>();
  String _currentMessage = "";

  void setBluetoothDevice(bluetoothDevice) {
    _bluetoothDevice = bluetoothDevice;
  }

  void setReadCharacteristic(readCharacteristic) {
    _readCharacteristic = readCharacteristic;
  }

  void setWriteCharacteristic(writeCharacteristic) {
    _writeCharacteristic = writeCharacteristic;
  }

  void subscribeToNotifications() async {
    // Get notifications on server value changes
    await _readCharacteristic.setNotifyValue(true);
    _readCharacteristic.value.listen((event) {
      var chunk = String.fromCharCodes(event.toList());
      print("Chunk received from BLE server [" + chunk + "]");

      if (chunk == BLE_CHUNK_EOM) {
        _currentMessage = _currentMessage.replaceFirst(RegExp(r'>'), '> ');
        _messages.add(_currentMessage);
        hasNewMessage = true;
        print("Message received from BLE server [" + _currentMessage + "]");
        _currentMessage = "";
      } else {
        _currentMessage = _currentMessage + chunk;
      }
    });
  }

  @override
  MessagingState createState() => MessagingState(
      _bluetoothDevice, _readCharacteristic, _writeCharacteristic, _messages);
}

class MessagingState extends State<Messaging> {
  BluetoothDevice _bluetoothDevice;
  BluetoothCharacteristic _readCharacteristic;
  BluetoothCharacteristic _writeCharacteristic;
  List<String> _messages;
  String _currentMessage;

  final textController = TextEditingController();
  final scrollController = ScrollController();

  MessagingState(
      bluetoothDevice, readCharacteristic, writeCharacteristic, messages) {
    _bluetoothDevice = bluetoothDevice;
    _readCharacteristic = readCharacteristic;
    _writeCharacteristic = writeCharacteristic;
    _messages = messages;

    for (var i = 0; i < 100; i++) {
      _messages.add("A");
    }

    // TODO: Terrible hack, use something like an Observable List?
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      // var n = _messages.length;
      // _messages.add("Test " + n.toString());

      setState(() {
        _messages;
        scrollController.position.maxScrollExtent;
      });

      if (hasNewMessage) {
        setState(() {
          scrollController.jumpTo(scrollController.position.maxScrollExtent + 100); // TODO: "+ 100" hack
        });
        hasNewMessage = false;
      }
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
      var endIndex = startIndex + BLE_CHUNK_SIZE;
      if (endIndex >= message.length) endIndex = message.length;

      // Create the chunk
      var chunk = message.substring(startIndex, endIndex);

      // Send chunk to BLE server
      await _writeCharacteristic.write(utf8.encode(chunk));
      await Future.delayed(
          Duration(milliseconds: BLE_DELAY_BETWEEN_CHUNKS_MILLIS));
    }

    // Send EOM chunk to BLE server
    await _writeCharacteristic.write(utf8.encode(BLE_CHUNK_EOM));
    await Future.delayed(
        Duration(milliseconds: BLE_DELAY_BETWEEN_CHUNKS_MILLIS));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
          Container(
              height: 400,
              child: new ListView.builder(
                  controller: scrollController,
                  itemCount: _messages.length,
                  itemBuilder: (BuildContext ctxt, int i) {
                    return new Text(_messages[i]);
                  })),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: TextField(
                controller: textController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 2,
                onChanged: (text) {
                  if (text.contains("\n")) sendMessage();
                },
                decoration: InputDecoration(
                  hintText: "Enter your message",
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                )),
          ),
        ]));
  }
}
