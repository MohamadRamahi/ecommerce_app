import 'package:geolocator/geolocator.dart';
import 'user_location.dart';

class LocationRepository {
  Future<UserLocation?> getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled.
      return null;
    }

    // Check for location permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission if denied.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied.
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied.
      return null;
    }

    // Retrieve the current position.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return UserLocation(
        latitude: position.latitude, longitude: position.longitude);
  }
}
