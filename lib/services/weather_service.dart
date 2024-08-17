import 'dart:convert';
import 'package:http/http.dart' as http;

// WeatherAPI'den API anahtarınızı buraya ekleyin
const String apiKey = '7e9b2889bdec4db68b5100418241708'; // Kendi API anahtarınızı buraya ekleyin

class WeatherService {
  final String baseUrl = 'http://api.weatherapi.com/v1';

  Future<Map<String, dynamic>> getCurrentWeather(double latitude, double longitude) async {
    final url = Uri.parse('$baseUrl/current.json?key=$apiKey&q=$latitude,$longitude');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Hava durumu verileri alınırken hata oluştu');
    }
  }
}