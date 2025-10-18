import 'package:fcmappg13/firebase_options.dart';
import 'package:fcmappg13/pages/home_page.dart';
import 'package:fcmappg13/utils/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initMessaging();
  runApp(MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false));
}
