import 'dart:typed_data';

import 'package:entao_hare/harewidget/harewidget.dart';
import 'package:entao_log/entao_log.dart';
import 'package:web_socket/web_socket.dart';

typedef OnWebSocketText = void Function(String text);
typedef OnWebSocketBinary = void Function(Uint8List data);
typedef OnWebSocketClose = void Function(int? code, String reason);
typedef OnWebSocketError = void Function(WebSocketException e);

class HareWebsocket {
  WebSocket? websocket;
  OnWebSocketText? onText;
  OnWebSocketBinary? onBinary;
  OnWebSocketClose? onClose;
  OnWebSocketError? onError;

  HareWebsocket({this.onText, this.onBinary, this.onClose, this.onError});

  bool get isOpen => websocket != null;

  Future<void> connect(Uri uri) async {
    final WebSocket socket = await WebSocket.connect(uri);
    this.websocket = socket;
    socket.events.listen(
      (e) async {
        switch (e) {
          case TextDataReceived(text: final text):
            onText?.call(text);
          case BinaryDataReceived(data: final data):
            onBinary?.call(data);
          case CloseReceived(code: final code, reason: final reason):
            websocket = null;
            onClose?.call(code, reason);
            break;
        }
      },
      onError: (Object e) {
        socket.close();
        websocket = null;
        onError?.call(e as WebSocketException);
      },
      onDone: () {
        websocket = null;
      },
    );
  }

  void close() {
    websocket?.close();
    websocket = null;
  }

  void sendText(String text) {
    websocket?.sendText(text);
  }

  void sendBytes(Uint8List data) {
    websocket?.sendBytes(data);
  }
}

mixin HareWebSocketMixin on HareWidget {
  late HareWebsocket hareWebSocket = HareWebsocket(
    onText: this.onWebsocketText,
    onBinary: this.onWebsocketBinary,
    onClose: this.onWebsocketClose,
    onError: this.onWebsocketError,
  );

  Future<void> websocketConnect(Uri uri) async {
    return await hareWebSocket.connect(uri);
  }

  void onWebsocketText(String text) {}

  void onWebsocketBinary(Uint8List data) {}

  void onWebsocketError(WebSocketException e) {
    loge(e.toString());
  }

  void onWebsocketClose(int? code, String reason) {}

  @override
  void onDestroy() {
    hareWebSocket.close();
    super.onDestroy();
  }
}
