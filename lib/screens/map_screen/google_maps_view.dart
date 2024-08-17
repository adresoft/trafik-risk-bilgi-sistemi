import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_risk_information_system/risk_points/risk_point.dart';
import 'package:traffic_risk_information_system/risk_points/risk_points.dart';
import 'package:traffic_risk_information_system/screens/settings_screen/settings.dart';
import 'package:traffic_risk_information_system/services/gps.dart';
import 'package:traffic_risk_information_system/screens/map_screen/bottom_sheet.dart';

MapType mapType = MapType.normal;
bool trafficMap = true;
GoogleMapController? _mapController;
double _currentZoomLevel = 10.0; // Varsayılan zoom seviyesi

void zoomIn() {
  _currentZoomLevel++;
  _mapController?.animateCamera(CameraUpdate.zoomTo(_currentZoomLevel));
}

void zoomOut() {
  _currentZoomLevel--;
  _mapController?.animateCamera(CameraUpdate.zoomTo(_currentZoomLevel));
}

class GoogleMapsView extends StatefulWidget {
  const GoogleMapsView({super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  LatLng? _initialPosition;
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _getLocation(); // Uygulama açıldığında konum bilgilerini alır.
    startLocationTracking();
  }


  late StreamSubscription<Position> positionStream;

  void startLocationTracking() {
    LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // Konum doğruluğunu yüksek yapar
      distanceFilter: 10, // 10 metre hareket ettiğinde yeni bir pozisyon alır
    );

    positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      checkProximityToRiskPoints(position);
    });
  }

  void stopLocationTracking() {
    if (positionStream != null) {
      positionStream?.cancel();
    }
  }

  void checkProximityToRiskPoints(Position userPosition) {
    const double thresholdDistance = 250; // 250 metre
    bool isNearRiskPoint = false;

    for (RiskPoint point in riskPoints) {
      double distance = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        point.xKoordinat,
        point.yKoordinat,
      );

      if (distance <= thresholdDistance) {
        isNearRiskPoint = true;
        showRiskAlert(point);
        break; // Birden fazla risk noktasına yaklaşılırsa sadece birini göster
      }
    }
  }

  // Sesli Uyarı *******************************************

  FlutterTts flutterTts = FlutterTts();

  Future<void> speakRiskReason(String reason) async {

    // Dil ayarı
    await flutterTts.setLanguage("tr-TR");

    // Ses perdesi (1.0 normal, 0.5 daha kalın, 2.0 daha ince)
    await flutterTts.setPitch(1.0);

    // Konuşma hızı (1.0 normal hız, 0.5 yavaş, 2.0 hızlı)
    await flutterTts.setSpeechRate(0.7);

    // Ses türü seçimi (erkek sesi için voiceName genellikle 'male' içeren bir değer olur)
    await flutterTts.setVoice({'name': 'tr-TR-x-iol-local', 'locale': 'tr-TR'});

    // Volume ayarı (0.0 sessiz, 1.0 maksimum ses)
    await flutterTts.setVolume(1.0);

    // Metni sesli okuma
    await flutterTts.speak(reason);
    await Future.delayed(const Duration(seconds: 5)); // 5 saniye bekle
    await flutterTts.speak(reason);

  }

  // Risk Uyarısı
  int _riskAlertCount = 0;

  void showRiskAlert(RiskPoint point) {
    if (_riskAlertCount < 1) {
      showDialog(
        context: context,
        barrierDismissible: true, // Arka plana tıklayarak kapatılabilir
        builder: (BuildContext context) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(16.0),
              child: Material(
                color: Colors.black,
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(
                    ' ${point.kazaSekli[0].kazaTipi} RİSKİ',
                    style: GoogleFonts.quicksand(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );

      // Kullanıcıya sesli uyarı ver
      speakRiskReason('${point.kazaSekli[0].kazaTipi} RİSKİ!');

      _riskAlertCount++;
    }
  }


  @override
  void dispose() {
    stopLocationTracking();
    super.dispose();
  }

  void _getLocation() async {
    await locationService.updateCoordinates();
    setState(() {
      _initialPosition = LatLng(
        locationService.latitude ?? 0.0,
        locationService.longitude ?? 0.0,
      );
    });
  }

  void _updateRiskPoints(LatLngBounds bounds) async {
    await fetchRiskPoints(); // Risk noktalarını API'den yükle
    final visiblePoints = riskPoints.where((point) {
      final position = LatLng(point.xKoordinat, point.yKoordinat);
      return bounds.contains(position);
    }).toList();



    setState(() {
      _circles = visiblePoints.map((point) {
        return Circle(
          circleId: CircleId('${point.xKoordinat},${point.yKoordinat}'),
          center: LatLng(point.xKoordinat, point.yKoordinat),
          radius: point.kazaSayisi * 25, // Kaza sayısına göre yarıçap belirlenebilir
          fillColor: point.kazaSayisi == 1
              ? Colors.blue
              : point.kazaSayisi <= 3
              ? Colors.orange
              : Colors.red,
          strokeWidth: 0,
          consumeTapEvents: true,
          onTap: () => showBottomSheet(context, point),
        );
      }).toSet();

    });
  }

  Future<String> _reverseGeocoding(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        return '${placemarks.first.thoroughfare ?? ''} ${placemarks.first.subThoroughfare ?? ''}, '
            '${placemarks.first.subLocality ?? ''}, ${placemarks.first.locality ?? ''}, '
            '${placemarks.first.administrativeArea ?? ''}, ${placemarks.first.country ?? ''}';
      } else {
        return "Adres bulunamadı!";
      }
    } catch (e) {
      return "Hata: $e";
    }
  }



  void showBottomSheet(BuildContext context, RiskPoint point) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.location_on,
                    color: point.kazaSayisi == 1
                        ? Colors.blue
                        : point.kazaSayisi <= 3
                        ? Colors.orange
                        : Colors.red,
                  ),
                  title: FutureBuilder<String>(
                    future: _reverseGeocoding(point.xKoordinat, point.yKoordinat), // Future<String> döndüren fonksiyon
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(color: Colors.white); // Yüklenme göstergesi
                      } else if (snapshot.hasError) {
                        return Text("Hata: ${snapshot.error}");
                      } else {
                        return Text(
                          snapshot.data ?? "Adres bulunamadı!",
                          style: GoogleFonts.quicksand(color: Colors.white),
                        );
                      }
                    },
                  ),
                ),
                Column(
                  children: [
                    ListTile(title: Text('Kaza Şekli', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.car_crash, color: Colors.white)),
                    Container(
                      height: point.kazaSekli.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final kazaTipiListesi = point.kazaSekli.map((e) => e.kazaTipi).toList();
                          final kazaTipiYuzdelikListesi = point.kazaSekli.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+kazaTipiYuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(kazaTipiListesi[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.kazaSekli.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(title: Text('Hava Durumu', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.ac_unit_outlined, color: Colors.white)),
                    Container(
                      height: point.havaDurumu.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final havaDurumuListesi = point.havaDurumu.map((e) => e.havaDurumu).toList();
                          final havaDurumuYuzdelikListesi = point.havaDurumu.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+havaDurumuYuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(havaDurumuListesi[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.havaDurumu.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(title: Text('Saat', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.access_time_filled, color: Colors.white)),
                    Container(
                      height: point.saatler.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final list = point.saatler.map((e) => e.saat).toList();
                          final yuzdelikListesi = point.saatler.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+yuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(list[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.saatler.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(title: Text('Tarih', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.date_range, color: Colors.white)),
                    Container(
                      height: point.tarihler.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final list = point.tarihler.map((e) => e.tarih).toList();
                          final yuzdelikListesi = point.tarihler.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+yuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(list[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.tarihler.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(title: Text('Mevsim', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.sunny, color: Colors.white)),
                    Container(
                      height: point.mevsimler.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final list = point.mevsimler.map((e) => e.mevsim).toList();
                          final yuzdelikListesi = point.mevsimler.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+yuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(list[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.mevsimler.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(title: Text('Yol Kaplama Cinsi', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.add_road, color: Colors.white)),
                    Container(
                      height: point.yolKaplamaCinsi.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final list = point.yolKaplamaCinsi.map((e) => e.yolKaplamaCinsi).toList();
                          final yuzdelikListesi = point.yolKaplamaCinsi.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+yuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(list[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.yolKaplamaCinsi.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(title: Text('Yol Sınıfı', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.streetview, color: Colors.white)),
                    Container(
                      height: point.yolSinifi.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final list = point.yolSinifi.map((e) => e.yolSinifi).toList();
                          final yuzdelikListesi = point.yolSinifi.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+yuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(list[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.yolSinifi.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(title: Text('Gün Durumu', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.nightlight, color: Colors.white)),
                    Container(
                      height: point.geceGunduz.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final list = point.geceGunduz.map((e) => e.geceGunduz).toList();
                          final yuzdelikListesi = point.geceGunduz.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+yuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(list[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.geceGunduz.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ListTile(title: Text('Yasal Hız Limiti', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.speed, color: Colors.white)),
                    Container(
                      height: point.yasalHizLimiti.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final list = point.yasalHizLimiti.map((e) => e.yasalHizLimiti).toList();
                          final yuzdelikListesi = point.yasalHizLimiti.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+yuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(list[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.yasalHizLimiti.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
                Text('Toplam Ölüm: ${point.toplamOlu}', style: TextStyle(color: Colors.white)),
                Text('Toplam Yaralı: ${point.toplamYarali}', style: TextStyle(color: Colors.white)),
                Column(
                  children: [
                    ListTile(title: Text('Çarpışma Yeri', style: GoogleFonts.quicksand(color: Colors.white, fontWeight: FontWeight.bold)), // Başlık rengi eklendi
                        leading: Icon(Icons.car_repair, color: Colors.white)),
                    Container(
                      height: point.carpismaYeri.length * 50,
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final list = point.carpismaYeri.map((e) => e.carpismaYeri).toList();
                          final yuzdelikListesi = point.carpismaYeri.map((e) => e.yuzde).toList();// Map işleminden sonra listeye dönüştür
                          return ListTile(
                            leading: Text("%"+yuzdelikListesi[index].toInt().toString(), style: GoogleFonts.quicksand(color: Colors.white),),
                            title: Text(list[index], style: GoogleFonts.quicksand(color: Colors.white),),
                          );
                        },
                        itemCount: point.carpismaYeri.length, // Kaç eleman olduğunu belirt
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null
        ? Center(child: CircularProgressIndicator(color: Colors.black,))
        : GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
        if(darkMode == true){
          setState(() {
            _mapController?.setMapStyle(_mapStyle);
          });
        }


      },
      initialCameraPosition: CameraPosition(
        target: _initialPosition!,
        zoom: 14.0,
      ),
      mapType: mapType,
      zoomControlsEnabled: false,
      trafficEnabled: trafficMap,
      myLocationButtonEnabled: true,
      circles: _circles,
      onCameraIdle: () async {
        final bounds = await _mapController!.getVisibleRegion();
        _updateRiskPoints(bounds);
      },
      myLocationEnabled: true,
    );
  }

  final String _mapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#353736"  // Harita geometrisinin rengi
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "on"  // Simge etiketlerinin görünür olması
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#000000"  // Metin rengini beyaz yapar
        }
      ]
    },
    {
      "featureType": "administrative.country",
      "elementType": "geometry.fill",
      "stylers": [
        {
          "color": "#e0e0e0"  // Ülke sınırlarının dolgu rengi
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "visibility": "on"  // Yol geometrisinin basit görünümü
        },
        {
          "color": "#000000"  // Yolların rengini koyu gri yapar
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels",
      "stylers": [
        {
          "visibility": "on"  // Yol isimlerinin görünür olması
        },
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#2f2f2f"  // Otoyolların rengini koyu gri yapar
        }
      ]
    }
  ]
  ''';
}