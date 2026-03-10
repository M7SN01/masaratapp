import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widget/widget.dart';
// import '../../../../../utils/utils.dart';
import '../../../controllers/login_controller.dart';
// import '../../../../Controllers/user_controller.dart';

class ManagerHome extends StatelessWidget {
  const ManagerHome({super.key});

  @override
  Widget build(BuildContext context) {
    // final userController = Get.find<UserController>();
    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("تقارير ادارية"),
          // ,
          centerTitle: true,
        ),
        body: SizedBox(
          width: Get.width,
          height: Get.height,
          // color: Colors.blueAccent,
          child: GridView(
            padding: EdgeInsets.all(20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 3 / 4),
            children: [
              mainGraid(
                icon: Icons.inventory_outlined,
                title: "مبيعات حسب\n مراكز البيع",
                onTap: () {
                  Get.toNamed('/ManagerHome/SlsByslsCntr');
                  // Get.to(() => const CustomerKshf(), binding: CustomerKshfBinding());
                },
              ),
              mainGraid(
                icon: Icons.inventory_outlined,
                title: "مبيعات حسب\n المناديب",
                onTap: () {
                  Get.toNamed('/ManagerHome/SlsByslsMan');
                  // Get.to(() => const CustomerKshf(), binding: CustomerKshfBinding());
                },
              ),
              mainGraid(
                icon: Icons.inventory_outlined,
                title: "اعمار الديون",
                onTap: () {
                  Get.toNamed('/ManagerHome/CustomersAging');
                  // Get.to(() => const CustomerKshf(), binding: CustomerKshfBinding());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
