import 'package:get/get.dart';
import '../../../app/controllers/visit_plan_controller.dart';

import '../controllers/visit_map_controller.dart';

class VisitMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitMapController>(() => VisitMapController());
  }
}

class VisitPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VisitPlanController>(() => VisitPlanController());
  }
}
