import 'package:get/get.dart';
import 'package:masaratapp/App/Controllers/offline_user_controller.dart';

class OfflineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OfflineUserController>(() => OfflineUserController());
  }
}
