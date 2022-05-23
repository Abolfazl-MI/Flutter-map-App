import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:tracker/widgets/widgets.dart';

class GpsService {
  GpsService._();
  static GpsService instance = GpsService._();

  Future _getPermission() async {
    bool servicesEnable;
    LocationPermission permission;
    servicesEnable = await Geolocator.isLocationServiceEnabled();
    if (!servicesEnable) {
      return Future.error('Location services are not enabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission is denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permission is denied forever');
    }
  }

  Future<Position> getCurrentPosition() async {
    Position? position;
    try {
      log('********GetingLocation**********', name: 'GpsService');

      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      print(e);
    }
    return position!;
  }

  Future getStarted() async {
    try {
      log('********GetingPermission**********', name: 'GpsService');
      await GpsService.instance._getPermission();
    } catch (e) {
      if (e.toString() == 'Location services are not enabled') {
        log('********DialogCalled**********', name: 'Dialog Error');

        Widgets.instance.errorDialogs('Location services are not enabled');
      }
      if (e.toString() == 'Location permission is denied') {
        log('********DialogCalled**********', name: 'Dialog Error');

        Widgets.instance.errorDialogs('Location permission is denied');
      }
    }
  }
}
