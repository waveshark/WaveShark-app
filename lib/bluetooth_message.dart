class ChatClientMessage extends ClientMessageBase {
  static final String messageName = "CHAT";
  
  String text;

  ChatClientMessage(this.text);

  String toString() {
    return "[ClientMessageBase]<$text>";
  }
}

class DownloadClientMessage extends ClientMessageBase {
  static final String messageName = "DL";

  String blob;
  int blobIndex;
  int totalBlobs;

  DownloadClientMessage(raw) {
    var parts = raw.split(",");
    var index = parts[0];
    var total = parts[1];
    var blob = raw.substring(index.length + 1 + total.length + 1);
    
    this.blob = blob;
    this.blobIndex = index;
    this.totalBlobs = total;
  }

  String toString() {
    return "[DownloadClientMessage $blobIndex of $totalBlobs]";
  }
}

String serializeMessageName(String messageName) {
  return "[$messageName]";
}

String extractMessageBody(String serializedMessage) {
  return serializedMessage.substring(serializedMessage.indexOf(']') + 1);
}

abstract class ClientMessageBase {
  static final String messageName = null;

  static ClientMessageBase fromTransport(String text) {
    var body = extractMessageBody(text);
    if (text.startsWith(serializeMessageName(ChatClientMessage.messageName))) {
      return ChatClientMessage(body);
    }
    if (text.startsWith(serializeMessageName(DownloadClientMessage.messageName))) {
      return DownloadClientMessage(body);
    }
    return null;
  }
}