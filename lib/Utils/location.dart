import 'package:location/location.dart';

class LocationService {
  Location location;
  LocationService() {
    location = new Location();
  }

  Future<bool> isPermissionGranted() async {
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    return _permissionGranted != PermissionStatus.denied;
  }

  Future<bool> enableLocation() async {
    PermissionStatus _permissionGranted;
    _permissionGranted = await location.requestPermission();
    return _permissionGranted != PermissionStatus.granted;
  }

  Future<double> getCurrentLatitude() async {
    LocationData _locationData;
    _locationData = await location.getLocation();

    return _locationData.latitude;
  }

  Future<double> getCurrentLongitute() async {
    LocationData _locationData;
    _locationData = await location.getLocation();
    return _locationData.latitude;
  }
}
