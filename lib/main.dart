import 'dart:convert';
import 'package:address/screens/addresses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;
// import 'package:firebase_analytics/firebase_analytics.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  final fcm = FirebaseMessaging.instance;
  fcm.requestPermission();

  final fcmToken = await fcm.getToken();

  final baseUrl = dotenv.get('BASE_URL');
  final url = Uri.parse('$baseUrl/device-id');
  final body = json.encode({'registrationToken': fcmToken});

  final response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: body);

  print(fcmToken);

  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: MaterialApp(
        title: 'Address',
        theme: ThemeData().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff00ADB5),
          ),
        ),
        home: const AddressScreen(),
      ),
    );
  }
}
