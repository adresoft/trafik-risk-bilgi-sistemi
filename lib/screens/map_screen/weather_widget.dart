import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traffic_risk_information_system/screens/map_screen/maps.dart';
import 'package:traffic_risk_information_system/services/gps.dart';


class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String address = "...";

  @override
  void initState() {
    super.initState();
    _performReverseGeocoding();
  }

  Future<void> _performReverseGeocoding() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(locationService.altitude!, locationService.longitude!);
      if (placemarks.isNotEmpty) {
        setState(() {
          address = '${placemarks.first.street}/${placemarks.first.subAdministrativeArea}';
        });
      } else {
        setState(() {
          address = "Adres bulunamadı!";
        });
      }
    } catch (e) {
      setState(() {
        address = "$e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 200,
        height: 50,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Text(address, style: GoogleFonts.quicksand(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15,),
            overflow: TextOverflow.ellipsis,),
        ),
    );
  }
}
