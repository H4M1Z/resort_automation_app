class MqttService {
  final client = MqttServerClient('broker.hivemq.com', 'flutter_client');

  Future<void> connect() async {
    client.port = 1883; // Default MQTT port
    client.keepAlivePeriod = 20; // Keep the connection alive
    client.logging(on: true);
    client.onDisconnected = onDisconnected;

    try {
      await client.connect();
      print('Connected to MQTT broker!');
    } catch (e) {
      print('Error connecting to MQTT broker: $e');
      client.disconnect();
    }
  }

  void onDisconnected() {
    print('Disconnected from the MQTT broker.');
  }

  void subscribeToTopic(String topic) {
    client.subscribe(topic, MqttQos.atLeastOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMessage = c![0].payload as MqttPublishMessage;
      final message =
          MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
      print('Received message: $message');
    });
  }

  void publishMessage(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
}
