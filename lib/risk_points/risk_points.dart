import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:traffic_risk_information_system/risk_points/risk_point.dart';

Set<RiskPoint> riskPoints = {};

Future<void> fetchRiskPoints() async {
  final url = 'https://www.adresoft.com/api/risk_points.json'; // Sağlanan URL

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Yanıtı UTF-8 olarak çözümleyin
      final data = utf8.decode(response.bodyBytes);

      // Yanıtın JSON formatında olup olmadığını kontrol et
      if (data.startsWith('{') || data.startsWith('[')) {
        final List<dynamic> jsonData = jsonDecode(data);

        for (var item in jsonData) {
          try {
            riskPoints.add(RiskPoint.fromJson(item));
          } catch (e) {
            print('RiskPoint nesnesi oluşturulurken hata oluştu: $e');
          }
        }
      } else {
        print('Beklenen JSON formatında değil: $data');
      }
    } else {
      print('API çağrısı başarısız oldu: ${response.statusCode}');
    }
  } catch (e) {
    print('Bir hata oluştu: $e');
  }
}