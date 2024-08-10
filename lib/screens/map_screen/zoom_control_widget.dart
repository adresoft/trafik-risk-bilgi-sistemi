import 'package:flutter/material.dart';
import 'package:traffic_risk_information_system/screens/map_screen/google_maps_view.dart';

class ZoomControlWidget extends StatelessWidget {

  ZoomControlWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 100,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: InkWell(onTap: zoomIn,child: Icon(Icons.add, color: Colors.white,))),
          const Divider(height: 5, color: Colors.white,),
          Expanded(child: InkWell(onTap: zoomOut,child: Icon(Icons.remove, color: Colors.white,)))
        ],
      ),
    );
  }
}
