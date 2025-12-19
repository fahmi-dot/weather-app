import 'package:geolocator/geolocator.dart';

class Permissions {
  static Future<bool> requestLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  static Future<bool> checkLocationServices() async {
    return await Geolocator.isLocationServiceEnabled();
  }
}