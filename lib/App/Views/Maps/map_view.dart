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
        builder: (controller) => controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              )
            : Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: controller.isPostingToApi
                                ? null
                                : () {
                                    showDialog(
                                      useSafeArea: true,
                                      context: context,
                                      builder: (context) {
                                        return SearchListDialog(
                                          title: "اختر عميل",
                                          originalData: controller.cusData.map((e) => SearchList(id: e.cusId, name: e.cusName)).toList(),
                                          onSelected: (selectedItem) => controller.onSelectCustomer(selectedItem.id),
                                        );
                                      },
                                    );
                                  },
                            child: Opacity(
                              opacity: !controller.isPostingToApi ? 1.0 : 0.5,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
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
                            onTap: controller.isPostingToApi
                                ? null
                                : () {
                                    Get.toNamed('/VisitPlan');
                                    // showDialog(
                                    //   useSafeArea: true,
                                    //   context: context,
                                    //   builder: (context) {
                                    //     return SearchListDialog(
                                    //       title: "عملاء خطة اليوم",
                                    //       originalData: controller.cusData.where((cus) => controller.userController.customersInVisitPlan.contains(cus.cusId)).map((e) => SearchList(id: e.cusId, name: e.cusName)).toList(),
                                    //       onSelected: (selectedItem) => controller.onSelectCustomer(selectedItem),
                                    //     );
                                    //   },
                                    // );
                                  },
                            child: Opacity(
                              opacity: !controller.isPostingToApi ? 1.0 : 0.5,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 8),
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
                                      "عميل حسب خطة السير",
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
                              opacity: !controller.isPostingToApi ? 1.0 : 0.5,
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
                                          child: controller.isPostingToApi
                                              ? Center(
                                                  child: CircularProgressIndicator(color: primaryColor),
                                                )
                                              : Row(
                                                  children: [
                                                    controller.isCustomerHasLocation
                                                        ? Expanded(
                                                            child: GestureDetector(
                                                              onTap: controller.makeCustomerVisit,
                                                              child: Container(
                                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                                decoration: BoxDecoration(
                                                                  color: primaryColor,
                                                                  border: Border.all(color: Colors.grey, width: 1),
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  shape: BoxShape.rectangle,
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "زيـــارة",
                                                                    style: TextStyle(
                                                                      color: Colors.white,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                    // textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : controller.newCustomerLocation != null
                                                            ? Expanded(
                                                                child: GestureDetector(
                                                                  onTap: controller.setCustomerNewLocation,
                                                                  child: Container(
                                                                    padding: EdgeInsets.symmetric(vertical: 8),
                                                                    decoration: BoxDecoration(
                                                                      color: primaryColor,
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
                                                                          "حفظ موقع العميل",
                                                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : Expanded(
                                                                child: Center(
                                                                  // heightFactor: 2,
                                                                  child: Text(
                                                                    "اضغط مطولاً على موقع العميل لحفظ الموقع والزيارة ",
                                                                    style: TextStyle(
                                                                      fontSize: 16,
                                                                      color: secondaryColor,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                    // textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                              ),
                                                  ],
                                                ),
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
                                    onPressed: controller.isPostingToApi
                                        ? null
                                        : () {
                                            controller.selecetdCustomer = null;
                                            controller.update();
                                          },
                                    icon: Icon(
                                      Icons.cancel_rounded,
                                      color: controller.isPostingToApi ? Colors.grey : secondaryColor,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                            child:
                                // controller.isLodingMap
                                //     ? Center(
                                //         child: CircularProgressIndicator(
                                //           color: primaryColor,
                                //         ),
                                //       )
                                //     :
                                FlutterMap(
                              mapController: controller.animatedMapController.mapController,
                              options: MapOptions(
                                // initialCenter: controller.latlang(23.8859, 45.0792), // Center of Saudi Arabia
                                // initialZoom: 5.5,
                                minZoom: 5,
                                maxZoom: 20,

                                // cameraConstraint: CameraConstraint.contain(
                                //   bounds: LatLngBounds(
                                //     controller.latlang(16.0, 34.0), // جنوب غرب السعودية
                                //     controller.latlang(33.0, 56.0), // شمال شرق السعودية
                                //   ),
                                // ),

                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all, // سحب + تكبير + تصغير
                                ),

                                onTap: (tapPosition, point) {
                                  controller.popupController.hideAllPopups();

                                  controller.animatedMapController.mapController.rotate(20);
                                  controller.update();
                                  print(point);
                                },
                                onLongPress: (tapPosition, point) => controller.putCustomerMarkerOnLongPress(point),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://maps.googleapis.com/maps/vt?lyrs=m&x={x}&y={y}&z={z}&style=feature:park|visibility:off&style=feature:road|visibility:off',
                                  additionalOptions: const {
                                    'key': 'AIzaSyBkqsPZ2r9abLw-NMgDsRbG_5bfl06TjeY',
                                  },
                                ),
                                PolygonLayer(
                                  polygons: [
                                    ...controller.polygons,
                                    // Polygon(
                                    //   points: controller.getSaudiPolygon(),
                                    //   borderColor: Colors.red,
                                    //   borderStrokeWidth: 2,
                                    //   color: Colors.transparent,
                                    // ),
                                  ],
                                ),
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
                                ),
                                CircleLayer(
                                  circles: <CircleMarker>[
                                    CircleMarker(point: controller.latlang(0.0, 0.0), radius: 0.0),
                                    if (controller.circulerMarker != null) controller.circulerMarker!,
                                  ],
                                ),
                                MarkerLayer(
                                  markers: [
                                    ...controller.defultmarker,
                                    if (controller.userMarker != null) controller.userMarker!,
                                    if (controller.customerMarker != null) controller.customerMarker!,

                                    if (controller.newCustomerMarker != null) controller.newCustomerMarker!,
                                    //  if (controller.customerLocation != null) controller.customerLocation!,
                                  ],
                                ),
                              ],
                            ),
                          ),
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
                                      itemCount: controller.cusCount.length,
                                      itemBuilder: (context, index) {
                                        String key = controller.cusCount.keys.elementAt(index);
                                        Map<String, dynamic> data = controller.cusCount[key]!;

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
                        //
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Card(
                            shape: StadiumBorder(),
                            child: IconButton(
                              padding: EdgeInsets.all(10),
                              onPressed: controller.setCurrentUserLocation,
                              icon: Icon(
                                Icons.gps_fixed_rounded,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
