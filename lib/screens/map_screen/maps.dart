import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_risk_information_system/screens/map_screen/google_maps_view.dart';
import 'package:traffic_risk_information_system/services/gps.dart';
import 'package:traffic_risk_information_system/screens/map_screen/button_widget.dart';
import 'package:traffic_risk_information_system/screens/map_screen/speedometer_widget.dart';
import 'package:traffic_risk_information_system/screens/map_screen/weather_widget.dart';
import 'package:traffic_risk_information_system/screens/map_screen/zoom_control_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const GoogleMapsView(),
            ),
            const Align(
              alignment: Alignment.topCenter,
              child: WeatherWidget(),
            ),
             Align(
              alignment: Alignment.topRight,
              child: IgnorePointer(ignoring: true,child: ButtonWidget(icon: Icons.navigation,)),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: ButtonWidget(icon: Icons.directions_car)
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: ButtonWidget(icon: Icons.message)
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ZoomControlWidget(),
            ),
          ],
        ),
      ),
    );
  }

}

