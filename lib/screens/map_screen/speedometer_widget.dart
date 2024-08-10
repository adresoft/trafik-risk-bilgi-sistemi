import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traffic_risk_information_system/services/gps.dart';


class SpeedometerWidget extends StatefulWidget {
  const SpeedometerWidget({super.key});

  @override
  State<SpeedometerWidget> createState() => _SpeedometerWidgetState();
}

class _SpeedometerWidgetState extends State<SpeedometerWidget> {
  double? _speedInKmPerHour;
  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  void _startTracking() {
    locationService.getPositionStream().listen((Position position) {
      locationService.updateLocation(position);
      setState(() {
        _speedInKmPerHour = locationService.getSpeedInKmPerHour();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: const Color(0xFF1a1a1a),
      ),
      child: Container(
        width: 100, // Diameter of the speedometer
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 10, // Width of the red border
          ),
        ),
        child: Center(
          child: _speedInKmPerHour != null
              ?  Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

                 Text("${_speedInKmPerHour!.toStringAsFixed(0)}",
          style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.white,
          ), ),
              Text(
                'km/s', // Display the speed as an integer
                style: GoogleFonts.quicksand(

                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ) : Container(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(color: Colors.white, )),
        ),
      ),
    );
  }
}
