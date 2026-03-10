import 'package:get/get.dart';

import '../controller/cus_aging_controller.dart';

class CusAgingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomersAgingController>(() => CustomersAgingController());
    // Get.put<SlsCenterController>(SlsCenterController());
  }
}
