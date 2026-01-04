// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

// import 'dart:convert';
// import 'dart:typed_data';

// class ZatcaQrScanPage extends StatefulWidget {
//   const ZatcaQrScanPage({super.key});

//   @override
//   State<ZatcaQrScanPage> createState() => _ZatcaQrScanPageState();
// }

// class _ZatcaQrScanPageState extends State<ZatcaQrScanPage> {
//   bool _handled = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Scan ZATCA QR')),
//       body: MobileScanner(
//         onDetect: (capture) {
//           if (_handled) return;
//           final barcode = capture.barcodes.isNotEmpty ? capture.barcodes.first : null;
//           final raw = barcode?.rawValue?.trim();
//           if (raw == null || raw.isEmpty) return;

//           _handled = true;
//           final parsed = ZatcaQrParser.parse(raw);

//           // Example: show results
//           showDialog(
//             context: context,
//             builder: (_) => AlertDialog(
//               title: const Text('Parsed QR'),
//               content: Text(parsed.toPrettyString()),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     _handled = false;
//                   },
//                   child: const Text('Scan again'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class ZatcaParsedResult {
//   final String raw;
//   final String? sellerName;
//   final String? vatNo;

//   // For non-TLV cases
//   final Uri? url;
//   final String? identifier;

//   const ZatcaParsedResult({
//     required this.raw,
//     this.sellerName,
//     this.vatNo,
//     this.url,
//     this.identifier,
//   });

//   String toPrettyString() {
//     final b = StringBuffer()
//       ..writeln('Raw: $raw')
//       ..writeln('Seller name: ${sellerName ?? "-"}')
//       ..writeln('VAT No: ${vatNo ?? "-"}')
//       ..writeln('URL: ${url?.toString() ?? "-"}')
//       ..writeln('Identifier: ${identifier ?? "-"}');
//     return b.toString();
//   }
// }

// class ZatcaQrParser {
//   /// Attempts:
//   /// 1) TLV Base64 (FATOORA invoice-style)
//   /// 2) URL
//   /// 3) Plain identifier text
//   static ZatcaParsedResult parse(String raw) {
//     // 1) URL
//     final maybeUrl = Uri.tryParse(raw);
//     if (maybeUrl != null && (maybeUrl.scheme == 'http' || maybeUrl.scheme == 'https')) {
//       return ZatcaParsedResult(raw: raw, url: maybeUrl);
//     }

//     // 2) Try TLV Base64
//     final tlv = _tryDecodeTlvBase64(raw);
//     if (tlv != null) {
//       return ZatcaParsedResult(
//         raw: raw,
//         sellerName: tlv[1],
//         vatNo: tlv[2],
//       );
//     }

//     // 3) Fallback: treat as identifier
//     return ZatcaParsedResult(raw: raw, identifier: raw);
//   }

//   /// Returns map tag->value if TLV parse succeeds, else null.
//   static Map<int, String>? _tryDecodeTlvBase64(String input) {
//     // Basic sanity: Base64-like
//     final cleaned = input.replaceAll(RegExp(r'\s+'), '');
//     if (cleaned.length < 8) return null;
//     if (!RegExp(r'^[A-Za-z0-9+/=]+$').hasMatch(cleaned)) return null;

//     Uint8List bytes;
//     try {
//       bytes = base64.decode(cleaned);
//     } catch (_) {
//       return null;
//     }

//     // TLV: [tag(1 byte)][len(1 byte)][value(len bytes)]...
//     final out = <int, String>{};
//     int i = 0;
//     try {
//       while (i + 2 <= bytes.length) {
//         final tag = bytes[i];
//         final len = bytes[i + 1];
//         i += 2;
//         if (i + len > bytes.length) return null;

//         final valueBytes = bytes.sublist(i, i + len);
//         i += len;

//         // ZATCA uses UTF-8 for text values in TLV QR :contentReference[oaicite:3]{index=3}
//         final value = utf8.decode(valueBytes, allowMalformed: true);
//         out[tag] = value;
//       }
//     } catch (_) {
//       return null;
//     }

//     // Must contain at least tags 1 and 2 to be considered “ZATCA invoice TLV”
//     if (!out.containsKey(1) || !out.containsKey(2)) return null;

//     return out;
//   }
// }
