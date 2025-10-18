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

  // Obtener info cuando el app esta abierto
  static _onMessage(RemoteMessage message) {
    print("*******************************");
    print(message.notification);
    print(message.notification!.title);
    print(message.notification!.body);
    print("*******************************");
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
