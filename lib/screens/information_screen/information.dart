import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:traffic_risk_information_system/screens/information_screen/tools_widget.dart';

class Information extends StatefulWidget {


  const Information({super.key,});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                  leading:Icon(tool == "Demiryolları" ? Icons.train : tool == "Havayolları" ? Icons.airplanemode_active : tool == "Denizyolları" ? Icons.directions_boat : Icons.directions_car, color: Colors.white, size:25,),
                  title: Text(
                    "$tool Risk Noktaları",
                    style: GoogleFonts.quicksand(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  )),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1000),
                      color: Colors.purple.withOpacity(0.3),
                    ),
                    child: Icon(Icons.money_off, color: Colors.purple,),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Mor Risk Noktası", style: GoogleFonts.quicksand(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 20),),
                    Text("Maddi hasarlı kazaların yaşanabileceği olası risk noktaları", style: GoogleFonts.quicksand(color: Colors.white, fontSize: 12),),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
