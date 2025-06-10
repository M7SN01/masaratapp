double mmToPixel(double mm) {
  return mm * 3.779527559;
}

Map<String, dynamic> textW(
  String text, {
  String textAlign = "center",
  int fontSize = 12,
  String fontWeight = "normal",
  String color = "#000000",
  String? fontFamily, // <-- add this
}) {
  return {
    "type": "text",
    "args": {
      "text": text,
      "textAlign": textAlign,
      "style": {
        "fontSize": fontSize,
        "fontWeight": fontWeight,
        "color": color,
        if (fontFamily != null) "fontFamily": fontFamily,
      }
    }
  };
}

Map containerDecorationBorderW({
  double width = 1,
  String color = "#000000",
}) {
  return {
    "color": color,
    "width": width,
  };
}

Map containerDecorationW({
  String? color,
  // Map? borderRadius,
  Map? containerDecorationBorderW,
  int radius = 0,
}) {
  return {
    "color": color,
    "border": containerDecorationBorderW,
    "borderRadius": {
      "type": "all",
      "radius": radius,
    }
  };
}

Map<String, dynamic> containerW({
  Map? child,
  String? color,
  double? width,
  double? height,
  List? padding,
  List? margin,
  String? alignment,
  Map? containerDecorationW,
}) {
  return {
    "type": "container",
    "args": {
      if (child != null) "child": child,
      if (containerDecorationW == null && color != null) "color": color,
      if (width != null) "width": width,
      if (height != null) "height": height,
      if (padding != null) "padding": padding,
      if (margin != null) "margin": margin,
      if (alignment != null) "alignment": alignment,
      if (containerDecorationW != null) "decoration": containerDecorationW,
    }
  };
}

Map<String, dynamic> rowW({
  List<Map>? children,
  String? mainAxisAlignment,
  String? crossAxisAlignment,
}) {
  return {
    "type": "row",
    "args": {
      "children": children,
      if (mainAxisAlignment != null) "mainAxisAlignment": mainAxisAlignment,
      if (crossAxisAlignment != null) "crossAxisAlignment": crossAxisAlignment,
    }
  };
}

Map<String, dynamic> columnW({
  required List<Map> children,
  String? mainAxisAlignment,
  String? crossAxisAlignment,
}) {
  return {
    "type": "column",
    "args": {
      "children": children,
      if (mainAxisAlignment != null) "mainAxisAlignment": mainAxisAlignment,
      if (crossAxisAlignment != null) "crossAxisAlignment": crossAxisAlignment,
    }
  };
}

Map<String, dynamic> imageW({
  double? width,
  double? height,
  String? assetName,
}) {
  return {
    "type": "asset_image",
    "args": {
      "name": assetName,
      if (height != null) "height": height,
      if (width != null) "width": width,
    }
  };
}

Map<String, dynamic> imageSvgW({
  double? width,
  double? height,
  String? assetName,
}) {
  return {
    "type": "svg_image",
    "args": {
      "name": assetName,
      if (height != null) "height": height,
      if (width != null) "width": width,
    }
  };
}

Map<String, dynamic> expandedW({required Map child, int? flex}) {
  return {
    "type": "expanded",
    "args": {
      if (flex != null) "flex": flex,
      "child": child,
    }
  };
}

Map<String, dynamic> centerW({required Map child}) {
  return {
    "type": "center",
    "args": {
      "child": child,
    }
  };
}

Map<String, dynamic> sizedBoxW({Map? child, double? height, double? width}) {
  return {
    "type": "sized_box",
    "args": {
      if (height != null) "height": height,
      if (width != null) "width": width,
      if (child != null) "child": child,
    }
  };
}

Map<String, dynamic> dataModuleStyleQrW({String color = "#000000", String shape = "square"}) {
  return {"color": color, "shape": shape};
}

Map<String, dynamic> eyeStyleQrW({String color = "#000000", String shape = "square"}) {
  return {"color": "#000000", "shape": "square"};
}

Map<String, dynamic> qrW({
  required String data,
  double? width = 100,
  double? height = 100,
}) {
  return {
    "type": "qr_code",
    "args": {
      "data": data,
      "width": width,
      "height": width,
    }
  };
}

/*
Map<String,dynamic> qrImageW({
  String data = "https://example.com",
  int size = 100,
  String backgroundColor = "#FFFFFF",
  Map? dataModuleStyle,
  bool gapless = false,
  String sematicsLabel = "My QR Code",
  String embeddedImage = "assets/images/logo.ico",
  Map? embeddedImageStyle,
  Map? eyeStyle,
}) {
  return {
    "type": "qr_image",
    "args": {
      "data": data,
      "size": 200,
      "backgroundColor": backgroundColor,
      "dataModuleStyle": dataModuleStyle,
      "gapless": gapless,
      "semanticsLabel": sematicsLabel,
      "embeddedImage": embeddedImage,
      "embeddedImageStyle": embeddedImageStyle,
      "eyeStyle": eyeStyle,
    }
  };
}
*/
Map<String, dynamic> qrCodeW({
  required String data,
  double width = 100,
  double height = 100,
  double? padding,
  Map? border,
  double? borderRadius,
  String? image,
  double imgWidth = 30,
  double imgHeight = 30,
  double imgborderRadius = 0,
}) {
  return {
    "type": "qr_code",
    "args": {
      "data": data,
      "width": width,
      "height": height,
      "imgwidth": imgWidth,
      "imgheight": imgHeight,
      "imgborderRadius": imgborderRadius,
      if (image != null) "image": image,
      if (padding != null) "padding": padding,
      if (border != null) "border": border, // color , width
      if (borderRadius != null) "borderRadius": borderRadius,
    }
  };
}

Map<String, dynamic> dashedLineW({
  double? dashWidth,
  double? dashSpace,
  double? height,
  String? color,
}) {
  return {
    "type": "dashed_line",
    "args": {
      "dashWidth": dashWidth,
      "dashSpace": dashSpace,
      "height": height,
      "color": color,
    }
  };
}

Map<String, dynamic> repateW({required Map<String, dynamic> child}) {
  return {
    "type": "repeat",
    "args": {"child": child}
  };
}
