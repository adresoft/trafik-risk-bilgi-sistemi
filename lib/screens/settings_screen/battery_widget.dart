import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class BatteryWidget extends StatefulWidget {
  const BatteryWidget({super.key});

  @override
  State<BatteryWidget> createState() => _BatteryWidgetState();
}

class _BatteryWidgetState extends State<BatteryWidget> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;
  BatteryState? _batteryState;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
        _getBatteryLevel(); // Pil durumu değiştiğinde seviyeyi güncelle
      });
    });
  }

  Future<void> _getBatteryLevel() async {
    try {
      final int level = await _battery.batteryLevel;
      setState(() {
        _batteryLevel = level;
      });
    } catch (e) {
      print('Pil seviyesi alınırken bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    IconData batteryIcon;
    Color batteryColor;

    if (_batteryLevel <= 20) {
      batteryIcon = Icons.battery_alert;
      batteryColor = Colors.red;
    } else if (_batteryLevel <= 40) {
      batteryIcon = Icons.battery_2_bar_sharp;
      batteryColor = Colors.orange;
    } else if (_batteryLevel <= 60) {
      batteryIcon = Icons.battery_4_bar_outlined;
      batteryColor = Colors.white;
    } else {
      batteryIcon = Icons.battery_charging_full;
      batteryColor = Colors.green;
    }

    return Container(
      width: 90,
      height: 90,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: const Color(0xFF1a1a1a),
      ),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 10,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                batteryIcon,
                size: 30,
                color: batteryColor,
              ),
              Text(
                '$_batteryLevel%',
                style: GoogleFonts.quicksand(
                  fontSize: 10,
                  color: batteryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}