import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class LogOutWidget extends StatefulWidget {
  const LogOutWidget({super.key});

  @override
  State<LogOutWidget> createState() => _LogOutWidgetState();
}

class _LogOutWidgetState extends State<LogOutWidget> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout, color: Colors.red, size:25,),
              const SizedBox(height: 5,),
              Text(
                'Çıkış Yap', // Display the speed as an integer
                style: GoogleFonts.quicksand(

                  fontSize: 10,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
