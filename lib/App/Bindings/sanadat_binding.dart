import 'package:get/get.dart';
import '../controllers/sanadat_controller.dart';

class SanadatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SanadatController>(() => SanadatController());
  }
}
