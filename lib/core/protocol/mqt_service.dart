import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:resort_automation_app/config/service_locator.dart';
import 'package:resort_automation_app/core/Connectivity/connectvity_helper.dart';
import 'package:resort_automation_app/core/commom/functions/write_asset_to_file.dart'
    show writeAssetToFile;
import 'package:resort_automation_app/core/services/navigation_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/strings/shared_pref_keys.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();

  final MqttServerClient client;
  bool isConnected = false;
  final Duration _reconnectDelay = const Duration(seconds: 1);

  String? username;
  String? password;
  int retryCount = 0;
  final int maxRetries = 5;

  MqttService._internal()
      : client = MqttServerClient('test.mosquitto.org',
            'flutter_client_${DateTime.now().millisecondsSinceEpoch}') {
    client.port = 8883; // Use the secure port
    client.keepAlivePeriod = 30;
    client.secure = true; // Enable secure connection
    // client.onBadCertificate = (dynamic a) => true;
    // Load the certificates
    Future.wait([
      writeAssetToFile('assets/certificates/mosquitto.org.crt', 'ca.crt'),
      writeAssetToFile('assets/certificates/client.crt', 'client.crt'),
      writeAssetToFile('assets/certificates/client.key', 'client.key'),
    ]).then((filePaths) {
      client.securityContext = SecurityContext.defaultContext
        ..setTrustedCertificates(filePaths[0]) // CA cert
        ..useCertificateChain(filePaths[1]) // Client cert
        ..usePrivateKey(filePaths[2]); // Private key
    });

    client.logging(on: true);
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
  }

  factory MqttService() => _instance;

  // Future<void> initialize(String username, String password) async {
  //   this.username = username;
  //   this.password = password;
  //   client.connectionMessage = MqttConnectMessage()
  //       .withClientIdentifier(
  //           'flutter_client_${DateTime.now().millisecondsSinceEpoch}')
  //       .authenticateAs(username, password);
  // }

  Future<void> connect() async {
    if (isConnected) {
      log('Already connected to MQTT broker.');
      return;
    }

    bool isConnectedToInternet = await ConnectivityHelper.hasInternetConnection(
        NavigationService.navigatorKey.currentState!.context);
    if (!isConnectedToInternet) return;
    try {
      log('Attempting to connect to MQTT broker...');
      final connectionFuture = client.connect();
      await connectionFuture.timeout(const Duration(seconds: 10),
          onTimeout: () {
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

    final sharedPref = serviceLocator.get<SharedPreferences>();
    final roomId = sharedPref.getString(SharedPrefKeys.kUserRoomNo);

    if (roomId != null) {
      // Re-subscribe to topics after successful reconnection

      final topic = 'roomNo/$roomId/device/+/status'; // Example topic

      const topic2 = "roomNo/+/init";

      subscribeToTopic(topic);
      subscribeToTopic(topic2);
    } else {
      log('cannot subscribe to topic qr code not scanned');
    }
  }

  void _onDisconnected() async {
    log('Disconnected from the MQTT broker.');
    isConnected = false;

    if (client.connectionStatus?.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      log('Disconnection was requested by the client.');
    } else {
      Fluttertoast.showToast(
          msg: 'MQTT disconnected unexpectedly. Reconnecting...');
    }

    // Wait for reconnection only when the internet is restored
    bool isConnectedToInternet = await ConnectivityHelper.hasInternetConnection(
        NavigationService.navigatorKey.currentState!.context);
    if (isConnectedToInternet) {
      monitorInternetConnectionAndReconnect();
    }
  }

  void monitorInternetConnectionAndReconnect() {
    log("Monitor Internet Connection and Reconnect Function triggered");
    Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none && !isConnected) {
        log('Internet connection restored. Attempting to reconnect...');
        Fluttertoast.showToast(
          msg: 'Internet restored. Reconnecting to MQTT...',
        );
        connect();
        // // Attempt reconnection
      } else if (result == ConnectivityResult.values) {
        Fluttertoast.showToast(
          msg: 'No internet connection.',
        );
      }
    });
  }

  void subscribeToTopic(String topic) {
    if (!isConnected) {
      log('Unable to subscribe. Client not connected.');
      return;
    }

    log('Subscribing to topic: $topic');
    client.subscribe(topic, MqttQos.exactlyOnce);

    // Add a filtering mechanism for the topic
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      if (c == null || c.isEmpty) return;

      final receivedTopic =
          c[0].topic; // Extract the topic from the received message
      log("Data receiving topic  $receivedTopic");
      // if (receivedTopic != topic) {
      //   return; // Ignore messages for topics other than the current one
      // }

      try {
        final recMessage = c[0].payload as MqttPublishMessage;
        final message = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message);
        log('Received message on topic $receivedTopic: $message');
        // Fluttertoast.showToast(msg: 'Device Update: $message');
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
    // final jsonMessage = jsonEncode(message);
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
    log('Message published to $topic: $message');
  }
}
