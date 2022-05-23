// ignore_for_file: file_names
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import "package:latlong2/latlong.dart" as latLang;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/state_manager.dart';
import 'package:tracker/services/gps_services.dart';

class TrackerController extends GetxController {
  var appBar = 'TrackerApp'.obs;
  Position? position;
  MapController mapController = MapController();
//list of location witch user will add
  var locationLists = <Marker>[];
  bool isVisable = false;
  addCordinateds(double lat, double long) {
    locationLists.add(Marker(
        point: latLang.LatLng(lat, long),
        builder: (ctx) => Icon(
              Icons.my_location_outlined,
              color: Colors.red,
              size: 30,
            )));
    isVisable = true;
    update();
  }

  //Functoion witch for restarting the location
  locationReset(Position curentPossition) async {
    log('******Locaton_Reset_called******', name: 'TrackerContrller');
    Position newPosition = await GpsService.instance.getCurrentPosition();
    position = newPosition;
    mapController.moveAndRotate(
        latLang.LatLng(curentPossition.latitude, curentPossition.longitude),
        13,
        0);
    update();
  }
//for locating location in lunch Icon 
  locateLocation(double lat , double lon) {
    Get.back();

    mapController.moveAndRotate(
        latLang.LatLng(lat, lon),15, 0);
  }

// Function witch fires when to init run and get permission and location and update the possiton up
  locationUpdate() async {
    log('******Locaton_Update_called******', name: 'TrackerContrller');
    await GpsService.instance.getStarted();
    var currentLocatiom = await GpsService.instance.getCurrentPosition();
    position = currentLocatiom;

    update();
    log(position.toString());
  }

  @override
  void onInit() async {
    log('******onInit Called******* ', name: 'TrackerController');
    await locationUpdate();
    super.onInit();
  }
}
