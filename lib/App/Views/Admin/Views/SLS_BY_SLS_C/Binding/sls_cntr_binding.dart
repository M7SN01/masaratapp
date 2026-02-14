import 'package:get/get.dart';

import '../controller/sls_cntr_controller.dart';

class SlsBySlsCntrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SlsCenterController>(() => SlsCenterController());
    // Get.put<SlsCenterController>(SlsCenterController());
  }
}
