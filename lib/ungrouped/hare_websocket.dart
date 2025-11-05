import 'dart:typed_data';

import 'package:entao_hare/harewidget/harewidget.dart';
import 'package:web_socket/web_socket.dart' as ws;

typedef OnWebSocketText = void Function(String text);
typedef OnWebSocketBinary = void Function(Uint8List data);
typedef OnWebSocketClose = void Function(int? code, String reason);
typedef OnWebSocketError = void Function(ws.WebSocketException e);

abstract mixin class WsDelegate {
  void onWebSocketText(String text);

  void onWebSocketBinary(Uint8List data) {}

  void onWebSocketClose(int? code, String reason);

  void onWebSocketError(ws.WebSocketException e);
}

class HareWebsocket {
  ws.WebSocket? websocket;
  OnWebSocketText? onText;
  OnWebSocketBinary? onBinary;
  OnWebSocketClose? onClose;
  OnWebSocketError? onError;
  WsDelegate? delegate;

  HareWebsocket({this.delegate, this.onText, this.onBinary, this.onClose, this.onError});

  bool get isOpen => websocket != null;

  Future<void> connect(Uri uri) async {
    final ws.WebSocket socket = await ws.WebSocket.connect(uri);
    this.websocket = socket;
    socket.events.listen(
      (e) async {
        switch (e) {
          case ws.TextDataReceived(text: final text):
            onText?.call(text);
            delegate?.onWebSocketText(text);
          case ws.BinaryDataReceived(data: final data):
            onBinary?.call(data);
            delegate?.onWebSocketBinary(data);
          case ws.CloseReceived(code: final code, reason: final reason):
            websocket = null;
            onClose?.call(code, reason);
            delegate?.onWebSocketClose(code, reason);
            break;
        }
      },
      onError: (Object e) {
        socket.close();
        websocket = null;
        onError?.call(e as ws.WebSocketException);
        delegate?.onWebSocketError(e as ws.WebSocketException);
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

mixin HareWebSocketMixin on HareWidget implements WsDelegate {
  late HareWebsocket hareWebSocket = HareWebsocket(delegate: this);

  Future<void> websocketConnect(Uri uri) async {
    return await hareWebSocket.connect(uri);
  }

  @override
  void onDestroy() {
    hareWebSocket.close();
    super.onDestroy();
  }
}
