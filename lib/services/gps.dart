import 'package:geolocator/geolocator.dart';

class LocationService {
  double? _latitude;
  double? _longitude;
  double? _altitude;
  double? _altitudeAccuracy;
  double? _speed; // m/s cinsinden hız

  double? get latitude => _latitude;
  double? get longitude => _longitude;
  double? get altitude => _altitude;
  double? get altitudeAccuracy => _altitudeAccuracy;
  double? get speed => _speed; // m/s cinsinden hız

  Future<void> updateCoordinates() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Konum izni kalıcı olarak reddedildi. Ayarlardan değiştirin.');
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.deniedForever) {
          throw Exception('Konum izni kalıcı olarak reddedildi. Ayarlardan değiştirin.');
        } else if (permission == LocationPermission.denied) {
          throw Exception('Konum izni reddedildi.');
        }
      }

      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Konum izni yalnızca kullanımda veya her zaman iznine sahip olmalı.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      updateLocation(position);
    } catch (e) {
      print("Hata: $e");
      _latitude = null;
      _longitude = null;
      _altitude = null;
      _altitudeAccuracy = null;
      _speed = null;
    }
  }

  Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Minimum 1 metre hareketten sonra güncelleme yapar
      ),
    );
  }

  void updateLocation(Position position) {
    _latitude = position.latitude;
    _longitude = position.longitude;
    _altitude = position.altitude;
    _altitudeAccuracy = position.altitudeAccuracy;
    _speed = position.speed; // m/s olarak hız alındı
  }

  double? getSpeedInKmPerHour() {
    if (_speed != null) {
      return _speed! * 3.6; // m/s -> km/s çevirimi
    }
    return null;
  }
}

final LocationService locationService = LocationService();