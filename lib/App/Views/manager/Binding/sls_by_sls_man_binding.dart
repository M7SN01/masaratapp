import 'package:get/get.dart';
import '../controller/sls_by_sls_man_controller.dart';

class SlsBySlsManBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SlsBySlsManController>(() => SlsBySlsManController());
    // Get.put<SlsCenterController>(SlsCenterController());
  }
}
