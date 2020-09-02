import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'confirmed_screen.dart';
import 'recovered_screen.dart';
import 'deaths_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColorBrightness: Brightness.light
      ),
      initialRoute: DashboardScreen.id,
      routes: {
        DashboardScreen.id: (context) => DashboardScreen(),
        ConfirmedScreen.id: (context) => ConfirmedScreen(),
        DeathsScreen.id: (context) => DeathsScreen(),
        RecoveredScreen.id: (context) => RecoveredScreen()
      },
    );
  }
}