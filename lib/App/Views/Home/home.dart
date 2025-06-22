import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaratapp/App/Controllers/offline_user_controller.dart';
import '../../Bindings/offline_binding.dart';
import '../../Controllers/login_controller.dart';
import '../../utils/utils.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text("Home"),
              if (controller.isOfflineMode)
                Text(
                  "العمل دون اتصال",
                  style: TextStyle(color: secondaryColor),
                ),
            ],
          ),
          // ,
          centerTitle: true,
          leading: SizedBox(),
          actions: [
            IconButton(
              onPressed: () async {
                await controller.onLogout();
                Get.offAllNamed('/Login');
                // Get.offAll(() => Login(), binding: LoginBinding());
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
                  // debugPrint("hhhhhhhhhhhhhhhhh");
                  Get.toNamed('/Invoice');
                  // Get.to(() => const Invoice(), binding: InvoiceBinding());
                },
              ),
              mainGraid(
                icon: Icons.inventory_outlined,
                title: "سـنـد قـبـض",
                onTap: () {
                  Get.toNamed('/Sanadat');
                  // Get.to(() => const Sanadat(), binding: SanadatBinding());
                },
              ),
              mainGraid(
                icon: Icons.inventory_outlined,
                title: "كشف حساب",
                onTap: () {
                  Get.toNamed('/CustomerKshf');
                  // Get.to(() => const CustomerKshf(), binding: CustomerKshfBinding());
                },
              ),
              mainGraid(
                icon: Icons.inventory_outlined,
                title: "العمل دون اتصال",
                onTap: () {
                  Get.to(() => const OfflineSqflite(), binding: OfflineBinding());
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

class OfflineSqflite extends StatelessWidget {
  const OfflineSqflite({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OfflineUserController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("Test"),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: controller.isLoading ? null : () => controller.setNewOfflineData(),
                child: Text("Sync Offline Data"),
              ),
            ),
            if (controller.isLoading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: LinearProgressIndicator(
                  value: controller.loadingProgress,
                  minHeight: 8,
                ),
              ),
            ElevatedButton(
              onPressed: controller.isLoading ? null : () => controller.serverToLocalSanadatData(),
              child: Text(" Get Data"),
            ),
          ],
        ),
      ),
    );
  }
}
