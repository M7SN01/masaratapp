import 'package:get/get.dart';
import '../controllers/act_kshf_controller.dart';

class ActKshfBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActKshfController>(() => ActKshfController());
  }
}
