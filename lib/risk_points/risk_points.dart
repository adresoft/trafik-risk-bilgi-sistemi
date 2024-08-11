import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:traffic_risk_information_system/risk_points/risk_point.dart';

Set<RiskPoint> riskPoints = {};

Future<void> fetchRiskPoints() async {
  final url = 'https://www.adresoft.com/api/risk_points.json'; // Sağlanan URL

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Yanıtın JSON formatında olup olmadığını kontrol et
      if (response.body.startsWith('{') || response.body.startsWith('[')) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        for (var item in jsonData) {
          try {
            riskPoints.add(RiskPoint.fromJson(item));
            print('RiskPoint eklendi: $item');
          } catch (e) {
            print('RiskPoint nesnesi oluşturulurken hata oluştu: $e');
          }
        }
      } else {
        print('Beklenen JSON formatında değil: ${response.body}');
      }
    } else {
      print('API çağrısı başarısız oldu: ${response.statusCode}');
    }
  } catch (e) {
    print('Bir hata oluştu: $e');
  }
}
