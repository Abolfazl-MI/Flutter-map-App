import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tracker/controllers/tracker_controller.dart';
import 'package:tracker/services/gps_services.dart';

class Widgets {
  Widgets._();
  static Widgets instance = Widgets._();
  errorDialogs(String errorType) {
    if (errorType == 'Location permission is denied') {
      Get.defaultDialog(
          title: 'Location permission is denied!',
          content:
              const Text('Please allow location permission to use this app.'),
          onCancel: () {},
          onConfirm: () {
            GpsService.instance.getStarted();
          });
    }
    if (errorType == "Location services are not enabled") {
      Get.defaultDialog(
          title: 'Enable Location Services',
          content:
              const Text('Please enable location services to use this app'),
          onCancel: () {},
          onConfirm: () {
            GpsService.instance.getStarted();
          });
    }
  }

  historyIconVisbalityWidget({required TrackerController controller}) {
    return Visibility(
        visible: controller.isVisable,
        child: IconButton(
            icon: const Icon(
              Icons.history,
              color: Colors.white,
            ),
            onPressed: () {
              Get.bottomSheet(Container(
                  color: Colors.white,
                  width: Get.width,
                  height: Get.height * 0.4,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recently added locations',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        Expanded(
                            child: ListView.builder(
                                itemCount: controller.locationLists.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                      child: ExpansionTile(
                                          title: Text('Locations'),
                                          children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('lat:' +
                                                  controller
                                                      .locationLists[index]
                                                      .point
                                                      .latitude
                                                      .toString()),
                                              Text('lon:' +
                                                  controller
                                                      .locationLists[index]
                                                      .point
                                                      .longitude
                                                      .toString()),
                                              IconButton(
                                                  onPressed: () =>
                                                      controller.locateLocation(
                                                          controller
                                                              .locationLists[
                                                                  index]
                                                              .point
                                                              .latitude,
                                                          controller
                                                              .locationLists[
                                                                  index]
                                                              .point
                                                              .longitude),
                                                  icon: const Icon(
                                                    Icons.launch,
                                                    color: Colors.blue,
                                                  ))
                                            ])
                                      ]));
                                }))
                      ])));
            }));
  }

  double doubleParsser(String string) {
    log('parsing value $string');
    return double.parse(string);
  }

  addIcon(
      {required TrackerController controller,
      required TextEditingController latController,
      required TextEditingController lonController}) {
    return Visibility(
        visible: true,
        child: IconButton(
            onPressed: () {
              Get.bottomSheet(Container(
                height: Get.height * 0.4,
                color: Colors.white,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Add new Location'),
                      myFormFeild('LocationLat', latController),
                      myFormFeild('LocationLon', lonController),
                     Row(
                       mainAxisAlignment : MainAxisAlignment.spaceAround,
                       children: [
                          button(ontap: () {
                            controller.addCordinateds(
                                Widgets.instance
                                    .doubleParsser(latController.text),
                                Widgets.instance
                                    .doubleParsser(lonController.text));
                            Get.back();
                          }),
                          // for net of adding navigation to lat amd lon witch givien by user
                           button(
                             title: 'Add and Go',
                             ontap: () {
                        controller.addCordinateds(
                            Widgets.instance.doubleParsser(latController.text),
                            Widgets.instance.doubleParsser(lonController.text));
                        Get.back();
                        controller.locateLocation(
                            Widgets.instance.doubleParsser(latController.text),
                            Widgets.instance.doubleParsser(lonController.text));
                      })
                       ],
                     )
                    ]),
              ));
            },
            icon: const Icon(Icons.add)));
  }

  button({required VoidCallback ontap, String? title}) {
   
    
      return InkWell(
        onTap: ontap,
        
        child: Container(
          width: Get.width * 0.4,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child:  Center(
            child: Text(
              title??'Add',
              style:
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
  }

  myFormFeild(String title, TextEditingController controller) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: TextField(
          inputFormatters: [],
          controller: controller,
          keyboardType: TextInputType.number,
          keyboardAppearance: Brightness.dark,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
            labelText: title,
          ),
        ));
  }

  // controller.locateLocation(
  //     controller.locationLists[index]
  //         .point.latitude,
  //     controller.locationLists[index]
  //         .point.longitude),



