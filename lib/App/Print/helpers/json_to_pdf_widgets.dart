// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
import 'package:masaratapp/App/utils/utils.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

/*
call  renderWidgetView(mapData),
*/

String fixFinalYaa(String text) {
  final words = text.split(' ');

  final fixedWords = words.map((word) {
    // word = word.replaceAll('-', ' ');
    if (word.endsWith('ي')) {
      return '${word.substring(0, word.length - 1)}ـي';
    }
    // else if (word.endsWith('ي-')) {
    //   debugPrint(word);
    //   return '${word.substring(0, word.length - 1)}ـي';
    // }
    return word;
  }).toList();

  return fixedWords.join(' ');
}

Future<List<pw.Widget>> renderToPdfWidgets(
  Map<String, dynamic> map,
  Map<String, dynamic> variables,
) async {
  final widget = await renderToPdfWidget(map, variables);

  if (widget is pw.Column) return widget.children;
  if (widget is pw.Row) return [widget];
  if (widget is pw.Table) return [widget];
  if (widget is pw.Center) return [widget];
  if (widget is pw.Spacer) return [widget];

  if (widget is pw.Container) {
    final child = widget.child;
    if (child is pw.Column) return child.children;
    return [widget];
  }

  return [widget];
}

Future<pw.Widget> renderToPdfWidget(
  Map<String, dynamic> map,
  Map<String, dynamic> variables,
//, {Map<String, List<Map<String, dynamic>>> lists = const {}}
) async {
  // debugPrint(lists);
  String interpolate(String? input) {
    if (input == null) return '';
    // debugPrint("The input -------------------------  ( $input )");
    return input.replaceAllMapped(RegExp(r'\{\{(\w+)\}\}'), (match) {
      final key = match.group(1);
      return variables[key] ?? '';
    });
  }

  switch (map['type']) {
    case 'text':
      if (map['args']['hide'] != null) return pw.SizedBox();

      var args = map['args'];
      var style = args['style'] ?? {};

      String txt = "";
      if (!args['to_arabic_words']) {
        txt = interpolate(args['text']);
      } else {
        txt = convertToArabicWords(double.parse(interpolate(args['text'])));
      }
      return pw.Text(
        fixFinalYaa(txt), //  args['text'] ?? '',
        textAlign: parseTextAlign(args['textAlign']),
        style: pw.TextStyle(
          fontSize: (style['fontSize'] as int?)?.toDouble(),
          fontWeight: parseFontWeight(style['fontWeight']),
          color: parseHexColor(style['color']),
          fontItalic: pw.Font.courier(),
          //     font: style['fontFamily'] == "arial" ? pw.Font.ttf(await rootBundle.load("assets/fonts/Arial.ttf")) : null,
        ),
      );

    case 'container':
      if (map['args']['hide'] != null) return pw.SizedBox();

      var args = map['args'];

      return pw.Container(
        width: (args['width'] as num?)?.toDouble(),
        height: (args['height'] as num?)?.toDouble(),
        padding: parseEdgeInsets(args['padding']),
        margin: parseEdgeInsets(args['margin']),
        alignment: parseAlignment(args['alignment']),
        decoration: parseBoxDecoration(args['decoration']) ?? (args['color'] != null ? pw.BoxDecoration(color: parseHexColor(args['color'])) : null),
        child: args['child'] != null ? await renderToPdfWidget(Map<String, dynamic>.from(args['child']), variables) : null,
      );

    case 'row':
      if (map['args']['hide'] != null) return pw.SizedBox();

      List children = map['args']['children'] ?? [];

      List<pw.Widget> rowChildren = [];

      for (var child in children) {
        rowChildren.add(await renderToPdfWidget(Map<String, dynamic>.from(child), variables));
      }
      return pw.Row(mainAxisAlignment: parseMainAxisAlignment(map['args']['mainAxisAlignment']), crossAxisAlignment: parseCrossAxisAlignment(map['args']['crossAxisAlignment']), children: rowChildren
          // (map['args']['children'] as List?)?.map<pw.Widget>((e) => renderToPdfWidget(Map<String, dynamic>.from(e))).toList() ?? [],
          );

    case 'column':
      if (map['args']['hide'] != null) return pw.SizedBox();

      List children = map['args']['children'] ?? [];
      List<pw.Widget> columnChildren = [];

      for (var child in children) {
        columnChildren.add(await renderToPdfWidget(Map<String, dynamic>.from(child), variables));
      }
      return pw.Column(
        mainAxisAlignment: parseMainAxisAlignment(map['args']['mainAxisAlignment']), crossAxisAlignment: parseCrossAxisAlignment(map['args']['crossAxisAlignment']), children: columnChildren,
        // (map['args']['children'] as List?)?.map<pw.Widget>((e) => renderToPdfWidget(Map<String, dynamic>.from(e))).toList() ?? [],
      );

    case 'expanded':
      if (map['args']['hide'] != null) return pw.SizedBox();

      return pw.Expanded(
        flex: map['args']['flex'] ?? 1,
        child: await renderToPdfWidget(Map<String, dynamic>.from(map['args']['child']), variables),
      );

    case 'sized_box':
      if (map['args']['hide'] != null) return pw.SizedBox();

      var args = map['args'];
      return pw.SizedBox(
        width: (args['width'] as num?)?.toDouble(),
        height: (args['height'] as num?)?.toDouble(),
        child: args['child'] != null ? await renderToPdfWidget(Map<String, dynamic>.from(map['args']['child']), variables) : null,
      );
    case 'center':
      if (map['args']['hide'] != null) return pw.SizedBox();

      var args = map['args'];
      return pw.Center(
        child: args['child'] != null ? await renderToPdfWidget(Map<String, dynamic>.from(map['args']['child']), variables) : null,
      );
    case 'spacer':
      // var args = map['args'];
      return pw.Spacer();
    case 'svg_image':
      if (map['args']['hide'] != null) return pw.SizedBox();

      var args = map['args'];
      final raw = await rootBundle.loadString(args['name']);
      return pw.SvgImage(
        svg: raw,
        width: args['width'],
        height: args['height'],
      );

    case 'asset_image':
      if (map['args']['hide'] != null) return pw.SizedBox();

      var args = map['args'];
      final bytes = await loadAssetImage(args['name']);
      final image = pw.MemoryImage(bytes);
      return pw.Image(
        image,
        width: args['width'],
        height: args['height'],
      );
    case 'barcode':
      if (map['args']['hide'] != null) return pw.SizedBox();

      final args = map['args'];
      if (args['hide'] != null) return pw.SizedBox();

      return pw.BarcodeWidget(
        barcode: pw.Barcode.code128(), // or pw.Barcode.qrCode()
        data: interpolate(args['data']), // args['data'] ?? '',
        textStyle: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.normal),
        // decoration: pw.BoxDecoration(borderRadius: pw.BorderRadius.all(pw.Radius.circular(8))),
        // width: (args['width'] ?? 200).toDouble(),
        // height: (args['height'] ?? 80).toDouble(),
      );
    /*
    case 'qr_code':
      final args = map['args'];
      return pw.BarcodeWidget(
        barcode: pw.Barcode.qrCode(),
        data: args['data'] ?? '',
        width: (args['width'] ?? 150).toDouble(),
        height: (args['height'] ?? 150).toDouble(),
        decoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(
            pw.Radius.circular(8),
          ),
          border: pw.Border.all(
            color: PdfColors.black,
          ),
        ),
        padding: const pw.EdgeInsets.all(10),
      );
      */

    case 'qr_code':
      if (map['args']['hide'] != null) return pw.SizedBox();

      final args = map['args'];
      final imgBytes = args['image'] != null ? pw.MemoryImage(await loadAssetImage(args['image'])) : null;

      return pw.Stack(
        alignment: pw.Alignment.center,
        children: [
          pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(
              errorCorrectLevel: imgBytes != null ? pw.BarcodeQRCorrectionLevel.high : pw.BarcodeQRCorrectionLevel.low,
            ),
            data: interpolate(args['data']), // args['data'] ?? '',
            width: (args['width'] ?? 150).toDouble(),
            height: (args['height'] ?? 150).toDouble(),
            decoration: pw.BoxDecoration(
              borderRadius: args['borderRadius'] != null
                  ? pw.BorderRadius.all(
                      pw.Radius.circular(args['borderRadius']),
                    )
                  : null,
              border: args['border'] != null
                  ? pw.Border.all(
                      width: args['border']['width'],
                      color: args['border']['color'] != null ? PdfColor.fromHex(args['border']['color']) : PdfColors.white,
                    )
                  : null,
            ),
            padding: args['padding'] != null ? pw.EdgeInsets.all(args['padding']) : null,
          ),
          if (imgBytes != null)
            pw.Container(
              width: args['imgwidth'],
              height: args['imgheight'],
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(args['imgborderRadius']),
                // color: PdfColors.white,
                image: pw.DecorationImage(
                  image: imgBytes,
                  fit: pw.BoxFit.cover,
                ),
              ),
            ),
        ],
      );

    case 'dashed_line':
      if (map['args']['hide'] != null) return pw.SizedBox();

      final args = map['args'];
      final double dashWidth = args['dashWidth'] ?? 2;
      final double dashSpace = args['dashSpace'] ?? 2;
      return pw.LayoutBuilder(builder: (context, constraints) {
        final dashCount = (constraints!.maxWidth / (dashWidth + dashSpace)).floor();
        // debugPrint((constraints.maxWidth / (dashWidth + dashSpace)).floor());
        // debugPrint(constraints.maxWidth);
        // debugPrint("dash count : $dashCount");
        return pw.Row(
          children: List.generate(
            dashCount * 2 - 1,
            (x) {
              if (x.isEven) {
                // Dash
                return pw.SizedBox(
                  width: dashWidth,
                  height: args['height'] ?? 2,
                  child: pw.DecoratedBox(
                    decoration: pw.BoxDecoration(color: args['color'] ?? PdfColors.grey),
                  ),
                );
              } else {
                // Space
                return pw.SizedBox(width: dashSpace);
              }

              // return pw.SizedBox(
              //   width: dashWidth,
              //   height: args['height'] ?? 5,
              //   child: pw.DecoratedBox(
              //     decoration: pw.BoxDecoration(color: args['color'] ?? PdfColors.grey),
              //   ),
              // );
            },
          ),
        );
      });

    case 'repeat':
      if (map['args']['hide'] != null) return pw.SizedBox();

      // final listName = map['args']['for']; // listName <=  'items' Map key  {'items' :  [list of Map items rows] }
      //  final dataList =  lists[listName] ?? []; // [list of Map items rows]
      //final template = map['args']['template']; //   row widget structuer

      final dataList = (variables['repeat_element'] as List).cast<Map<String, dynamic>>();

      List<pw.Widget> repeatedWidgets = [];

      for (var item in dataList) {
        // Convert item fields to variables for interpolation
        // final itemVars = Map<String, String>.fromEntries(
        //   item.entries.map((e) => MapEntry(e.key, e.value.toString())),
        // );
        final itemVars = item.map((key, value) => MapEntry(key, value.toString()));

        // Merge with globalVariables
        final mergedVars = {...variables, ...itemVars};

        final widget = await renderToPdfWidget(
          Map<String, dynamic>.from(map['args']['child']),
          mergedVars,
          // lists: lists,
        );

        repeatedWidgets.add(widget);
      }

      return pw.Column(children: repeatedWidgets);

    case 'table':
      if (map['args']['hide'] != null) return pw.SizedBox();

      final dataList = (variables['repeat_element'] as List).cast<Map<String, dynamic>>();

      // final columns = map['args']['columns'] as List<dynamic>;
      final columns = <String>{for (var row in dataList) ...row.keys}.toList().reversed.toList();
      final headers = map['args']['headers'].reversed.toList();

      return pw.TableHelper.fromTextArray(
        headers: headers.map((element) => interpolate(element['name'].toString())).toList(), // Make sure headers are ordered RTL manually
        data: dataList.map((row) => columns.map((h) => row[h].toString()).toList()).toList(),
        //-----------Constant--Dont Change-------------
        border: const pw.TableBorder(),
        headerAlignment: pw.Alignment.center,
        cellAlignment: pw.Alignment.center,
        headerDirection: pw.TextDirection.rtl, // To support Arabic Direction
        // defaultColumnWidth: const pw.FlexColumnWidth(),
        //---------------------------------------------

        columnWidths: {
          for (int i = 0; i < headers.length; i++)
            i: headers[i]['width'] != null
                ? pw.FixedColumnWidth(
                    (headers[i]['width']).toDouble(),
                  )
                : headers[i]['FlexColumnWidth'] != null
                    ? pw.FlexColumnWidth(headers[i]['FlexColumnWidth'] ?? 1.0)
                    : pw.IntrinsicColumnWidth()
        },

//------------------------------------HEADER STYLE------------------------------------

        headerStyle: map['args']['headerStyle'] != null
            ? pw.TextStyle(
                fontSize: (map['args']['headerStyle']['fontSize'] ?? 12).toDouble(),
                fontWeight: map['args']['headerStyle']['fontWeight'] == "bold" ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: PdfColor.fromHex(map['args']['headerStyle']['color'] ?? "#00000"),
              )
            : null,

        headerCellDecoration: map['args']['headerCellDecoration'] != null
            ? pw.BoxDecoration(
                color: PdfColor.fromHex(map['args']['headerCellDecoration']['color']),
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(map['args']['headerCellDecoration']['borderRadius'])),
                border: pw.Border.all(
                  color: PdfColor.fromHex(map['args']['headerCellDecoration']['border_color']),
                  width: map['args']['headerCellDecoration']['border_width'],
                ),
              )
            : null,

        headerDecoration: map['args']['headerDecoration'] != null
            ? pw.BoxDecoration(
                color: PdfColor.fromHex(map['args']['headerDecoration']['color']),
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(map['args']['headerDecoration']['borderRadius'])),
                border: pw.Border.all(
                  color: PdfColor.fromHex(map['args']['headerDecoration']['border_color']),
                  width: map['args']['headerDecoration']['border_width'],
                ),
              )
            : null,

//------------------------------------Rows STYLE-----------------------

        // cellStyle: map['args']['cellStyle'] != null
        //     ? pw.TextStyle(
        //         fontSize: (map['args']['cellStyle']['fontSize'] ?? 12).toDouble(),
        //         fontWeight: map['args']['cellStyle']['fontWeight'] == "bold" ? pw.FontWeight.bold : pw.FontWeight.normal,
        //         color: PdfColor.fromHex(map['args']['cellStyle']['color'] ?? "#00000"),
        //       )
        //     : null,
        //

        textStyleBuilder: map['args']['cellStyle'] != null
            ? (index, data, rowNum) {
                String cellStyle = rowNum == dataList.length ? "footerCellStyle" : "cellStyle";
                return pw.TextStyle(
                  fontSize: (map['args'][cellStyle]['fontSize'] ?? 12).toDouble(),
                  fontWeight: map['args'][cellStyle]['fontWeight'] == "bold" ? pw.FontWeight.bold : pw.FontWeight.normal,
                  color: PdfColor.fromHex(map['args'][cellStyle]['color'] ?? "#00000"),
                );
              }
            : null,

        cellDecoration: map['args']['cellDecoration'] != null
            ? (index, data, rowNum) {
                //if need to apply vertical decoration compare with the index (column index)
                String decoration = rowNum == dataList.length ? "footerCellDecoration" : "cellDecoration";
                return pw.BoxDecoration(
                  color: PdfColor.fromHex(map['args'][decoration]['color']),
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(map['args'][decoration]['borderRadius'])),
                  border: pw.Border.all(
                    color: PdfColor.fromHex(map['args'][decoration]['border_color']),
                    width: map['args'][decoration]['border_width'],
                  ),
                );
              }
            : null,

        rowDecoration: map['args']['rowDecoration'] != null
            ? pw.BoxDecoration(
                color: PdfColor.fromHex(map['args']['rowDecoration']['color']),
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(map['args']['rowDecoration']['borderRadius'])),
                border: pw.Border.all(
                  color: PdfColor.fromHex(map['args']['rowDecoration']['border_color']),
                  width: map['args']['rowDecoration']['border_width'],
                ),
              )
            : null,

        oddRowDecoration: map['args']['oddRowDecoration'] != null
            ? pw.BoxDecoration(
                color: PdfColor.fromHex(map['args']['oddRowDecoration']['color']),
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(map['args']['oddRowDecoration']['borderRadius'])),
                border: pw.Border.all(
                  color: PdfColor.fromHex(map['args']['oddRowDecoration']['border_color']),
                  width: map['args']['oddRowDecoration']['border_width'],
                ),
              )
            : null,
      );

    default:
      return pw.SizedBox();
  }
}

Future<Uint8List> loadAssetImage(String path) async {
  try {
    final bytes = await rootBundle.load(path);
    final list = bytes.buffer.asUint8List();
    return list;
  } catch (e) {
    debugPrint('❌ Failed to load image: $path - $e');
    rethrow;
  }
}

pw.TextAlign parseTextAlign(String? align) {
  switch (align) {
    case "left":
      return pw.TextAlign.left;
    case "right":
      return pw.TextAlign.right;
    case "center":
      return pw.TextAlign.center;
    case "justify":
      return pw.TextAlign.justify;
    default:
      return pw.TextAlign.start;
  }
}

pw.FontWeight? parseFontWeight(String? weight) {
  switch (weight) {
    case "bold":
      return pw.FontWeight.bold;
    default:
      return pw.FontWeight.normal;
  }
}

PdfColor? parseHexColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) return null;
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) hexColor = 'FF$hexColor';
  return PdfColor.fromInt(int.parse(hexColor, radix: 16));
}

pw.EdgeInsets? parseEdgeInsets(List? values) {
  if (values == null || values.length != 4) return null;
  return pw.EdgeInsets.fromLTRB(
    (values[0] as num).toDouble(),
    (values[1] as num).toDouble(),
    (values[2] as num).toDouble(),
    (values[3] as num).toDouble(),
  );
}

pw.Alignment? parseAlignment(String? align) {
  switch (align) {
    case "center":
      return pw.Alignment.center;
    case "topLeft":
      return pw.Alignment.topLeft;
    case "topRight":
      return pw.Alignment.topRight;
    case "bottomLeft":
      return pw.Alignment.bottomLeft;
    case "bottomRight":
      return pw.Alignment.bottomRight;
    default:
      return null;
  }
}

pw.MainAxisAlignment parseMainAxisAlignment(String? value) {
  switch (value) {
    case "start":
      return pw.MainAxisAlignment.start;
    case "end":
      return pw.MainAxisAlignment.end;
    case "center":
      return pw.MainAxisAlignment.center;
    case "spaceBetween":
      return pw.MainAxisAlignment.spaceBetween;
    case "spaceAround":
      return pw.MainAxisAlignment.spaceAround;
    case "spaceEvenly":
      return pw.MainAxisAlignment.spaceEvenly;
    default:
      return pw.MainAxisAlignment.start;
  }
}

pw.CrossAxisAlignment parseCrossAxisAlignment(String? value) {
  switch (value) {
    case "start":
      return pw.CrossAxisAlignment.start;
    case "end":
      return pw.CrossAxisAlignment.end;
    case "center":
      return pw.CrossAxisAlignment.center;
    case "stretch":
      return pw.CrossAxisAlignment.stretch;
    default:
      return pw.CrossAxisAlignment.start;
  }
}

pw.BoxDecoration? parseBoxDecoration(Map? data) {
  if (data == null) return null;
  return pw.BoxDecoration(
    color: parseHexColor(data['color']),
    borderRadius: data['borderRadius'] != null ? pw.BorderRadius.circular((data['borderRadius']['radius'] as num?)?.toDouble() ?? 0) : null,
    border: data['border'] != null
        ? pw.Border.all(
            color: parseHexColor(data['border']['color']) ?? PdfColors.black,
            width: (data['border']['width'] as num?)?.toDouble() ?? 1,
            // style: data['border']['style'] == "dotted" ? BorderStyle.solid : BorderStyle.solid,
          )
        : null,

    //trying symmetric border
    /*
 // borderRadius: data['borderRadius'] != null ? pw.BorderRadius.circular((data['borderRadius']['radius'] as num?)?.toDouble() ?? 0) : null,
    border: data['border'] != null
        ? data['border']["type"] == "all"
            ? pw.Border.all(
                color: parseHexColor(data['border']['color']) ?? PdfColors.black,
                width: (data['border']['width'] as num?)?.toDouble() ?? 1,
                // style: data['border']['style'] == "dotted" ? BorderStyle.solid : BorderStyle.solid,
              )
            : pw.Border.symmetric(
                vertical: data['border']["type"] == "symmetric_v"
                    ? pw.BorderSide(
                        color: parseHexColor(data['border']['color']) ?? PdfColors.black,
                        width: (data['border']['width'] as num?)?.toDouble() ?? 1,
                      )
                    : pw.BorderSide.none,
                horizontal: data['border']["type"] == "symmetric_h"
                    ? pw.BorderSide(
                        color: parseHexColor(data['border']['color']) ?? PdfColors.black,
                        width: (data['border']['width'] as num?)?.toDouble() ?? 1,
                      )
                    : pw.BorderSide.none,
              )
        : null,
        */
  );
}
