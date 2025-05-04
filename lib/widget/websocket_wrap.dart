part of '../entao_hare.dart';

class WebSocketWrapper {
  WebSocketChannel? channel;
  String? url;
  void Function(String message)? onMessage;

  WebSocketWrapper();

  void connect() {
    String? url = this.url;
    if (url == null) return;

    WebSocketChannel ch = WebSocketChannel.connect(Uri.parse(url));
    channel = ch;
    ch.stream.forEach((element) {
      println("WS RECV: ", element);
      onMessage?.call(element.toString());
    });
  }

  void send(String message) {
    channel?.sink.add(message);
  }

  void close() {
    channel?.sink.close();
    channel = null;
  }
}

mixin WebSocketMixin on HareWidget {
  WebSocketWrapper webSocket = WebSocketWrapper();

  @override
  void onCreate() {
    super.onCreate();
    webSocket.onMessage = onParseWebSocketMessage;
    webSocket.connect();
  }

  void onParseWebSocketMessage(String msg) {
    JsonValue jv = JsonValue.parse(msg);
    if (jv.isList || jv.isMap) {
      onWebSocketJson(jv);
    } else {
      onWebSocketMessage(msg);
    }
  }

  void onWebSocketMessage(String msg) {}

  void onWebSocketJson(JsonValue jvalue) {
    dynamic map = jvalue.value;
    if (map is Map) {
      if (map.length == 1) onWebSocketKeyValue(map.keys.first as String, JsonValue(map.values.first));
    }
  }

  void onWebSocketKeyValue(String key, JsonValue jvalue) {}

  @override
  void onDestroy() {
    webSocket.close();
    super.onDestroy();
  }
}
