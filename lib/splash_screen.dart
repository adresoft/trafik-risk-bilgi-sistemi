import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traffic_risk_information_system/screens/application.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const Application()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
             height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: Colors.white
                    ),
                    child: Icon(Icons.traffic_rounded, color: Colors.black, size: 50,),
                  ),
                  const SizedBox(height: 20,),
                  Text("Trafik Risk Bilgi Sistemi", style: GoogleFonts.quicksand(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),)
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
