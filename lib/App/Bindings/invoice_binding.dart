import 'package:get/get.dart';
import '../Controllers/invoice_controller.dart';

class InvoiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoiceController>(() => InvoiceController() /*, permanent: true*/);
  }
}
