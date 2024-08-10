import 'package:flutter/material.dart';
import 'package:traffic_risk_information_system/risk_points/risk_points.dart';
import 'package:traffic_risk_information_system/splash_screen.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await fetchRiskPoints();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trafik Risk Bilgi Sistemi',
      home: SplashScreen(),
    );
  }
}

