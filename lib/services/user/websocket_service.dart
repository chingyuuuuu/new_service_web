import 'package:socket_io_client/socket_io_client.dart' as IO;

class WebSocketService {
  IO.Socket? _socket; // 使用可空類型避免 LateInitializationError
  bool _isInitialized = false; // 用於追蹤是否已初始化

  // 單例模式
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;
  WebSocketService._internal();

  // 初始化 WebSocket
  void connect(String websocketUrl) {
    if (_isInitialized && _socket != null && _socket!.connected) {
      print("WebSocket 已經連接，無需重新連接");
      return;
    }

    _socket = IO.io(websocketUrl, <String, dynamic>{
      'transports': ['websocket'], // 僅使用 WebSocket 傳輸
      'autoConnect': false,
    });

    _socket!.on('connect', (_) {
      print('WebSocket 已連接');
      _isInitialized = true;
    });

    _socket!.on('disconnect', (_) {
      print('WebSocket 已斷開');
      _isInitialized = false;
    });

    _socket!.connect();
  }

  // 發送消息
  void emit(String event, dynamic data) {
    if (_socket == null || !_isInitialized || !_socket!.connected) {
      print('WebSocket 未連接，無法發送消息');
      return;
    }
    _socket!.emit(event, data);
  }

  // 註冊事件監聽器
  void on(String event, Function(dynamic) callback) {
    if (_socket == null || !_isInitialized) {
      print('WebSocket 未連接，無法註冊事件 $event');
      return;
    }
    _socket!.on(event, callback);
  }

  // 斷開連接
  void disconnect() {
    if (_socket != null && _socket!.connected) {
      _socket!.disconnect();
      _isInitialized = false;
      print('WebSocket 已斷開連接');
    }
  }
}
