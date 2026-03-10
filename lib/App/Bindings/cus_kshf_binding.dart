import 'package:get/get.dart';
import '../controllers/cus_kshf_controller.dart';

class CustomerKshfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CusKshfController>(() => CusKshfController());
  }
}
