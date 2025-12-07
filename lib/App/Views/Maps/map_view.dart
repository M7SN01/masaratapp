import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:get/get.dart';
import 'package:masaratapp/App/Controllers/visit_map_controller.dart';

import '../../Widget/widget.dart';
import '../../utils/utils.dart';

class VisitMap extends StatefulWidget {
  const VisitMap({super.key});

  @override
  State<VisitMap> createState() => _VisitMapState();
}

class _VisitMapState extends State<VisitMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GetBuilder<VisitMapController>(
        builder: (controller) => Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: controller.isPostedBefor
                          ? null
                          : () {
                              showDialog(
                                useSafeArea: true,
                                context: context,
                                builder: (context) {
                                  return SearchListDialog(
                                    title: "اختر عميل",
                                    originalData: controller.cusData.map((e) => SearchList(id: e.cusId, name: e.cusName)).toList(),
                                    onSelected: (selectedItem) {
                                      controller.selecetdCustomer = controller.cusData.firstWhere((e) => e.cusId == selectedItem.id);
                                      controller.update();
                                      Get.back();
                                    },
                                  );
                                },
                              );
                            },
                      child: Opacity(
                        opacity: !controller.isPostedBefor ? 1.0 : 0.5,
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: controller.selecetdCustomer == null ? primaryColor : secondaryColor,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.checklist_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "إختر عميل",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.buildMarkerAndPolygon();
                      },
                      child: Opacity(
                        opacity: !controller.isPostedBefor ? 1.0 : 0.5,
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: controller.selecetdCustomer == null ? primaryColor : secondaryColor,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.checklist_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "TEST",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            //customer information
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                // final isShowing = child.key != const ValueKey('empty');
                final begin = controller.selecetdCustomer != null ? const Offset(1, 0) : const Offset(-1, 0); //in=> on x from 1 to zero 1,1 => 0,0
                final end = controller.selecetdCustomer != null ? Offset.zero : const Offset(0, 0); // out =>  on -x ?????
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: begin,
                    end: end,
                  ).animate(animation),
                  child: child,
                );
              },
              //FadeTransition(opacity: animation, child: child),
              child: controller.selecetdCustomer != null
                  ? Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 1,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        side: BorderSide(
                          color: primaryColor,
                          width: 0.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Center(child: Text("اسم العميل :")),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(controller.selecetdCustomer!.cusName)),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      const Center(child: Text("جوال العميل :")),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(controller.selecetdCustomer!.mobl ?? "")),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      const Center(child: Text("العنوان :")),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(controller.selecetdCustomer!.adrs ?? "")),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    children: [
                                      const Center(child: Text("الرقم الضريبي :")),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(controller.selecetdCustomer!.taxNo ?? "")),
                                    ],
                                  ),
                                  const Divider(),
                                  IntrinsicHeight(
                                    child: Row(children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.defaultDialog(
                                              title: "تنبية",
                                              middleText: "هل انت متاكد إن موقعك الحالى هو موقع :\n ${controller.selecetdCustomer!.cusName} ",
                                              textConfirm: "تأكيد",
                                              textCancel: "الغاء",

                                              middleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                              onConfirm: () {
                                                controller.setCurrentLocation();
                                                debugPrint("chose the location");
                                                Get.back();
                                              },
                                              // onCancel: () {},
                                            );
                                          },
                                          child: Opacity(
                                            opacity: 1.0,
                                            child: Container(
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                color: controller.selecetdCustomer == null ? primaryColor : secondaryColor,
                                                border: Border.all(color: Colors.grey, width: 1),
                                                borderRadius: BorderRadius.circular(5),
                                                shape: BoxShape.rectangle,
                                              ),
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.location_pin,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "تحديد موقع العميل",
                                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: IconButton(
                              onPressed: controller.isPostedBefor
                                  ? null
                                  : () {
                                      controller.selecetdCustomer = null;
                                      controller.update();
                                    },
                              icon: Icon(
                                Icons.cancel_rounded,
                                color: controller.isPostedBefor ? Colors.grey : secondaryColor,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(
                      key: ValueKey('empty'),
                    ),
            ),

            SizedBox(height: controller.selecetdCustomer == null ? 10 : 0),

            Expanded(
              // flex: 5,
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: controller.animatedMapController.mapController,
                    options: MapOptions(
                      initialCenter: controller.latlang(21.502988278492147, 39.18250154703856),
                      initialZoom: 10,
                      onTap: (tapPosition, point) {
                        controller.popupController.hideAllPopups();
                      },
                      onLongPress: (tapPosition, point) {},
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://maps.googleapis.com/maps/vt?lyrs=m&x={x}&y={y}&z={z}&style=feature:park|visibility:off&style=feature:road|visibility:off',
                        additionalOptions: const {
                          'key': 'AIzaSyBkqsPZ2r9abLw-NMgDsRbG_5bfl06TjeY',
                        },
                      ),
                      PolygonLayer(
                        polygons: controller.polygons,
                      ),
                      MarkerLayer(markers: controller.defultmarker),
                      PopupMarkerLayer(
                        options: PopupMarkerLayerOptions(
                          popupController: controller.popupController,
                          markers: controller.defultmarker,
                          popupDisplayOptions: PopupDisplayOptions(
                            builder: (BuildContext context, Marker marker) {
                              return GestureDetector(
                                child: Card(
                                  child: Padding(padding: const EdgeInsets.all(8.0), child: controller.infoWindow[marker.key]),
                                ),
                                onLongPress: () {
                                  // // print(marker.key.toString().replaceAll("[<'", '').replaceAll("'>]", '') + "-" + cusIds[marker.key.toString().replaceAll("[<'", '').replaceAll("'>]", '')].toString());
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  //   return OpenKshf(
                                  //     accId: "", // accIdInfo[marker.key]!.replaceAll(" ", ""),
                                  //     cusId: cusIds[marker.key.toString().replaceAll("[<'", '').replaceAll("'>]", '')] ?? "", // marker.key.toString().replaceAll("[<'", '').replaceAll("'>]", ''),
                                  //     accName: cusName[marker.key] ?? "",
                                  //   );
                                  // }));
                                },
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  //---------------

                  if (true) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: controller.isExpandedMapKey ? 400 : 0,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: controller.isExpandedMapKey
                          ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              child: ListView.builder(
                                padding: const EdgeInsets.all(10),
                                itemCount: controller.cus_count.length,
                                itemBuilder: (context, index) {
                                  String key = controller.cus_count.keys.elementAt(index);
                                  Map<String, dynamic> data = controller.cus_count[key]!;

                                  return index == 0
                                      ? Column(
                                          children: [
                                            // Display the total count as a title
                                            Text(
                                              controller.totalCusCount.toString(),
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),

                                            const Divider(
                                              color: Colors.blueGrey,
                                              height: 1,
                                              thickness: 0.5,
                                            ),

                                            SizedBox(
                                              height: 45,
                                              child: ListTile(
                                                // horizontalTitleGap: 0,
                                                contentPadding: const EdgeInsets.all(0),
                                                leading: Icon(Icons.location_pin, color: data["color"]),
                                                title: Text(
                                                  data["name"],
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                subtitle: Text('${data["cus_count"]}'),
                                              ),
                                            )
                                          ],
                                        )
                                      : SizedBox(
                                          height: 45,
                                          child: ListTile(
                                            // horizontalTitleGap: 0,
                                            contentPadding: const EdgeInsets.all(0),
                                            leading: Icon(Icons.location_pin, color: data["color"]),
                                            title: Text(
                                              data["name"],
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            subtitle: Text('${data["cus_count"]}'),
                                          ),
                                        );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    IconButton(
                      icon: Icon(
                        controller.isExpandedMapKey ? Icons.info : Icons.info_outline,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          controller.isExpandedMapKey = !controller.isExpandedMapKey;
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Opacity(
                        opacity: !controller.isPostedBefor ? 1.0 : 0.5,
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: controller.selecetdCustomer == null ? primaryColor : secondaryColor,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.checklist_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "زيـــارة",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
          ],
        ),
      ),
    );
  }
}
