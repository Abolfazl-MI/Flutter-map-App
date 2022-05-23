// ignore_for_file: file_names
import 'package:get/get.dart';
import 'package:tracker/controllers/tracker_controller.dart';

class HomeBiniding implements Bindings {
  @override
  void dependencies() {
    Get.put<TrackerController>(TrackerController());
  }
}
