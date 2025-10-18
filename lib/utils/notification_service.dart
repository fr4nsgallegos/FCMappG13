import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point') //Permite que el código sea accesible nativamente
class NotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static initMessaging() async {
    String token = await firebaseMessaging.getToken() ?? '-';
    print("token: $token");

    FirebaseMessaging.onMessage.listen(_onMessage);

    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  }

  // Suscribir a topic
  Future<void> suscribeToTopic(String topic) async {
    await firebaseMessaging.subscribeToTopic(topic);
    print("Dispositivo suscrito a el topic: $topic");
  }

  // Obtener info cuando el app esta abierto
  static _onMessage(RemoteMessage message) {
    print("*******************************");
    print(message.notification);
    print(message.notification!.title);
    print(message.notification!.body);
    print("*******************************");

    if (message.data.isNotEmpty) {
      print("/*/*/*/***/*/**/*/*/*/*/*/*/*/*/*/*/");
      print("Datos: ${message.data}");
      print("Data1: ${message.data["data1"]}");
      print("Data2: ${message.data["data2"]}");
      print("/*/*/*/***/*/**/*/*/*/*/*/*/*/*/*/*/");
    }
  }

  // Obtener cuando este en segundo plano
  @pragma('vm:entry-point') //Permite que el código sea accesible nativamente
  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    if (message.notification != null) {
      print("------------------------");
      print(message.notification);
      print(message.notification!.title);
      print(message.notification!.body);
      print("------------------------");
    }
  }
}
