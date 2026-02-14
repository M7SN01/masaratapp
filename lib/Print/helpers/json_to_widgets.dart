import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

Widget renderWidgetView(Map<String, dynamic> map) {
  switch (map['type']) {
    case 'scaffold':
      return Scaffold(
        appBar: map['args']?['appBar'] != null ? renderWidgetView(map['args']['appBar']) as PreferredSizeWidget? : null,
        body: map['args']?['body'] != null ? renderWidgetView(Map<String, dynamic>.from(map['args']['body'])) : null,
      );

    case 'app_bar':
      return AppBar(
        title: renderWidgetView(map['args']['title']),
      );

    case 'text':
      var args = map['args'];
      var style = args['style'] ?? {};
      return Text(
        args['text'] ?? '',
        textAlign: parseTextAlign(args['textAlign']),
        style: TextStyle(
          fontSize: (style['fontSize'] as int?)?.toDouble(),
          fontWeight: parseFontWeight(style['fontWeight']),
          color: parseHexColor(style['color']),
          fontFamily: style['fontFamily'],
        ),
      );

    case 'container':
      var args = map['args'];
      return Container(
        width: (args['width'] as num?)?.toDouble(),
        height: (args['height'] as num?)?.toDouble(),
        padding: parseEdgeInsets(args['padding']),
        margin: parseEdgeInsets(args['margin']),
        alignment: parseAlignment(args['alignment']),
        decoration: parseBoxDecoration(args['decoration']) ?? (args['color'] != null ? BoxDecoration(color: parseHexColor(args['color'])) : null),
        child: args['child'] != null ? renderWidgetView(Map<String, dynamic>.from(args['child'])) : null,
      );

    case 'row':
      return Row(
        mainAxisAlignment: parseMainAxisAlignment(map['args']['mainAxisAlignment']),
        crossAxisAlignment: parseCrossAxisAlignment(map['args']['crossAxisAlignment']),
        children: (map['args']['children'] as List?)?.map<Widget>((e) => renderWidgetView(Map<String, dynamic>.from(e))).toList() ?? [],
      );

    case 'column':
      return Column(
        mainAxisAlignment: parseMainAxisAlignment(map['args']['mainAxisAlignment']),
        crossAxisAlignment: parseCrossAxisAlignment(map['args']['crossAxisAlignment']),
        children: (map['args']['children'] as List?)?.map<Widget>((e) => renderWidgetView(Map<String, dynamic>.from(e))).toList() ?? [],
      );

    case 'expanded':
      return Expanded(
        flex: map['args']['flex'] ?? 1,
        child: renderWidgetView(Map<String, dynamic>.from(map['args']['child'])),
      );

    case 'sized_box':
      var args = map['args'];
      return SizedBox(
        width: (args['width'] as num?)?.toDouble(),
        height: (args['height'] as num?)?.toDouble(),
      );

    case 'asset_image':
      var args = map['args'];
      return Image.asset(args['name']);

    case 'single_child_scroll_view':
      return SingleChildScrollView(
        child: renderWidgetView(Map<String, dynamic>.from(map['args']['child'])),
      );

/*
    case 'qr_image':
      final args = map['args'];
      return QrImageView(
        data: args['data'] ?? '',
        size: (args['size'] as num?)?.toDouble() ?? 200,
        backgroundColor: parseHexColor(args['backgroundColor'])!,
        gapless: args['gapless'] ?? true,
        semanticsLabel: args['semanticsLabel'],
        embeddedImage: args['embeddedImage'] != null ? AssetImage(args['embeddedImage']) : null,
        dataModuleStyle: QrDataModuleStyle(
          color: parseHexColor(args['dataModuleStyle']?['color']) ?? Colors.black,
          dataModuleShape: parseQrDataModuleShape(args['dataModuleStyle']?['shape']),
        ),
        eyeStyle: QrEyeStyle(
          color: parseHexColor(args['eyeStyle']?['color']) ?? Colors.black,
          eyeShape: parseQrEyeShape(args['eyeStyle']?['shape']),
        ),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: Size(
            (args['embeddedImageStyle']?['width'] as num?)?.toDouble() ?? 40,
            (args['embeddedImageStyle']?['height'] as num?)?.toDouble() ?? 40,
          ),
        ),
      );
*/
    default:
      return const SizedBox(); // fallback
  }
}

// Helpers

TextAlign parseTextAlign(String? align) {
  switch (align) {
    case "left":
      return TextAlign.left;
    case "right":
      return TextAlign.right;
    case "center":
      return TextAlign.center;
    case "justify":
      return TextAlign.justify;
    default:
      return TextAlign.start;
  }
}

FontWeight? parseFontWeight(String? weight) {
  switch (weight) {
    case "bold":
      return FontWeight.bold;
    case "w100":
      return FontWeight.w100;
    case "w200":
      return FontWeight.w200;
    case "w300":
      return FontWeight.w300;
    case "w400":
      return FontWeight.w400;
    case "w500":
      return FontWeight.w500;
    case "w600":
      return FontWeight.w600;
    case "w700":
      return FontWeight.w700;
    case "w800":
      return FontWeight.w800;
    case "w900":
      return FontWeight.w900;
    default:
      return FontWeight.normal;
  }
}

Color? parseHexColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) return null;
  hexColor = hexColor.replaceAll('#', '');
  if (hexColor.length == 6) hexColor = 'FF$hexColor';
  return Color(int.parse(hexColor, radix: 16));
}

EdgeInsets? parseEdgeInsets(List? values) {
  if (values == null || values.length != 4) return null;
  return EdgeInsets.fromLTRB(
    (values[0] as num).toDouble(),
    (values[1] as num).toDouble(),
    (values[2] as num).toDouble(),
    (values[3] as num).toDouble(),
  );
}

Alignment? parseAlignment(String? align) {
  switch (align) {
    case "center":
      return Alignment.center;
    case "topLeft":
      return Alignment.topLeft;
    case "topRight":
      return Alignment.topRight;
    case "bottomLeft":
      return Alignment.bottomLeft;
    case "bottomRight":
      return Alignment.bottomRight;
    default:
      return null;
  }
}

MainAxisAlignment parseMainAxisAlignment(String? value) {
  switch (value) {
    case "start":
      return MainAxisAlignment.start;
    case "end":
      return MainAxisAlignment.end;
    case "center":
      return MainAxisAlignment.center;
    case "spaceBetween":
      return MainAxisAlignment.spaceBetween;
    case "spaceAround":
      return MainAxisAlignment.spaceAround;
    case "spaceEvenly":
      return MainAxisAlignment.spaceEvenly;
    default:
      return MainAxisAlignment.start;
  }
}

CrossAxisAlignment parseCrossAxisAlignment(String? value) {
  switch (value) {
    case "start":
      return CrossAxisAlignment.start;
    case "end":
      return CrossAxisAlignment.end;
    case "center":
      return CrossAxisAlignment.center;
    case "stretch":
      return CrossAxisAlignment.stretch;
    case "baseline":
      return CrossAxisAlignment.baseline;
    default:
      return CrossAxisAlignment.start;
  }
}

BoxDecoration? parseBoxDecoration(Map? data) {
  if (data == null) return null;
  return BoxDecoration(
    color: parseHexColor(data['color']),
    borderRadius: data['borderRadius'] != null ? BorderRadius.circular((data['borderRadius']['radius'] as num?)?.toDouble() ?? 0) : null,
    border: data['border'] != null
        ? Border.all(
            color: parseHexColor(data['border']['color']) ?? Colors.black,
            width: (data['border']['width'] as num?)?.toDouble() ?? 1,
            style: data['border']['style'] == "dotted" ? BorderStyle.solid : BorderStyle.solid,
          )
        : null,
  );
}

/*
QrDataModuleShape parseQrDataModuleShape(String? shape) {
  switch (shape) {
    case 'circle':
      return QrDataModuleShape.circle;
    case 'square':
    default:
      return QrDataModuleShape.square;
  }
}

QrEyeShape parseQrEyeShape(String? shape) {
  switch (shape) {
    case 'circle':
      return QrEyeShape.circle;
    case 'square':
    default:
      return QrEyeShape.square;
  }
}

*/