import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traffic_risk_information_system/screens/information_screen/information.dart';
import 'package:traffic_risk_information_system/screens/map_screen/maps.dart';
import 'package:traffic_risk_information_system/screens/profil_screen/profil.dart';
import 'package:traffic_risk_information_system/screens/settings_screen/settings.dart';
import 'package:traffic_risk_information_system/screens/settings_screen/battery_widget.dart';
import 'package:traffic_risk_information_system/screens/map_screen/speedometer_widget.dart';
import 'package:traffic_risk_information_system/screens/profil_screen/log_out_widget.dart';
import 'package:traffic_risk_information_system/screens/information_screen/tools_widget.dart';
class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  int _selectedIndex = 0;


  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Durum çubuğunun rengini ve ikon renklerini ayarlıyoruz
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    final List<Widget> _widgetOptions = <Widget>[
      MapScreen(),
      Settings(),
      Information(),
      Profile(),
    ];

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.1),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.black,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.location_on, color: Colors.white),
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: Icon(Icons.settings, color: Colors.white),
                onPressed: () => _onItemTapped(1),
              ),
              SizedBox(width: 150),
              IconButton(
                icon: Icon(Icons.info, color: Colors.white),
                onPressed: () => _onItemTapped(2),
              ),
              IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => _onItemTapped(3),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _selectedIndex == 0
          ? SpeedometerWidget()
          : _selectedIndex == 1
          ? BatteryWidget()
          : _selectedIndex == 3
          ? LogOutWidget()
          : ToolsWidget(),
    );
  }
}