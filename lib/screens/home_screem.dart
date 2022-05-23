// ignore_for_file: file_names
//state less widget with name homeScreen
import 'dart:developer';

import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import "package:latlong2/latlong.dart" as latLang;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:tracker/constantas.dart';
import 'package:tracker/controllers/tracker_controller.dart';
import 'package:tracker/widgets/widgets.dart';

class HomeScreen extends GetView<TrackerController> {
  TrackerController controller =
      Get.put<TrackerController>(TrackerController());

  HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MaskedTextController latController = MaskedTextController(mask: '00.00000');
    //this is for formating text feild if you fill like to change you can change patern in the mask parameter
    MaskedTextController lonController = MaskedTextController(mask: '00.00000');

    return Scaffold(
        // floating action button for restarting the location
        floatingActionButton: GetBuilder<TrackerController>(
            builder: (controller) => FloatingActionButton(
                onPressed: () => controller.locationReset(controller.position!),
                child: const Icon(Icons.location_searching_outlined))),
        appBar: AppBar(title: const Text("Tracker"), actions: [
          GetBuilder<TrackerController>(
            init: TrackerController(),
            builder: (controller) => Widgets.instance.addIcon(
                controller: controller,
                latController: latController,
                lonController: lonController),
          ),
          // history icon that showsUp when one Iteam add
          GetBuilder<TrackerController>(
              builder: (controller) => Widgets.instance
                  .historyIconVisbalityWidget(controller: controller)),
        ]),
        body: GetBuilder<TrackerController>(
            init: TrackerController(),
            builder: (controller) {
              if (controller.position == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Center(
                    child: GetBuilder<TrackerController>(
                        builder: (controller) => FlutterMap(
                                // mapController: controller.mapController, is for map  moving camera
                                mapController: controller.mapController,

                                // we can use this to set the map to a specific location
                                options: MapOptions(
                                    onTap: (tapPossion, latln) =>
                                        controller.addCordinateds(
                                            latln.latitude, latln.longitude),
                                    center: latLang.LatLng(
                                      controller.position!.latitude,
                                      controller.position!.longitude,
                                    ),
                                    zoom: 13.0),
                                layers: [
                                  //map setting here
                                  TileLayerOptions(
                                      urlTemplate: Constatnts.mapUrl,
                                      additionalOptions: {
                                        'accessToken': Constatnts.tokenMap,
                                        'id': Constatnts.titlesId
                                      }),
                                  // this is where locate the user location in the mapp
                                  MarkerLayerOptions(
                                      markers: //  MarkerLayerOptions(
                                          [
                                        Marker(
                                            point: latLang.LatLng(
                                              controller.position!.latitude,
                                              controller.position!.longitude,
                                            ),
                                            builder: (ctx) => const Icon(
                                                  Icons.my_location_outlined,
                                                  size: 25.0,
                                                  color: Colors.blue,
                                                ))
                                      ]),
                                  //this is were we can add the markers to the map by typing cordinateds
                                  MarkerLayerOptions(
                                    markers: controller.locationLists,
                                  )
                                ])));
              }
            }));
  }
}
