import 'package:get/get.dart';

import '../Controllers/visit_map_controller.dart';

class VisitMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitMapController>(() => VisitMapController());
  }
}
