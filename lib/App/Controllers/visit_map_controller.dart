import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:masaratapp/App/Controllers/login_controller.dart';
import 'package:masaratapp/App/Controllers/user_controller.dart';
import 'package:latlong2/latlong.dart' as latLngPackage;

import '../Models/user_model.dart';

typedef LatLang = latLngPackage.LatLng;

class VisitMapController extends GetxController {
  late UserController userController;
  late LoginController loginController;
  String? userId;
  String? userName;
  //
  CusDataModel? selecetdCustomer;
  List<CusDataModel> cusData = [];
//
  bool isPostingToApi = false;
  bool isPostedBefor = false;

  final PopupController popupController = PopupController();

  latlang(dynamic lat, dynamic lang) => LatLang(21.502988278492147, 39.18250154703856);

  bool isExpandedMapKey = false;
  @override
  void onInit() {
    userController = Get.find<UserController>();
    loginController = Get.find<LoginController>();
    userId = loginController.logedInuserId;
    userName = loginController.logedInuserName;
    cusData = userController.cusDataList;
    super.onInit();
  }

  //
  //
  //

  Widget cusInfoWindo(CusDataModel element) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(element.cusId.toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

        Text(element.cusName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

        // if (showOrHide("BP_MST_NAME")) Text(element["BP_MST_NAME"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        // if (showOrHide("BALANCE")) Text("${currentLang["MRKR_BAL"] ?? "MRKR_BAL"} : ${element["BALANCE"].toString() == "null" ? "" : element["BALANCE"].toString()}"),
        // if (showOrHide("INVCOUNT")) Text("${currentLang["MRKR_INV_COUNT"] ?? "MRKR_INV_COUNT"} : ${element["INVCOUNT"].toString() == "null" ? "" : element["INVCOUNT"].toString()}"),
        // if (showOrHide("LAST_INV_DATE")) Text("${currentLang["MRKR_LAST_INV_DATE"] ?? "MRKR_LAST_INV_DATE"} : ${element["LAST_INV_DATE"].toString() == "null" ? "" : element["LAST_INV_DATE"].toString()}"),
        // if (showOrHide("INV_TTL")) Text("${currentLang["MRKR_SLS_VAL"] ?? "MRKR_SLS_VAL"} : ${element["INV_TTL"].toString() == "null" ? "" : element["INV_TTL"].toString()}"),
        // if (showOrHide("GP")) Text("${currentLang["MRKR_GAIN"] ?? "MRKR_GAIN"} : ${element["GP"].toString() == "null" ? "" : element["GP"].toString()}"),
        // if (showOrHide("SADAD")) Text("${currentLang["MRKR_TTL_PAY"] ?? "MRKR_TTL_PAY"} : ${element["SADAD"].toString() == "null" ? "" : element["SADAD"].toString()}"),
        // if (showOrHide("LAST_SADAD_DATE")) Text("${currentLang["MRKR_LAST_PAY_DATE"] ?? "MRKR_LAST_PAY_DATE"} : ${element["LAST_SADAD_DATE"].toString() == "null" ? "" : element["LAST_SADAD_DATE"].toString()}"),
        // if ((element["MBL"].toString() != "null" || element["TEL1"].toString() != "null" || element["TEL2"].toString() != "null") && showOrHide("MBL")) ...[
        //   Text("${currentLang["MBL_NUM"] ?? "MBL_NUM"}: ${element["MBL"].toString() == "null" ? "" : element["MBL"].toString()} , ${element["TEL1"].toString() == "null" ? "" : element["TEL1"].toString()} , ${element["TEL2"].toString() == "null" ? "" : element["TEL2"].toString()}"),
        // ],

        const SizedBox(
          height: 5,
        ),
        //
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () {
                // openMap(element["LATITUDE"], element["LONGITUDE"]);
              },
              icon: const Icon(Icons.assistant_direction_sharp),
              label: const Text(""),
            ),
            if (element.mobl.toString() != "null") ...[
              TextButton.icon(
                onPressed: () {
                  // openPhone(element["MBL"].toString());
                },
                icon: const Icon(Icons.phone_android_outlined),
                label: const Text(""), // element["MBL"].toString()
              ),
            ],
            if (element.mobl.toString() != "null") ...[
              TextButton.icon(
                onPressed: () {
                  // openPhone(element["TEL1"].toString());
                },
                icon: const Icon(Icons.call),
                label: const Text(""), // element["MBL"].toString()
              ),
            ],
          ],
        ),
      ],
    );
  }

  List<Marker> defultmarker = [];
  List<Polygon> polygons = [];
  Map<String, Map<String, dynamic>> cus_count = {};
  Map<String, Map<String, dynamic>> cusBalCount3MR = {};

  getdata() async {
    try {
      String stmt = "";
      String date = "";

      // if (selected3mr != "") {
      //   await buildMarkerCusDebt(responeData);
      // } else if (selectedBestCus != "" || fromBestCusController.text != "" || toBestCusController.text != "") {
      //   await buildMarkerBestCus(responeData);
      // } else {
      //   await buildMarkerAndPolygon(responeData);
      // }

      // setState(() {
      //   defultmarker;
      //   loadingData = false;
      // });
    } catch (e) {
      // errorCallBack(e.toString());
    }
  }

  Map<Key, Widget> infoWindow = {};
  Map<Key, String> accIdInfo = {};
  Map<Key, String> cusName = {};

  Map<Key, String> cusIds = {};

  int totalCusCount = 0;

  buildMarkerAndPolygon() {
    isExpandedMapKey = false;
    totalCusCount = 0;

    // reset state
    defultmarker.clear();
    polygons.clear();
    cus_count.clear();
    cusIds.clear();
    cusName.clear();
    infoWindow.clear();
    update();

    List<String> ids = [];
    Map<String, List<LatLang>> polygonsPoints = {};

    //making every sls_man_id with list of all his customers points on the map
    for (var element in cusData) {
      if (element.slsManId == null || element.slsManId == 0) continue;
      if (element.latitude == null || element.longitude == null || (element.latitude == 0 && element.longitude == 0)) continue;

      final id = element.slsManId.toString();

      // Initialize the list of LatLng if it doesn't exist for the current SLS_MAN_ID and add to ids list
      final list = polygonsPoints.putIfAbsent(id, () {
        ids.add(id); // Only added the FIRST time when go in putIfAbsent
        return <LatLang>[];
      });

      // Add the LatLng point to the list for the current SLS_MAN_ID
      list.add(LatLang(element.latitude!, element.longitude!));
    }

    final List<Color> colors = [
      // Colors.red, any cus without SLS_MAN_ID
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      // Colors.red,
      Colors.indigo,
      Colors.cyan,
      Colors.amber,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.lime,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
      Colors.white,
      Colors.green,
      Colors.yellow,

      // Colors.blueAccent,
      // Colors.lightBlueAccent,
      // Colors.greenAccent,
      // Colors.tealAccent,
      // Colors.yellowAccent,
      // Colors.amberAccent,
      // Colors.orangeAccent,
      // Colors.deepOrangeAccent,
      // Colors.redAccent,
      // Colors.pinkAccent,
      // Colors.purpleAccent,
      // Colors.deepPurpleAccent,
      // Colors.indigoAccent,
      // Colors.lightGreenAccent,
      // Colors.limeAccent,
    ];

    Map<String, Color> markerColor = {};
    //single color for every sls_man id
    for (int i = 0; i < ids.length; i++) {
      markerColor[ids[i]] = colors[i % colors.length];
    }

    for (var element in cusData) {
      final lat = element.latitude;
      final lng = element.longitude;
      final cusId = element.cusId;

      // Skip invalid coordinates only
      if (lat == null || lng == null || (lat == 0 && lng == 0)) continue;
      // debugPrint("$cusId     --   $lat      ---  $lng");
      final color = (element.slsManId == null)
          ? Colors.red // customers without salesman
          : markerColor[element.slsManId.toString()] ?? Colors.red;

      //marker
      defultmarker.add(
        Marker(
          key: ValueKey(cusId),
          point: LatLang(lat, lng),
          child: Icon(
            Icons.location_pin,
            size: 30,
            color: color,
          ),
        ),
      );

      //fill sls man and customer count card
      final slsKey = element.slsManId?.toString() ?? 'NO_SLS';

      final key = ValueKey(cusId);

      // accIdInfo[Key(element["BP_MST_ID"].toString() + element["SLS_MAN_ID"].toString())] = element["ACC_ID"].toString();
      cusIds[key] = element.cusId.toString();
      cusName[key] = element.cusName;
      infoWindow[key] = cusInfoWindo(element);

      cus_count.update(
        slsKey,
        (data) {
          final current = data['cus_count'] as int? ?? 0;
          return {
            ...data,
            'cus_count': current + 1,
          };
        },
        ifAbsent: () => {
          'name': element.slsManId.toString(),
          'color': markerColor[element.slsManId?.toString()] ?? Colors.red,
          'cus_count': 1,
        },
      );
      // if (cus_count.containsKey(element.slsManId.toString())) {
      //   cus_count[element.slsManId.toString()]!["cus_count"] = (cus_count[element.slsManId.toString()]!["cus_count"]) + 1;
      // } else {
      //   cus_count[element.slsManId.toString()] = {
      //     "name": element.cusName.toString(),
      //     "color": markerColor[element.slsManId.toString()],
      //     "cus_count": 1,
      //   };
      // }
    }

    //Build polygons
    for (final entry in polygonsPoints.entries) {
      final id = entry.key;
      final points = getConvexHull(entry.value);
      final color = markerColor[id] ?? Colors.red;

      if (points.isEmpty) continue;

      polygons.add(
        Polygon(
          points: points,
          // points: optimizeRoute(polygonsPoints[element["SLS_MAN_ID"].toString()] ?? []),
          color: color.withValues(alpha: 0.2),
          pattern: const StrokePattern.solid(), borderStrokeWidth: 0.2,

          // isFilled: true,
          // label: element["FULL_NAME"].toString(),
          // labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
          borderColor: color,
        ),
      );
    }

    defultmarker;
    totalCusCount = cus_count.values.map((data) => data["cus_count"] as int).fold(0, (sum, count) => sum + count);
    //
    update();
  }

  buildMarkerBestCus(List<dynamic> responeData) async {
    // showInfDt("Bst");
    // defultmarker.clear();
    // cusIds.clear();
    // for (int i = 0; i < responeData.length; i++) {
    //   bool from = fromBestCusController.text != "";
    //   bool to = toBestCusController.text != "";
    //   bool showIndex = false;
    //   if (from && i + 1 >= int.parse(fromBestCusController.text) && to && i + 1 <= int.parse(toBestCusController.text)) {
    //     showIndex = true;
    //   }
    //   if (!from && to && i + 1 <= int.parse(toBestCusController.text)) {
    //     showIndex = true;
    //   }
    //   if (from && i + 1 >= int.parse(fromBestCusController.text) && !to) {
    //     showIndex = true;
    //   }
    //   if (selectedBestCus != "" && i < int.parse(selectedBestCus)) {
    //     showIndex = true;
    //   }

    //   if (showIndex) {
    //     defultmarker.add(
    //       Marker(
    //         key: Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString()),
    //         point: LatLang(responeData[i]["LATITUDE"], responeData[i]["LONGITUDE"]),
    //         child: badges.Badge(
    //           badgeContent: Text(
    //             (i + 1).toString(),
    //             style: const TextStyle(color: Colors.white, fontSize: 12),
    //           ),
    //           child: const Icon(size: 30, Icons.location_pin, color: Colors.red),
    //         ),
    //       ),
    //     );
    //     accIdInfo[Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString())] = responeData[i]["ACC_ID"].toString();
    //     cusIds[responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString()] = responeData[i]["BP_MST_ID"].toString();
    //     cusName[Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString())] = responeData[i]["BP_MST_NAME"].toString();
    //     infoWindow[Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString())] = cusInfoWindo(responeData[i]);

    //     // if (i == int.parse(customBestCusController.text != "" ? customBestCusController.text : selectedBestCus) * 2) {
    //     //   break;
    //     // }
    //     // if (i == int.parse(customBestCusController.text != "" ? customBestCusController.text : selectedBestCus) - 1) {
    //     //   break;
    //     // }
    //   }
    // }
  }

  calcluate3MR(String _3mr, var element, Color color) {
    //fill sls man and customer count card
    // try {
    //   if (cusBalCount3MR.containsKey(_3mr)) {
    //     // print("add 3mr");
    //     if (cusBalCount3MR[_3mr]!.containsKey(element["SLS_MAN_ID"].toString())) {
    //       // print("add sls man  ${cusBalCount3MR[_3mr]![element["SLS_MAN_ID"].toString()]["cus_count"]}");
    //       cusBalCount3MR[_3mr]![element["SLS_MAN_ID"].toString()]["cus_count"] = cusBalCount3MR[_3mr]![element["SLS_MAN_ID"].toString()]["cus_count"] + 1;
    //       cusBalCount3MR[_3mr]![element["SLS_MAN_ID"].toString()]["BAL"] = double.parse(element["BALANCE"].toString() == "null" ? "0" : element["BALANCE"].toString()) + cusBalCount3MR[_3mr]![element["SLS_MAN_ID"].toString()]["BAL"];
    //     } else {
    //       // print("new sls man");
    //       cusBalCount3MR[_3mr]![element["SLS_MAN_ID"].toString()] = {
    //         "name": element["FULL_NAME"].toString(),
    //         "BAL": double.parse(element["BALANCE"].toString() == "null" ? "0" : element["BALANCE"].toString()),
    //         "color": color,
    //         "cus_count": 1,
    //       };
    //     }
    //   } else {
    //     // print("new 3mr");
    //     cusBalCount3MR[_3mr] = {
    //       element["SLS_MAN_ID"].toString(): {
    //         "name": element["FULL_NAME"].toString(),
    //         "BAL": double.parse(element["BALANCE"].toString() == "null" ? "0" : element["BALANCE"].toString()),
    //         "color": color,
    //         "cus_count": 1,
    //       }
    //     };
    //   }
    // } catch (e) {
    //   // print(e);
    // }
  }

  Color? periodColor(var element) {
    if (element["> 0 - 30"] == "null" ? 0 : element["> 0 - 30"] > 0) {
      calcluate3MR("> 0 - 30", element, Colors.green);
      return Colors.green;
    }
    if (element["> 30 - 60"] == "null" ? 0 : element["> 30 - 60"] > 0) {
      calcluate3MR("> 30 - 60", element, Colors.blue);
      return Colors.blue;
    }
    if (element["> 60 - 90"] == "null" ? 0 : element["> 60 - 90"] > 0) {
      calcluate3MR("> 60 - 90", element, Colors.yellow);
      return Colors.yellow;
    }
    if (element["> 90 - 120"] == "null" ? 0 : element["> 90 - 120"] > 0) {
      calcluate3MR("> 90 - 120", element, Colors.orange);
      return Colors.orange;
    }
    if (element["> 120 - 150"] == "null" ? 0 : element["> 120 - 150"] > 0) {
      calcluate3MR("> 120 - 150", element, Colors.red);
      return Colors.red;
    }
    if (element["> 150"] == "null" ? 0 : element["> 150"] > 0) {
      calcluate3MR("> 150", element, Colors.black);
      return Colors.black;
    }

    // calcluate3MR("other", element, Colors.transparent);
    return null; //Colors.transparent; //who his BALANCE = 0
  }

  buildMarkerCusDebt(List<dynamic> responeData) async {
    // defultmarker.clear();
    // cusIds.clear();
    // cusBalCount3MR.clear();
    // totalCusCount = 0;
    // if (selected3mr == (currentLang["3MR_ALL"] ?? "3MR_ALL")) {
    //   showInfDt("3mr");
    //   for (int i = 0; i < responeData.length; i++) {
    //     var color = periodColor(responeData[i]);
    //     if (color != null) {
    //       // if out of period dont add the marker
    //       defultmarker.add(
    //         Marker(
    //           key: Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString()),
    //           point: LatLang(responeData[i]["LATITUDE"], responeData[i]["LONGITUDE"]),
    //           child: badges.Badge(
    //             badgeStyle: badges.BadgeStyle(
    //               badgeColor: color,
    //             ),
    //             badgeContent: Text(
    //               (i + 1).toString(),
    //               style: const TextStyle(color: Colors.white, fontSize: 12),
    //             ),
    //             child: Icon(size: 30, Icons.location_pin, color: color),
    //           ),
    //           // Icon(Icons.location_pin, size: 30, color: color),
    //         ),
    //       );
    //       accIdInfo[Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString())] = responeData[i]["ACC_ID"].toString();
    //       cusIds[responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString()] = responeData[i]["BP_MST_ID"].toString();
    //       cusName[Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString())] = responeData[i]["BP_MST_NAME"].toString();
    //       infoWindow[Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString())] = cusInfoWindo(responeData[i]);
    //     }
    //   }
    // } else {
    //   showInfDt("3mr");
    //   for (int i = 0; i < responeData.length; i++) {
    //     if (responeData[i][selected3mr] == "null" ? 0 : responeData[i][selected3mr] > 0) {
    //       calcluate3MR(selected3mr, responeData[i], Colors.red);
    //       defultmarker.add(
    //         Marker(
    //           key: Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString()),
    //           point: LatLang(responeData[i]["LATITUDE"], responeData[i]["LONGITUDE"]),
    //           child: badges.Badge(
    //             badgeContent: Text(
    //               (i + 1).toString(),
    //               style: const TextStyle(color: Colors.white, fontSize: 12),
    //             ),
    //             child: const Icon(size: 30, Icons.location_pin, color: Colors.red),
    //           ),
    //           //const Icon(Icons.location_pin, size: 30, color: Colors.red),
    //         ),
    //       );
    //       accIdInfo[Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString())] = responeData[i]["ACC_ID"].toString();
    //       cusIds[responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString()] = responeData[i]["BP_MST_ID"].toString();
    //       cusName[Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString())] = responeData[i]["BP_MST_NAME"].toString();
    //       infoWindow[Key(responeData[i]["BP_MST_ID"].toString() + responeData[i]["SLS_MAN_ID"].toString())] = cusInfoWindo(responeData[i]);
    //     }
    //   }
    // }
    // totalCusCount = cusBalCount3MR.values.map((data) => data.values.map((e) => e["cus_count"] as int).fold(0, (sum, count) => sum + count)).fold(0, (sum, count) => sum + count);
    // // cusBalCount3MR;
  }

  int visitAndSel = 0;
  int visitOnly = 0;
  int noVisit = 0;
  int visitOutPlan = 0;
  getVisitData() async {
    // setState(() {
    //   loadingData = true;
    //   visitAndSel = 0;
    //   visitOnly = 0;
    //   noVisit = 0;
    //   visitOutPlan = 0;
    //   optionShow = false;
    // });
    // showInfDt("vst");
    // String date = "";
    // if (_fromDateController.text.isNotEmpty && _toDateController.text.isNotEmpty) {
    //   date = " AND A.VISIT_DATE BETWEEN TO_DATE('${_fromDateController.text}','YYYY-MM-DD') AND TO_DATE('${_toDateController.text}', 'YYYY-MM-DD') ";
    // }
    // // else
    // if ((_fromDateController.text.isNotEmpty && _toDateController.text.isEmpty) || (_fromDateController.text == _toDateController.text)) {
    //   // date = "  TO_CHAR(A.VISIT_DATE,'YYYY-MM-DD') = '${_fromDateController.text}'  ";
    //   date = "AND (TO_CHAR(A.VISIT_DATE,'YYYY-MM-DD') = '${_fromDateController.text}'   OR (DAY1 =${DateTime.parse(_fromDateController.text).weekday + 1} ) )";
    //   // "AND (TO_CHAR(A.VISIT_DATE,'YYYY-MM-DD') = '${_fromDateController.text}'   OR (DAY1 =${DateTime.parse(_fromDateController.text).weekday + 1} ) )";
    // } else {
    //   date = "";
    // }
    // String stmt =
    //     """SELECT (SELECT ACC_CLASS_ID||ACC_MST_ID FROM $selectedSCH.ACC_POST_DT_V WHERE BP_MST_ID = A.BP_MST_ID AND ACC_CLASS_ID= 'C' AND COMP_ID='$selectedCompId' group by ACC_MST_ID,ACC_CLASS_ID ) ACC_ID,A.BP_MST_ID ,  B.BP_MST_NAME ,B.MBL,B.TEL1,B.TEL2  ,A.SLS_MAN_ID, (select FULL_NAME from ORCA.user1 where   SLS_MAN_ID = A.SLS_MAN_ID ) FULL_NAME ,MAX(A.VISIT_DATE) VISIT_DATE, (select MAX(y.VISIT_TYPE)  FROM  ORCA.BP_VISIT_ACT_CALC_V y  where y.VISIT_DATE = (select  MAX(x.VISIT_DATE) FROM  ORCA.BP_VISIT_ACT_CALC_V x  where x.BP_MST_ID=y.BP_MST_ID  )  AND  y.BP_MST_ID= A.BP_MST_ID  )  VISIT_TYPE ,(Select COUNT(VISIT_DATE) from ORCA.BP_VISIT_ACT_CALC_V where BP_MST_ID = A.BP_MST_ID ) VISIT_CNT,C.DAY1,B.LATITUDE,B.LONGITUDE FROM ORCA.BP_VISIT_ACT_CALC_V A,ORCA.BP_MST B ,ORCA.BP_VISIT C where A.BP_MST_ID=B.BP_MST_ID AND A.BP_MST_ID=C.BP_MST_ID
    // ${_selectedslsMan == "" ? "" : " AND A.SLS_MAN_ID in ( $_selectedslsMan )"}
    // $date
    // AND B.LATITUDE IS NOT NULL AND
    // B.LONGITUDE  IS NOT NULL group by   A.BP_MST_ID ,  B.BP_MST_NAME ,B.MBL,B.TEL1,B.TEL2  ,A.SLS_MAN_ID, LATITUDE , LONGITUDE ,DAY1
    // """;
    // // print(stmt);
    // List<dynamic> responeData = await services.readData(sqlStatment: stmt, errorCallback: (error) => errorCallBack("$error "));

    // defultmarker.clear();
    // cusIds.clear();
    // cus_count.clear();
    // for (var element in responeData) {
    //   defultmarker.add(
    //     Marker(
    //       key: Key(element["BP_MST_ID"].toString() + element["SLS_MAN_ID"].toString()),
    //       point: LatLang(element["LATITUDE"], element["LONGITUDE"]),
    //       child: Icon(Icons.location_pin, size: 30, color: visitColor(element)),
    //     ),
    //   );
    //   accIdInfo[Key(element["BP_MST_ID"].toString() + element["SLS_MAN_ID"].toString())] = element["ACC_ID"].toString();
    //   cusIds[element["BP_MST_ID"].toString() + element["SLS_MAN_ID"].toString()] = element["BP_MST_ID"].toString();
    //   cusName[Key(element["BP_MST_ID"].toString() + element["SLS_MAN_ID"].toString())] = element["BP_MST_NAME"].toString();
    //   infoWindow[Key(element["BP_MST_ID"].toString() + element["SLS_MAN_ID"].toString())] = Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       if (element["FULL_NAME"].toString() != "null") ...[
    //         Text(element["FULL_NAME"].toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    //       ],
    //       Text(element["BP_MST_NAME"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    //       Text("${currentLang["LAST_VST"] ?? "LAST_VST"} : ${element["VISIT_DATE"].toString() == "null" ? "" : DateFormat('dd-MM-yyyy hh:mm:ss').format(DateTime.parse(element["VISIT_DATE"].toString()))}"),
    //       Text("${currentLang["VST_COUNT"] ?? "VST_COUNT"}  : ${element["VISIT_CNT"].toString() == "null" ? "" : element["VISIT_CNT"].toStringAsFixed(0)}"),
    //       Text("${currentLang["SIR_PLAN"] ?? "SIR_PLAN"} : ${element["DAY1"].toString() == "null" ? "" : getday(element["DAY1"].toStringAsFixed(0))}"),
    //       if (element["MBL"].toString() != "null" || element["TEL1"].toString() != "null" || element["TEL2"].toString() != "null") ...[
    //         Text("${currentLang["MBL_NUM"] ?? "MBL_NUM"} : ${element["MBL"].toString() == "null" ? "" : element["MBL"].toString()} , ${element["TEL1"].toString() == "null" ? "" : element["TEL1"].toString()} , ${element["TEL2"].toString() == "null" ? "" : element["TEL2"].toString()}"),
    //       ],

    //       const SizedBox(
    //         height: 5,
    //       ),
    //       //
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           TextButton.icon(
    //             onPressed: () {
    //               openMap(element["LATITUDE"], element["LONGITUDE"]);
    //             },
    //             icon: const Icon(Icons.assistant_direction_sharp),
    //             label: const Text(""),
    //           ),
    //           if (element["MBL"].toString() != "null") ...[
    //             TextButton.icon(
    //               onPressed: () {
    //                 openPhone(element["MBL"].toString());
    //               },
    //               icon: const Icon(Icons.phone_android_outlined),
    //               label: const Text(""), // element["MBL"].toString()
    //             ),
    //           ],
    //           if (element["TEL1"].toString() != "null") ...[
    //             TextButton.icon(
    //               onPressed: () {
    //                 openPhone(element["TEL1"].toString());
    //               },
    //               icon: const Icon(Icons.call),
    //               label: const Text(""), // element["MBL"].toString()
    //             ),
    //           ],
    //         ],
    //       ),
    //     ],
    //   );
    // }

    // // visitAndSel = cus_count.values.map((data) => data["visitAndSel"] as int).fold(0, (sum, count) => sum + count);
    // // visitOnly = cus_count.values.map((data) => data["visitOnly"] as int).fold(0, (sum, count) => sum + count);
    // setState(() {
    //   loadingData = false;
    // });
  }

  Color visitColor(var element) {
    // print(element["VISIT_TYPE"].toStringAsFixed(0));
    // bool maxVisitDateEqualSelectedDate = DateFormat('yyy-MM-dd').format(DateTime.parse(element["VISIT_DATE"].toString())) == _fromDateController.text;
    // bool selectedDayEqualDAY1 = element["DAY1"] != "null"
    //     ? _fromDateController.text.isNotEmpty
    //         ? element["DAY1"] == DateTime.parse(_fromDateController.text).weekday + 1
    //         : false
    //     : false;

    // if (element["VISIT_TYPE"] != "null" ? element["VISIT_TYPE"].toStringAsFixed(0) == "1" && maxVisitDateEqualSelectedDate && selectedDayEqualDAY1 : false) {
    //   visitAndSel++;
    //   if (cus_count.containsKey(element["SLS_MAN_ID"].toString())) {
    //     cus_count[element["SLS_MAN_ID"].toString()]!["visitAndSel"] = (cus_count[element["SLS_MAN_ID"].toString()]!["visitAndSel"]) + 1;
    //   } else {
    //     cus_count[element["SLS_MAN_ID"].toString()] = {
    //       "name": element["FULL_NAME"].toString(),
    //       "visitOnly": 0,
    //       "visitAndSel": 1,
    //       "noVisit": 0,
    //       "visitOutPlan": 0,
    //     };
    //   }
    //   // print(element["FULL_NAME"].toString() + "   S   ");
    //   return Colors.blue;
    // } else if (element["VISIT_TYPE"] != "null" ? element["VISIT_TYPE"].toStringAsFixed(0) == "0" && maxVisitDateEqualSelectedDate && selectedDayEqualDAY1 : false) {
    //   visitOnly++;
    //   if (cus_count.containsKey(element["SLS_MAN_ID"].toString())) {
    //     cus_count[element["SLS_MAN_ID"].toString()]!["visitOnly"] = (cus_count[element["SLS_MAN_ID"].toString()]!["visitOnly"]) + 1;
    //   } else {
    //     cus_count[element["SLS_MAN_ID"].toString()] = {
    //       "name": element["FULL_NAME"].toString(),
    //       "visitOnly": 1,
    //       "visitAndSel": 0,
    //       "noVisit": 0,
    //       "visitOutPlan": 0,
    //     };
    //   }
    //   // print(element["FULL_NAME"].toString() + "   V   ");
    //   return Colors.green;
    // } else if (!selectedDayEqualDAY1 && maxVisitDateEqualSelectedDate) {
    //   visitOutPlan++;
    //   if (cus_count.containsKey(element["SLS_MAN_ID"].toString())) {
    //     cus_count[element["SLS_MAN_ID"].toString()]!["visitOutPlan"] = (cus_count[element["SLS_MAN_ID"].toString()]!["visitOutPlan"]) + 1;
    //   } else {
    //     cus_count[element["SLS_MAN_ID"].toString()] = {
    //       "name": element["FULL_NAME"].toString(),
    //       "visitOnly": 1,
    //       "visitAndSel": 0,
    //       "noVisit": 0,
    //       "visitOutPlan": 1,
    //     };
    //   }
    //   // print(element["FULL_NAME"].toString() + "   V   ");
    //   return Colors.yellow;
    // } else {
    //   noVisit++;
    //   if (cus_count.containsKey(element["SLS_MAN_ID"].toString())) {
    //     cus_count[element["SLS_MAN_ID"].toString()]!["noVisit"] = (cus_count[element["SLS_MAN_ID"].toString()]!["noVisit"]) + 1;
    //   } else {
    //     cus_count[element["SLS_MAN_ID"].toString()] = {
    //       "name": element["FULL_NAME"].toString(),
    //       "visitOnly": 1,
    //       "visitAndSel": 0,
    //       "noVisit": 0,
    //       "visitOutPlan": 0,
    //     };
    //   }
    return Colors.red;
    // }
  }

  String getday(String dayNumber) {
    DateTime now = DateTime.now();
    // Adjust the current date to the specific day of the week
    DateTime targetDate = now.add(Duration(days: (int.parse(dayNumber) - now.weekday) % 7));
    // Set the locale to Arabic
    var formatter = DateFormat('EEEE', 'ar');
    // Format the target date to get the day name in Arabic
    return formatter.format(targetDate);
  }

  bool showCountDt = false;
  bool showVisitInfo = false;
  bool show3MrInf = false;
  bool showBestCus = false;

  showInfDt(String whatToShow) {
    if (whatToShow == "cnt") {
      showCountDt = true;
    } else {
      showCountDt = false;
    }

    if (whatToShow == "vst") {
      showVisitInfo = true;
    } else {
      showVisitInfo = false;
    }

    if (whatToShow == "3mr") {
      show3MrInf = true;
    } else {
      show3MrInf = false;
    }
    if (whatToShow == "Bst") {
      showBestCus = true;
    } else {
      showBestCus = false;
    }

    whatToShow;
    showVisitInfo;
    show3MrInf;
    showBestCus;
    update();
  }

// Graham scan algorithm to find the convex hull
  List<LatLang> getConvexHull(List<LatLang> points) {
    // Sort points by x-coordinate
    points.sort((a, b) => a.longitude.compareTo(b.longitude));

    final List<LatLang> lower = [];
    for (final point in points) {
      while (lower.length >= 2 && _cross(lower[lower.length - 2], lower[lower.length - 1], point) <= 0) {
        lower.removeLast();
      }
      lower.add(point);
    }

    final List<LatLang> upper = [];
    for (final point in points.reversed) {
      while (upper.length >= 2 && _cross(upper[upper.length - 2], upper[upper.length - 1], point) <= 0) {
        upper.removeLast();
      }
      upper.add(point);
    }

    lower.removeLast();
    upper.removeLast();
    lower.addAll(upper);
    return lower;
  }

// Cross product of vectors OA and OB
  double _cross(LatLang O, LatLang A, LatLang B) {
    return (A.longitude - O.longitude) * (B.latitude - O.latitude) - (A.latitude - O.latitude) * (B.longitude - O.longitude);
  }
}
