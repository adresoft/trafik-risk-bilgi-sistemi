import 'package:flutter/material.dart';
import 'package:traffic_risk_information_system/services/weather_service.dart';
import 'package:traffic_risk_information_system/services/gps.dart';

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  String weatherText = 'Hava durumu yükleniyor...';
  WeatherService weatherService = WeatherService();
  IconData weatherIcon = Icons.help; // Varsayılan ikon
  IconData precipitationIcon = Icons.opacity; // Yağış ikonu
  IconData visibilityIcon = Icons.visibility; // Görüş mesafesi ikonu

  double? precipitation;
  double? visibility;

  @override
  void initState() {
    super.initState();
    _updateWeather();
    // Konum güncellemesi için dinleyici ekleyin
    locationService.getPositionStream().listen((position) {
      _updateWeather();
    });
  }

  Future<void> _updateWeather() async {
    if (locationService.latitude != null && locationService.longitude != null) {
      try {
        final weatherData = await weatherService.getCurrentWeather(
          locationService.latitude!,
          locationService.longitude!,
        );

        // İstenilen verileri çekiyoruz
        final temperature = weatherData['current']['temp_c'];
        final condition = weatherData['current']['condition']['text'];
        precipitation = weatherData['current']['precip_mm'];
        visibility = weatherData['current']['vis_km'];

        // Hava durumu ikonunu belirleyin
        IconData icon;
        if (condition.contains('Sunny') || condition.contains('Clear')) {
          icon = Icons.sunny;
        } else if (condition.contains('Cloudy')) {
          icon = Icons.cloud;
        } else if (condition.contains('Rain')) {
          icon = Icons.water_drop;
        } else if (condition.contains('Snow')) {
          icon = Icons.ac_unit;
        } else {
          icon = Icons.help;
        }

        setState(() {
          weatherText = 'Sıcaklık: $temperature°C\n'
              'Yağış: ${precipitation ?? 0}mm\n'
              'Görüş Mesafesi: ${visibility ?? 0}km';
          weatherIcon = icon;
        });
      } catch (e) {
        setState(() {
          weatherText = 'Hava durumu alınamadı';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 100,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Hava durumu ikonu
          Icon(weatherIcon, color: Colors.white, size: 40),
          SizedBox(width: 10),
          // Hava durumu bilgileri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  weatherText,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Row(
                  children: [
                    // Yağış ikonu ve bilgisi
                    Icon(precipitationIcon, color: Colors.white, size: 20),
                    SizedBox(width: 5),
                    Text(
                      '${precipitation ?? 0}mm',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(width: 10),
                    // Görüş mesafesi ikonu ve bilgisi
                    Icon(visibilityIcon, color: Colors.white, size: 20),
                    SizedBox(width: 5),
                    Text(
                      '${visibility ?? 0}km',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}