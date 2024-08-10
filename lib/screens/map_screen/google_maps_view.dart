import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_risk_information_system/risk_points/risk_point.dart';
import 'package:traffic_risk_information_system/risk_points/risk_points.dart';
import 'package:traffic_risk_information_system/screens/settings_screen/settings.dart';
import 'package:traffic_risk_information_system/services/gps.dart';

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

@override
void initState() {
  super.initState();
  _getLocation(); // Uygulama açıldığında konum bilgilerini alır.
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

  Set<Circle> circles = riskPoints.map((riskPoint) {
    return Circle(
      circleId: CircleId('${riskPoint.xKoordinat},${riskPoint.yKoordinat}'),
      center: LatLng(riskPoint.xKoordinat, riskPoint.yKoordinat),
      radius: riskPoint.kazaSayisi * 10, // Kaza sayısına göre yarıçap belirlenebilir
      fillColor: riskPoint.kazaSayisi == 1 ? Colors.blue : riskPoint.kazaSayisi <= 3 ? Colors.orange : Colors.red,
      strokeColor: Colors.red,
      strokeWidth: 2,
    );
  }).toSet();



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
        "color": "#ff8c00"  // Otoyolların rengini turuncu yapar
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "simplified"  // Otoyol isimlerini basit görünümde gösterir
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "on"  // Noktasal ilgi alanlarının etiketlerini görünür yapar
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels",
    "stylers": [
      {
        "visibility": "on"  // Toplu taşıma etiketlerini görünür yapar
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.stroke",  // Yol sınırlarının çizgilerini yönetir
    "stylers": [
      {
        "color": "#000000",  // Çizgi rengini siyah yapar
        "visibility": "off"  // Çizgileri görünmez yapar
      }
    ]
  }
]
''';

    @override
    Widget build(BuildContext context) {
      return _initialPosition == null
          ? Center(child: CircularProgressIndicator(color: Colors.black,))
          : GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
          if(darkMode == true) {_setMapStyle();}
        },
        initialCameraPosition: CameraPosition(
          target: _initialPosition!,
          zoom: 14.0,
        ),
        mapType: mapType,
        zoomControlsEnabled: false,
        trafficEnabled: trafficMap,
        myLocationButtonEnabled: false,
        circles: circles,
      );
    }


void _setMapStyle() {
      _mapController?.setMapStyle(_mapStyle);
    }

}
