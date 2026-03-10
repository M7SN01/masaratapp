import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../../utils/utils.dart';

class CustomersAgingColumns {
  // get slsCntrController => Get.find<SlsCenterController>();

  get getColumns {
    return [
      PlutoColumn(
        title: "CUS_ID_COL".tr,
        field: 'CUS_ID',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.number(format: '#######'),
        backgroundColor: primaryColor,
        suppressedAutoSize: true,
        enableEditingMode: false,
      ),
      PlutoColumn(
        title: "CUS_NAME_COL".tr,
        field: 'CUS_NAME',
        textAlign: PlutoColumnTextAlign.center,
        titleTextAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        backgroundColor: primaryColor,
        suppressedAutoSize: true,
        enableEditingMode: false,
        // footerRenderer: (rendererContext) {
        //   return Center(
        //     child: Text(
        //       "TOTAL_COL_FOOTER".tr,
        //       style: const TextStyle(color: Colors.white),
        //     ),
        //   );
        // },
      ),
      buildColumn(title: "A30"),
      buildColumn(title: "A60"),
      buildColumn(title: "A90"),
      buildColumn(title: "A120"),
      buildColumn(title: "A150"),
      buildColumn(title: "A180"),
      buildColumn(title: "A0"),
      buildColumn(title: "A00"),
      buildColumn(title: "BAL"),
      buildColumn(title: "AP"),
    ];
  }
}

PlutoColumn buildColumn({required String title}) {
  return PlutoColumn(
    title: "${title}_COL".tr,
    field: title,
    textAlign: PlutoColumnTextAlign.center,
    titleTextAlign: PlutoColumnTextAlign.center,
    type: PlutoColumnType.currency(format: '#,###.##'),
    backgroundColor: primaryColor,
    suppressedAutoSize: true,
    enableEditingMode: false,
  );
}
