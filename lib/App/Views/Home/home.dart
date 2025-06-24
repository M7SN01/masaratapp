import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaratapp/App/Controllers/offline_user_controller.dart';
import 'package:masaratapp/App/Widget/loding_dots.dart';
import 'package:shimmer/shimmer.dart';
import '../../Bindings/offline_binding.dart';
import '../../Controllers/login_controller.dart';
import '../../Controllers/user_controller.dart';
import '../../utils/utils.dart';

class WelcomeSplashScreen extends StatelessWidget {
  final String userName;
  final bool isOffline;
  const WelcomeSplashScreen({super.key, required this.userName, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen.withScreenRouteFunction(
      backgroundColor: primaryColor.withAlpha((0.2 * 255).round()),
      splashIconSize: Get.height / 4,
      splash: Column(
        children: [
          Icon(Icons.person, size: 60, color: Colors.white),
          const SizedBox(height: 20),
          Shimmer.fromColors(
            period: const Duration(milliseconds: 1000), //was 2 sceondes
            baseColor: Colors.white,
            highlightColor: Colors.grey[300]!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "مرحباً ",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(child: SizedBox(width: 120, child: TextLodingDots()))
        ],
      ),
      // splashIconSize: 140,
      animationDuration: const Duration(seconds: 1),

      // duration: 60000, //until open next page
      // backgroundColor: PrimaryColor,
      screenRouteFunction: () async {
        UserController userController = Get.put(UserController(), permanent: true);
        if (isOffline) {
          OfflineUserController offlineUserController = Get.put(OfflineUserController());
          offlineUserController.isOfflineMode = isOffline;
          await offlineUserController.getAllOfflineData();
        } else {
          //sync the local data to server before begin online
          await userController.syncLocalDataToserver();
          await userController.getAllPrivileges();
        }
        // Get.offAllNamed("/Home");

        return "/Home";
      },
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
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
          leading: IconButton(
            onPressed: () async {
              await controller.onLogout();
              Get.offAllNamed('/Login');
              // Get.offAll(() => Login(), binding: LoginBinding());
            },
            icon: Icon(Icons.logout_rounded),
          ),
          actions: [
            //ERROR
            userController.errorLog.contains("ERROR:")
                ? IconButton(
                    onPressed: () {
                      copyTextToClipboard(userController.errorLog);
                      shareTextFile(userController.appLog, "errorLog.txt");
                    },
                    icon: Icon(
                      Icons.error_outline_rounded,
                      color: secondaryColor,
                      size: 40,
                    ),
                  )
                : SizedBox(),
            //ALERT privileges
            userController.appLog.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      copyTextToClipboard(userController.appLog);
                      shareTextFile(userController.appLog, "appLog.txt");
                    },
                    icon: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.amber,
                      size: 40,
                    ),
                  )
                : SizedBox(),
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
              if (controller.isOfflineMode)
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
    final userController = Get.find<UserController>();
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
                child: Text("Sync Basic Offline Data"),
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
              child: Text("Sync Sanadat  Data"),
            ),
            ElevatedButton(
              onPressed: controller.isLoading ? null : () => userController.syncLocalDataToserver(),
              child: Text("Sync Sanadat  To SERVER"),
            ),
          ],
        ),
      ),
    );
  }
}
