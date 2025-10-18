import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  static initMessaging() async {
    String token = await firebaseMessaging.getToken() ?? '-';
    print("token: $token");

    FirebaseMessaging.onMessage.listen(_onMessage);
  }

  // Obtener info cuando el app esta abierto
  static _onMessage(RemoteMessage message) {
    print("*******************************");
    print(message.notification);
    print(message.notification!.title);
    print(message.notification!.body);
    print("*******************************");
  }
}
