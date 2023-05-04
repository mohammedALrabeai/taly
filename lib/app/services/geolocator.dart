import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

//
// v2.0 - 29/09/2020
//

class MyLocation2 {
  Geolocator _geolocator = Geolocator();
  Position _currentPosition;

  Future<Position> getCurrent() async {
    _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium)
        .timeout(Duration(seconds: 10), onTimeout: () async {
      return await Geolocator.getLastKnownPosition().timeout(Duration(seconds: 10));
    });
    // _currentPosition.heading
    return _currentPosition;
  }

 Future<double> distance(double lat, double lng) async {
    // Map<PermissionGroup, PermissionStatus> permissions =
    // await PermissionHandler().requestPermissions([PermissionGroup.location]);

    var _distanceInMeters = -1.0;

    if ( PermissionStatus.granted.isGranted) {
      if (_currentPosition == null)
        await getCurrent();

      if (_currentPosition != null) {
        _distanceInMeters = await Geolocator.distanceBetween(
            _currentPosition.latitude, _currentPosition.longitude,
            lat, lng);
      }
    }
    return _distanceInMeters;
  }

 double distanceBetween(double lat, double lng, double lat2, double lng2)  {
    var _distanceInMeters = 9999999.0;
    _distanceInMeters =  Geolocator.distanceBetween(
        lat2, lng2,
        lat, lng);
    return _distanceInMeters;
  }
}