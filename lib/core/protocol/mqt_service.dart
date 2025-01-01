import 'dart:async';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:home_automation_app/main.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();

  final MqttServerClient client;
  bool isConnected = false;
  final Duration _reconnectDelay = const Duration(seconds: 3);

  String? username;
  String? password;
  int retryCount = 0;
  final int maxRetries = 5;

  MqttService._internal()
      : client = MqttServerClient('test.mosquitto.org',
            'flutter_client_${DateTime.now().millisecondsSinceEpoch}') {
    client.port = 1883;
    client.keepAlivePeriod = 30;
    client.logging(on: true);
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
  }

  factory MqttService() => _instance;

  Future<void> initialize(String username, String password) async {
    this.username = username;
    this.password = password;
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(
            'flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .authenticateAs(username, password);
  }

  Future<void> connect() async {
    if (isConnected) {
      log('Already connected to MQTT broker.');
      return;
    }

    try {
      log('Attempting to connect to MQTT broker...');
      final connectionFuture = client.connect();
      await connectionFuture.timeout(Duration(seconds: 10), onTimeout: () {
        throw TimeoutException('Connection timed out.');
      });
    } catch (e) {
      log('Error connecting to MQTT broker: $e');
      client.disconnect();
      _scheduleReconnect();
    }
  }

  bool reconnecting = false;
  void _scheduleReconnect() {
    if (reconnecting || retryCount >= maxRetries) return;
    reconnecting = true;

    retryCount++;
    Future.delayed(_reconnectDelay, () async {
      reconnecting = false;
      await connect();
    });
  }

  void _onConnected() {
    log('Successfully connected to the MQTT broker.');
    isConnected = true;
    retryCount = 0;

    // Re-subscribe to topics after successful reconnection
    final userId = globalUserId; // Replace with dynamic user ID
    final topic = 'user/$userId/device/+/status'; // Example topic
    subscribeToTopic(topic);
  }

  void _onDisconnected() {
    log('Disconnected from the MQTT broker.');
    isConnected = false;

    if (client.connectionStatus?.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      log('Disconnection was requested by the client.');
    } else {
      Fluttertoast.showToast(
          msg: 'MQTT disconnected unexpectedly. Reconnecting...');
      _scheduleReconnect();
    }
  }

  void subscribeToTopic(String topic) {
    if (!isConnected) {
      log('Unable to subscribe. Client not connected.');
      return;
    }

    log('Subscribing to topic: $topic');
    client.subscribe(topic, MqttQos.exactlyOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      if (c == null || c.isEmpty) return;

      try {
        final recMessage = c[0].payload as MqttPublishMessage;
        final message = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);
        log('Received message on topic ${c[0].topic}: $message');
        Fluttertoast.showToast(msg: 'Device Update: $message');
      } catch (e) {
        log('Error processing received message: $e');
      }
    });
  }

  void publishMessage(String topic, String message) {
    if (!isConnected) {
      Fluttertoast.showToast(msg: 'MQTT is not connected. Cannot publish.');
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    log('Message published to $topic: $message');
  }
}
