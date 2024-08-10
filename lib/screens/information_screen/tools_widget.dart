import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
String tool = "Karayolları";
class ToolsWidget extends StatefulWidget {


  const ToolsWidget({super.key,});
  @override
  State<ToolsWidget> createState() => _ToolsWidgetState();
}

class _ToolsWidgetState extends State<ToolsWidget> {


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
          child: InkWell(
            onTap: () {
              setState(() {
                if(tool == "Karayolları"){
                  tool = "Demiryolları";
                } else if (tool == "Demiryolları") {
                  tool = "Havayolları";
                } else if (tool == "Havayolları") {
                  tool = "Denizyolları";
                } else {
                  tool = "Karayolları";
                }
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tool == "Demiryolları" ? Icons.train : tool == "Havayolları" ? Icons.airplanemode_active : tool == "Denizyolları" ? Icons.directions_boat : Icons.directions_car, color: Colors.white, size:25,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
