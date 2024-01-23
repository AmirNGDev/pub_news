import 'package:flutter/material.dart';
import 'package:pub_news/routes/home.dart';
import 'package:pub_news/routes/windowsScreen.dart';
import 'dart:io' show Platform;
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows) {
    setWindowMinSize(const Size(1050, 500));
    setWindowTitle('Pub News');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool isAndroid = true;
    if (Platform.isAndroid) {
      isAndroid = true;
    } else if (Platform.isWindows) {
      isAndroid = false;
    }
    return MaterialApp(
      title: 'Pub News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: isAndroid ? const HomeScreen() : const WindowsScreen(),
    );
  }
}
