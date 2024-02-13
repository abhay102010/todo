import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(apiKey: "AIzaSyCDM8PGZqJjNOZRqg4aKjXyLaFRjBzQw_k", appId: "1:1018225180217:android:578952c94b3c4403de17e8", messagingSenderId: "1018225180217", projectId: "saarthi-8049b")
  );
  await Hive.initFlutter();
  var box = await Hive.openBox('lwp');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
