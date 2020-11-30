import 'package:flutter/material.dart';
import 'package:DevChats/screens/home_screen.dart';
import 'package:DevChats/services/app_initializer.dart';
import 'package:DevChats/services/dependecy_injection.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

Injector injector;

void main() async {
  DependencyInjection().initialise(Injector.getInjector());
  injector = Injector.getInjector();
  await AppInitializer().initialise(injector);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Chats ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Color(0xFFFEF9EB),
      ),
      home: HomeScreen(),
    );
  }
}
