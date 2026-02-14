import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/offline_user_controller.dart';
import '../../../../utils/utils.dart';

class OfflineSqflite extends StatelessWidget {
  const OfflineSqflite({super.key});

  @override
  Widget build(BuildContext context) {
    // final userController = Get.find<UserController>();
    return GetBuilder<OfflineUserController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("مزامنة البيانات من السرفر"),
        ),
        body: Column(
          children: [
            Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextButton(
                    onPressed: controller.isLoading
                        ? null
                        : () async {
                            await controller.setNewOfflineData();
                            // await controller.serverToLocalSanadatData();
                          },
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                    ),
                    child: Text("مزامنة", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ]),
            if (controller.isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                child: LinearProgressIndicator(
                  color: secondaryColor,
                  value: controller.loadingProgress,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  minHeight: 20,
                  backgroundColor: secondaryColor.withAlpha((0.2 * 255).round()),
                ),
              ),
            // ElevatedButton(
            //   onPressed: controller.isLoading ? null : () => controller.serverToLocalSanadatData(),
            //   child: Text("Sync Sanadat  Data"),
            // ),
            // ElevatedButton(
            //   onPressed: controller.isLoading ? null : () => userController.syncLocalDataToserver(),
            //   child: Text("Sync Sanadat  To SERVER"),
            // ),
            Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: controller.dataSyncInfo.length,
                itemBuilder: (_, index) {
                  var row = controller.dataSyncInfo;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            row[index]['label'].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Spacer(),
                        Expanded(
                          child: row[index]['state'] == SyncState.waitting
                              ? Center(
                                  child: CircularProgressIndicator(color: primaryColor),
                                )
                              : row[index]['state'] == SyncState.done
                                  ? Icon(Icons.done, color: saveColor)
                                  : Icon(Icons.clear_rounded, color: secondaryColor),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
