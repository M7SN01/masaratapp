import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:location/location.dart';
import 'package:masaratapp/App/Controllers/login_controller.dart';
import 'package:masaratapp/App/Controllers/user_controller.dart';
import 'package:latlong2/latlong.dart' as lat_lang;
import 'package:masaratapp/App/Widget/widget.dart';
// import 'package:permission_handler/permission_handler.dart' as permission_handler;

import '../Models/user_model.dart';
import '../utils/utils.dart';

typedef LatLang = lat_lang.LatLng;

class VisitMapController extends GetxController with GetTickerProviderStateMixin {
  // MapController mapController = MapController();
  // late final MapController mapController;
  late final AnimatedMapController animatedMapController;
  //
  late UserController userController;
  late LoginController loginController;
  String? userId;
  String? userName;
  //
  CusDataModel? selecetdCustomer;
  List<CusDataModel> cusData = [];

  Position? userCurrentLocation;
  Marker? userMarker;
  Position? customerLocation;
  Marker? customerMarker;
//
  bool isPostingToApi = false;
  bool isPostedBefor = false;

  final PopupController popupController = PopupController();

  latlang(double lat, double lang) => LatLang(lat, lang);

  bool isExpandedMapKey = false;
  @override
  void onInit() {
    userController = Get.find<UserController>();
    loginController = Get.find<LoginController>();
    userId = loginController.logedInuserId;
    userName = loginController.logedInuserName;
    cusData = userController.cusDataList;
    //----
    //  mapController = MapController();
    animatedMapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userCurrentLocation = await getCurrentLocation();
      debugPrint(userCurrentLocation.toString());
      if (userCurrentLocation == null) {
        Get.back(); //close this page untill give location privileges
      } else {
        setCurrentUserLocation();
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    animatedMapController.dispose();
    super.onClose();
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
  Map<String, Map<String, dynamic>> cusCount = {};
  Map<String, Map<String, dynamic>> cusBalCount3MR = {};

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
    cusCount.clear();
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

      cusCount.update(
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

    totalCusCount = cusCount.values.map((data) => data["cus_count"] as int).fold(0, (sum, count) => sum + count);
    //
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

  //if private edit your location...
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnable = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnable) {
        // showMessage(color: secondaryColor, titleMsg: "خدمات الموقع معطلة", durationMilliseconds: 2000);
        Get.defaultDialog(
          title: "خدمات الموقع معطلة",
          middleText: "فتح الاعدادات لتفعيل خدمات الموقع",
          textConfirm: "تأكيد",
          textCancel: "الغاء",

          middleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          onConfirm: () {
            Get.back();
            Geolocator.openLocationSettings();
          },
          // onCancel: () {},
        );

        return null;
        // ShowMessage(context, Locales.string(context, "locationservicesdisabled"), Colors.red);
        // return Future.error("Locales.string(context, locationservicesdisabled)");
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // ShowMessage(context, Locales.string(context, "locationpermissiondisabled"), Colors.red);
          showMessage(color: secondaryColor, titleMsg: "امنح التطبيق صلاحيات استخدام موقعك", durationMilliseconds: 2000);
          // return Future.error("Locales.string(context, locationpermissiondisabled)");
          return null;
        } else if (permission == LocationPermission.deniedForever) {
          // ShowMessage(context, Locales.string(context, "locationpermissionsdenide"), Colors.red);
          // return Future.error("Locales.string(context, locationpermissionsdenide)");

          // showMessage(color: secondaryColor, titleMsg: "من الاعدادات امنح التطبيق صلاحيات استخدام موقعك", durationMilliseconds: 2000);

          Get.defaultDialog(
            title: "فتح الاعدادات لمنح صلاحيات استخدام الموقع",
            // middleText: "",
            textConfirm: "تأكيد",
            textCancel: "الغاء",

            middleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            onConfirm: () {
              Get.back();
              // permission_handler.openAppSettings();
              Geolocator.openAppSettings();
              // Geolocator.openLocationSettings();
            },
            // onCancel: () {},
          );

          return null;
        }
      } else if (permission == LocationPermission.deniedForever) {
        // ShowMessage(context, Locales.string(context, "locationpermissionsdenide"), Colors.red);
        // return Future.error("Locales.string(context, locationpermissionsdenide)");
        showMessage(color: secondaryColor, titleMsg: "امنح التطبيق صلاحيات استخدام موقعك", durationMilliseconds: 2000);
        return null;
      }
      // Geolocator.openAppSettings();
      // Geolocator.
    } catch (e) {
      userController.errorLog += "\n Erroe => while get device location  {{=($e)=}} \n";
    }

    return await Geolocator.getCurrentPosition();
  }

  CircleMarker? circulerMarker;
  setCurrentUserLocation() {
    // Position? position = await getCurrentLocation();
    if (userCurrentLocation != null) {
      double lat = userCurrentLocation!.latitude;
      double lng = userCurrentLocation!.longitude;
      animatedMapController.animateTo(
        dest: LatLang(lat, lng),
        zoom: 19,
      );

      circulerMarker = CircleMarker(
        point: LatLang(lat, lng), // your location
        radius: 20, // radius in METERS
        useRadiusInMeter: true,
        color: Colors.blue.withValues(alpha: 0.15),
        borderColor: Colors.blue,
        borderStrokeWidth: 2,
      );
      userMarker = Marker(
        // key: ValueKey("userMarker"),
        point: LatLang(lat, lng),
        child: Icon(
          Icons.location_pin,
          size: 30,
          color: Colors.blue,
        ),
      );
      update();
    }
  }

  get isCustomerHasLocation => selecetdCustomer?.latitude != null && selecetdCustomer?.longitude != null;

  onSelectCustomer(SearchList selectedItem) {
    customerMarker = null;
    newCustomerMarker = null;
    newCustomerLocation = null;

    selecetdCustomer = cusData.firstWhere((e) => e.cusId == selectedItem.id);

    if (isCustomerHasLocation) {
      customerMarker = Marker(
        // key: ValueKey("customerMarker"),
        point: LatLang(selecetdCustomer!.latitude!, selecetdCustomer!.longitude!),
        child: Icon(
          Icons.location_pin,
          size: 30,
          color: Colors.red,
        ),
      );

      animatedMapController.animatedFitCamera(
        cameraFit: CameraFit.coordinates(
          coordinates: [
            LatLang(selecetdCustomer!.latitude!, selecetdCustomer!.longitude!),
            LatLang(userCurrentLocation!.latitude, userCurrentLocation!.longitude),
          ],
          forceIntegerZoomLevel: true, //to fit both two marker in the map
        ),
      );
    }

    update();
    Get.back();
  }

//

  double getDistanceInMeter(double latitude, double longitude) {
    return Geolocator.distanceBetween(latitude, longitude, userCurrentLocation!.latitude, userCurrentLocation!.longitude);
  }

  void makeCustomerVisit() {
    if (isCustomerHasLocation) {
      double distance = getDistanceInMeter(selecetdCustomer!.latitude!, selecetdCustomer!.longitude!);
      if (distance <= 20) {
        //Do visit Logic
/**************************************************************** */
        update();
      } else {
        showMessage(color: secondaryColor, titleMsg: "يجب ان تكون قريب من موقع العميل كحد اقصى 20 متر", durationMilliseconds: 2000);
      }
    }
  }

  Marker? newCustomerMarker;
  LatLang? newCustomerLocation;
  putCustomerMarkerOnLongPress(LatLang selectedLocation) {
    if (isCustomerHasLocation) {
      showMessage(color: secondaryColor, titleMsg: "موقع العميل تم حفظة مسبقاً", durationMilliseconds: 2000);
      return null;
    }

    if (userCurrentLocation != null) {
      final double lat = selectedLocation.latitude;
      final double lang = selectedLocation.longitude;
      double distance = getDistanceInMeter(lat, lang);
      if (distance <= 20) {
        newCustomerLocation = LatLang(lat, lang);
        newCustomerMarker = Marker(
          // key: ValueKey("customerMarker"),
          point: LatLang(lat, lang),
          child: Icon(
            Icons.location_pin,
            size: 30,
            color: Colors.red,
          ),
        );
        update();
      } else {
        showMessage(color: secondaryColor, titleMsg: "يجب ان تكون قريب من موقع العميل كحد اقصى 20 متر", durationMilliseconds: 2000);
      }
      // debugPrint("the distance is : $distance");
    }
  }

  void setCustomerNewLocation() {
    if (isCustomerHasLocation) return;
    debugPrint("On Save new Location for Customer");
    // post the cordnite to server if done => enable visit button
    /**************************************************************** */
  }
}
