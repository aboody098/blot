import 'dart:async';
import 'dart:convert';

import 'package:fire_safety_console/core/constants.dart';
import 'package:fire_safety_console/core/env.dart';
import 'package:fire_safety_console/core/logger.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

typedef WebSocketMessageHandler = Function(Map<String, dynamic>);

class WebSocketService extends GetxService {
  WebSocketChannel? _channel;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  bool _isManualClose = false;

  final RxBool isConnected = false.obs;
  final RxBool isReconnecting = false.obs;

  final Map<String, List<WebSocketMessageHandler>> _handlers = {};

  @override
  Future<WebSocketService> onInit() async {
    super.onInit();
    await connect();
    return this;
  }

  Future<void> connect() async {
    if (_channel != null) {
      Logger.warning('WebSocket already connected', tag: 'WebSocketService');
      return;
    }

    try {
      Logger.info('Connecting to WebSocket...', tag: 'WebSocketService');
      _channel = WebSocketChannel.connect(Uri.parse(Env.wsEndpoint));

      // Wait for connection to establish
      _channel!.sink.done.catchError((error) {
        Logger.error('WebSocket connection error', tag: 'WebSocketService',
            exception: error);
        _handleDisconnect();
      });

      _startListening();
      _startHeartbeat();
      isConnected.value = true;
      isReconnecting.value = false;
      _isManualClose = false;

      Logger.info('WebSocket connected', tag: 'WebSocketService');
    } catch (e) {
      Logger.error('Failed to connect to WebSocket', tag: 'WebSocketService',
          exception: e);
      _handleDisconnect();
    }
  }

  void _startListening() {
    _channel?.stream.listen(
      (message) {
        try {
          final Map<String, dynamic> data = jsonDecode(message);
          _handleMessage(data);
        } catch (e) {
          Logger.error('Failed to parse WebSocket message',
              tag: 'WebSocketService', exception: e);
        }
      },
      onError: (error) {
        Logger.error('WebSocket stream error', tag: 'WebSocketService',
            exception: error);
        _handleDisconnect();
      },
      onDone: () {
        Logger.info('WebSocket stream closed', tag: 'WebSocketService');
        _handleDisconnect();
      },
    );
  }

  void _handleMessage(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    final payload = data['payload'] as Map<String, dynamic>?;

    if (type == null || payload == null) {
      Logger.warning('Invalid message format', tag: 'WebSocketService');
      return;
    }

    Logger.debug('WebSocket message: $type', tag: 'WebSocketService');

    // Call all handlers for this message type
    final handlers = _handlers[type] ?? [];
    for (final handler in handlers) {
      try {
        handler(payload);
      } catch (e) {
        Logger.error('Error in message handler', tag: 'WebSocketService',
            exception: e);
      }
    }
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer =
        Timer.periodic(Constants.wsHeartbeatInterval, (timer) {
      try {
        send({'type': 'ping'});
      } catch (e) {
        Logger.debug('Failed to send heartbeat', tag: 'WebSocketService');
      }
    });
  }

  void _handleDisconnect() {
    isConnected.value = false;
    _heartbeatTimer?.cancel();
    _channel = null;

    if (!_isManualClose) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    isReconnecting.value = true;
    _reconnectTimer?.cancel();
    _reconnectTimer =
        Timer(Constants.wsReconnectInterval, () {
      Logger.info('Attempting to reconnect...', tag: 'WebSocketService');
      connect();
    });
  }

  void send(Map<String, dynamic> message) {
    if (_channel == null) {
      Logger.warning('WebSocket not connected, cannot send message',
          tag: 'WebSocketService');
      return;
    }

    try {
      _channel!.sink.add(jsonEncode(message));
    } catch (e) {
      Logger.error('Failed to send WebSocket message',
          tag: 'WebSocketService', exception: e);
    }
  }

  void on(String messageType, WebSocketMessageHandler handler) {
    _handlers.putIfAbsent(messageType, () => []).add(handler);
    Logger.debug('Handler registered for $messageType', tag: 'WebSocketService');
  }

  void off(String messageType, WebSocketMessageHandler handler) {
    _handlers[messageType]?.remove(handler);
  }

  @override
  void onClose() {
    _isManualClose = true;
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    super.onClose();
  }
}
