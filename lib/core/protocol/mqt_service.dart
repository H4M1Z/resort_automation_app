import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();

  final MqttServerClient client;
  bool isConnected = false;
  final _reconnectDelay = const Duration(seconds: 3);

  String? username;
  String? password;

  // Private constructor
  MqttService._internal()
      : client = MqttServerClient('broker.hivemq.com', 'flutter_client') {
    client.port = 1833;
    client.keepAlivePeriod = 120;
    client.logging(on: true);
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
  }

  // Factory constructor to provide the singleton instance
  factory MqttService() {
    return _instance;
  }

  static MqttService get instance => _instance;

  Future<void> initialize(String username, String password) async {
    this.username = username;
    this.password = password;
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .authenticateAs(username, password)
        .startClean();
  }

  Future<void> connect() async {
    if (isConnected) {
      log('Already connected to MQTT broker.');
      return;
    }

    try {
      log('Attempting to connect to MQTT broker...');
      await client.connect();
    } catch (e) {
      log('Error connecting to MQTT broker: $e');
      client.disconnect();
      _scheduleReconnect(); // Schedule a reconnect attempt
    }
  }

  int retryCount = 0;
  final maxRetries = 5;

  void _scheduleReconnect() {
    if (retryCount < maxRetries) {
      log('Scheduling reconnect in $_reconnectDelay...');
      retryCount++;
      Future.delayed(_reconnectDelay, () => connect());
    } else {
      log('Max reconnection attempts reached. Giving up.');
    }
  }

  static void _onConnected() {
    log('Successfully connected to the MQTT broker.');
    _instance.isConnected = true;
  }

  static void _onDisconnected() {
    log('Disconnected from the MQTT broker.');
    _instance.isConnected = false;
    // Notify user about the disconnection
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('MQTT disconnected. Reconnecting...')),
      // );
      Fluttertoast.showToast(msg: "MQTT disconnected. Reconnecting...");
    });
    _instance._scheduleReconnect();
  }

  void subscribeToTopic(String topic, BuildContext context) {
    if (isConnected) {
      log('Subscribing to topic: $topic');
      client.subscribe(topic, MqttQos.atLeastOnce);
      client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMessage = c![0].payload as MqttPublishMessage;
        final message = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);
        log('Received message: $message');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Device Update: $message')),
        );
      });
    } else {
      log('Unable to subscribe. Client not connected.');
    }
  }

  void publishMessage(String topic, String message) {
    log("Publishing message");
    if (isConnected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      log('Message published to $topic: $message');
    } else {
      log('Unable to publish message. Client not connected.');
    }
  }
}
