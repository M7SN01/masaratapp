import 'package:get/get.dart';
import '../../../app/controllers/offline_user_controller.dart';

class OfflineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfflineUserController>(() => OfflineUserController());
  }
}
