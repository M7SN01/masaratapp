import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Bindings/invoice_binding.dart';
import '../../Controllers/login_controller.dart';
// import '../Controllers/user_controller.dart';
import '../../utils/utils.dart';
import '../../Views/Invoice/invoice.dart';

// import '../../Controllers/invoice_controller.dart';
import '../../Bindings/cus_kshf_binding.dart';
import '../../Bindings/sanadat_binding.dart';
import '../CustomerKshf/cus_kshf.dart';
import '../Sanadat/sanadat.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder:
          (controller) => Scaffold(
            appBar: AppBar(
              title: Text("Home"),
              centerTitle: true,
              leading: SizedBox(),
              actions: [
                IconButton(
                  onPressed: () async {
                    await controller.onLogout();
                  },
                  icon: Icon(Icons.logout_rounded),
                ),
              ],
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
                    title: "فاتورة مبيعات",
                    onTap: () {
                      // print("hhhhhhhhhhhhhhhhh");
                      Get.to(() => const Invoice(), binding: InvoiceBinding());
                    },
                  ),
                  mainGraid(
                    icon: Icons.inventory_outlined,
                    title: "سـنـد قـبـض",
                    onTap: () {
                      Get.to(() => const Sanadat(), binding: SanadatBinding());
                    },
                  ),
                  mainGraid(
                    icon: Icons.inventory_outlined,
                    title: "كشف حساب",
                    onTap: () {
                      Get.to(() => const CustomerKshf(), binding: CustomerKshfBinding());
                    },
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget mainGraid({required IconData icon, required String title, required Function onTap}) {
    return Material(
      color: primaryColor,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: Color(0XFFdaeefa),
        onTap: () => onTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, // Replace with an appropriate icon
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Center(child: Text(textAlign: TextAlign.center, title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
