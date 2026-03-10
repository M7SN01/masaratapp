import 'package:get/get.dart';

import '../controllers/cus_balance_controller.dart';

class CustomerBalanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CusBalanceController>(() => CusBalanceController());
  }
}
