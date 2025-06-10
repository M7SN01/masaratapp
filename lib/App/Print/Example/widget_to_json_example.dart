import 'package:intl/intl.dart';

import '../helpers/widgets_to_json.dart';

Map mapData =
// {
//   "type": "scaffold",
//   "args": {
// "appBar": {
//   "type": "app_bar",
//   "args": {
//     "title": {
//       "type": "text",
//       "args": {"text": "Rendering UI Through JSON Data"}
//     }
//   }
// },
// "body":
containerW(
  width: mmToPixel(80),
  // height: 500,
  padding: [10, 10, 10, 10],
  // margin: [10, 10, 10, 10],
  containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(color: "#6d78b6", width: 1), radius: 8, color: "#ffffff"),
  child:
  // {
  // "type": "single_child_scroll_view",
  // "args": {
  //   "child":
  columnW(
    crossAxisAlignment: "center",
    children: [
      imageW(height: 100, width: 100, assetName: "assets/images/logo.png"),

      textW("فاتورة ضريبية مبسطة", fontSize: 24, textAlign: "center", fontWeight: "bold"),
      textW("شركة المطري", fontSize: 20, textAlign: "center"),
      sizedBoxW(height: 5),
      textW("الرقم الضريبي : 311254845500003", fontSize: 14, textAlign: "center"),
      sizedBoxW(height: 5),
      rowW(children: [expandedW(flex: 2, child: textW("فاتورة : مبيعات", textAlign: "center")), expandedW(flex: 1, child: textW("رقم : 5555", textAlign: "center")), expandedW(flex: 2, child: textW(DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()), textAlign: "center"))]),

      //Barcode
      containerW(
        height: 70,
        padding: [5, 5, 5, 0],
        margin: [0, 10, 0, 10],
        alignment: "center",
        child: {
          "type": "barcode",
          "args": {"data": "1234567890", "width": 200, "height": 70},
        },

        //  textW(
        //   "*1000019999*",
        //   fontSize: 18,
        //   fontFamily: "IDAutomationHC39M",
        //   textAlign: "center",
        // ),
        // padding: [10, 5, 10, 5],
        // margin: [0, 10, 0, 10],
        containerDecorationW: containerDecorationW(
          containerDecorationBorderW: containerDecorationBorderW(
            // color: "#0000ff",
            width: 1,
          ),
          radius: 4,
          // color: "#ffff00",
        ),
      ),

      //header
      containerW(containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.5)), child: rowW(children: [expandedW(child: textW("رقم الصنف", textAlign: "center")), expandedW(child: textW("اسم الصنف", textAlign: "center")), expandedW(child: textW("الكمية", textAlign: "center")), expandedW(child: textW("ألسعر", textAlign: "center")), expandedW(child: textW("الاجمالي", textAlign: "center"))])),

      //details
      containerW(
        containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.5)),
        child: columnW(
          children: List.generate(
            8,
            (index) => rowW(
              children: [
                expandedW(child: containerW(containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.2)), padding: [0, 2, 0, 2], child: textW("1", textAlign: "center"))),
                expandedW(child: containerW(containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.2)), padding: [0, 2, 0, 2], child: textW("ذرة", textAlign: "center"))),
                expandedW(child: containerW(containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.2)), padding: [0, 2, 0, 2], child: textW("5", textAlign: "center"))),
                expandedW(child: containerW(containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.2)), padding: [0, 2, 0, 2], child: textW("5", textAlign: "center"))),
                expandedW(child: containerW(containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.2)), padding: [0, 2, 0, 2], child: textW("25", textAlign: "center"))),
              ],
            ),
          ),
        ),
      ),

      rowW(children: [expandedW(flex: 1, child: textW("20  الكمية", textAlign: "center", fontSize: 14)), expandedW(flex: 1, child: textW("عدد الاصناف  5", textAlign: "center", fontSize: 14))]),

      sizedBoxW(height: 5),
      //
      rowW(children: [expandedW(flex: 2, child: textW("كاونتر : 4", textAlign: "center")), expandedW(flex: 1, child: textW("بائع : 3", textAlign: "center")), expandedW(flex: 2, child: textW("مرتجع :؟؟؟؟", textAlign: "center"))]),
      //footer
      // containerW(
      //   padding: [2, 2, 2, 2],
      //   containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.5), ),
      //   child: rowW(
      //     children: [
      //       expandedW(flex: 2, child: textW("الاجمالي شامل الضريبة", textAlign: "center")),
      //       expandedW(flex: 1, child: textW("115", textAlign: "center")),
      //     ],
      //   ),
      // ),
      sizedBoxW(height: 5),
      containerW(padding: [2, 2, 2, 2], containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.5)), child: rowW(children: [expandedW(flex: 2, child: textW("الاجمالي قبل الضريبة", textAlign: "center", fontSize: 14)), expandedW(flex: 1, child: textW("100", textAlign: "center", fontSize: 14))])),
      containerW(padding: [2, 2, 2, 2], containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.5)), child: rowW(children: [expandedW(flex: 2, child: textW("ضريبة القيمة المضافة  15%", textAlign: "center", fontSize: 14)), expandedW(flex: 1, child: textW("15", textAlign: "center", fontSize: 14))])),

      containerW(padding: [2, 2, 2, 2], containerDecorationW: containerDecorationW(containerDecorationBorderW: containerDecorationBorderW(width: 0.5)), child: rowW(children: [expandedW(flex: 2, child: textW("الاجمالي بعد الضريبة", textAlign: "center", fontSize: 14)), expandedW(flex: 1, child: textW("115", textAlign: "center", fontSize: 14))])),

      //----------- not supported by PDF print or View
      // qrImageW(
      //   data: "https://goldensoft.com.sa",
      //   size: 180,
      //   backgroundColor: "#FFFFFF",
      //   dataModuleStyle: dataModuleStyleQrW(color: "#000000", shape: "square"),
      //   gapless: false,
      //   sematicsLabel: "My QR Code",
      //   embeddedImage: "assets/images/logo.ico",
      //   embeddedImageStyle: {"width": 40, "height": 40},
      //   eyeStyle: eyeStyleQrW(
      //     color: "#000000",
      //     shape: "square",
      //   ),
      // ),
      sizedBoxW(height: 10),

      {
        "type": "qr_code",
        "args": {"data": "https://goldensoft.com.sa/", "width": 150, "height": 150},
      },
    ],
  ),
);
