// import '../Models/user_model.dart';
// import '../Print/helpers/widgets_to_json.dart';

// Map<String, dynamic> slsShowSample({required CompData compData}) {
//   return containerW(
//     padding: [10, 10, 10, 10],
//     containerDecorationW: containerDecorationW(
//       containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
//       radius: 4,
//     ),
//     child: columnW(
//       children: [
//         //Comp Header
//         sizedBoxW(
//           height: 110,
//           child: rowW(
//             children: [
//               //Comp Arabic
//               expandedW(
//                 flex: 1,
//                 child: columnW(
//                   crossAxisAlignment: "center",
//                   children: [
//                     textW(
//                       "{{comp_name_a}}",
//                       // "شركة مسارات الجمال",
//                       fontSize: 18,
//                       // textAlign: "center",
//                       fontWeight: "bold",
//                     ),
//                     textW(
//                       "{{a_activity}}",
//                       // "لبيع العطور ومستحضرات التجميل",
//                       fontSize: 14,
//                       // textAlign: "center",
//                       fontWeight: "bold",
//                     ),
//                     // sizedBoxW(height: 2),
//                     if (compData.commercialReg.isNotEmpty)
//                       rowW(
//                         mainAxisAlignment: "center",
//                         children: [
//                           textW(
//                             "رقم السجل التجاري",
//                           ),
//                           textW(
//                             "  :  ",
//                           ),
//                           textW(
//                             "{{commercial_reg}}",
//                           ),
//                         ],
//                       ),
//                     // sizedBoxW(height: 2),
//                     if (compData.taxNo.isNotEmpty)
//                       rowW(
//                         mainAxisAlignment: "center",
//                         children: [
//                           textW(
//                             "الرقم الضريبي",
//                             fontSize: 14,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             "  :  ",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             compData.taxNo,
//                             // "310310589800003",
//                             fontSize: 14,
//                             // fontFamily: "arial",
//                           ),
//                         ],
//                       ),
//                     if (compData.tel.isNotEmpty)
//                       rowW(
//                         mainAxisAlignment: "center",
//                         children: [
//                           textW(
//                             "رقم الهاتف",
//                             fontSize: 14,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             "  :  ",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             compData.tel,
//                             // "310310589800003",
//                             fontSize: 14,
//                             // fontFamily: "arial",
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//               //logo
//               expandedW(
//                 flex: 1,
//                 child: containerW(padding: [0, 0, 0, 10], child: centerW(child: imageW(assetName: "assets/images/mlogo.png"))),
//               ),
//               //Comp english
//               expandedW(
//                 flex: 1,
//                 child: columnW(
//                   crossAxisAlignment: "center",
//                   children: [
//                     textW(
//                       compData.eCompName,
//                       // "MASARAT AL-JAMAL",
//                       fontSize: 18,
//                       textAlign: "center",
//                       fontWeight: "bold",
//                     ),
//                     textW(
//                       compData.eActivity,
//                       // "For selling perfumes and cosmetics",
//                       fontSize: 12,
//                       textAlign: "center",
//                       fontWeight: "bold",
//                     ),
//                     // sizedBoxW(height: 2),
//                     if (compData.commercialReg.isNotEmpty)
//                       rowW(
//                         mainAxisAlignment: "center",
//                         children: [
//                           textW(
//                             compData.commercialReg,
//                             // "4030323869",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             "  :  ",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             "REG. NO.",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                         ],
//                       ),
//                     // sizedBoxW(height: 2),
//                     if (compData.taxNo.isNotEmpty)
//                       rowW(
//                         mainAxisAlignment: "center",
//                         children: [
//                           textW(
//                             compData.taxNo,
//                             // "310310589800003",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             "  :  ",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             "TAX. NO. ",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                         ],
//                       ),
//                     if (compData.tel.isNotEmpty)
//                       rowW(
//                         mainAxisAlignment: "center",
//                         children: [
//                           textW(
//                             compData.tel,
//                             // "310310589800003",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             "  :  ",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                           textW(
//                             "Mobile No.",
//                             // fontSize: 12,
//                             // fontFamily: "arial",
//                           ),
//                         ],
//                       ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         //header line
//         rowW(
//           children: [
//             expandedW(
//               child: containerW(
//                 containerDecorationW: containerDecorationW(
//                   containerDecorationBorderW: containerDecorationBorderW(width: 1),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         // rowW(children: [expandedW(child: dashedLineW(dashSpace: 1, dashWidth: 2, height: 1))]),
//         // expandedW(child: dashedLineW(dashSpace: 1, dashWidth: 2, height: 1)),
//         sizedBoxW(height: 10),

//         //Data--------------------
//         containerW(
//           containerDecorationW: containerDecorationW(
//             containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
//           ),
//           width: 200,
//           height: 100,
//         ),
//         //details
//         containerW(
//           containerDecorationW: containerDecorationW(
//             containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
//           ),
//           child: repateW(
//             child: rowW(
//               children: [
//                 expandedW(
//                   // flex: 2,
//                   child: containerW(
//                     // decoration: containerDecorationW(border: containerDecorationBorderW(width: 0.2)),
//                     padding: [0, 2, 0, 2],
//                     child: textW("{{id}}", textAlign: "center"),
//                   ),
//                 ),
//                 expandedW(
//                   child: containerW(
//                     // decoration: containerDecorationW(border: containerDecorationBorderW(width: 0.2)),
//                     padding: [0, 2, 0, 2],
//                     child: textW("{{name}}", textAlign: "center"),
//                   ),
//                 ),
//                 expandedW(
//                   // flex: 1,
//                   child: containerW(
//                     // decoration: containerDecorationW(radius: 4, border: containerDecorationBorderW(width: 0.2)),
//                     padding: [0, 2, 0, 2],
//                     child: textW("{{qty}}", textAlign: "center"),
//                   ),
//                 ),
//                 expandedW(
//                   // flex: 2,
//                   child: containerW(
//                     // decoration: containerDecorationW( border: containerDecorationBorderW(width: 0.2)),
//                     padding: [0, 2, 0, 2],
//                     child: textW("{{price}}", textAlign: "center"),
//                   ),
//                 ),
//                 expandedW(
//                   // flex: 2,
//                   child: containerW(
//                     // decoration: containerDecorationW(border: containerDecorationBorderW(width: 0.2)),
//                     padding: [0, 2, 0, 2],
//                     child: textW("{{total}}", textAlign: "center"),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           /*
//                columnW(
//                 children: List.generate(
//                     invoiceItems.length,
//                     (index) => columnW(children: [
//                           rowW(
//                             children: [
//                               expandedW(
//                                 // flex: 2,
//                                 child: containerW(
//                                   // decoration: containerDecorationW(border: containerDecorationBorderW(width: 0.2)),
//                                   padding: [0, 2, 0, 2],
//                                   child: textW(invoiceItems[index].id, textAlign: "center"),
//                                 ),
//                               ),
//                               expandedW(
//                                 child: containerW(
//                                   // decoration: containerDecorationW(border: containerDecorationBorderW(width: 0.2)),
//                                   padding: [0, 2, 0, 2],
//                                   child: textW(invoiceItems[index].name, textAlign: "center"),
//                                 ),
//                               ),
//                               expandedW(
//                                 // flex: 1,
//                                 child: containerW(
//                                   // decoration: containerDecorationW(radius: 4, border: containerDecorationBorderW(width: 0.2)),
//                                   padding: [0, 2, 0, 2],
//                                   child: textW(invoiceItems[index].qty.toString(), textAlign: "center"),
//                                 ),
//                               ),
//                               expandedW(
//                                 // flex: 2,
//                                 child: containerW(
//                                   // decoration: containerDecorationW( border: containerDecorationBorderW(width: 0.2)),
//                                   padding: [0, 2, 0, 2],
//                                   child: textW(invoiceItems[index].price.toString(), textAlign: "center"),
//                                 ),
//                               ),
//                               expandedW(
//                                 // flex: 2,
//                                 child: containerW(
//                                   // decoration: containerDecorationW(border: containerDecorationBorderW(width: 0.2)),
//                                   padding: [0, 2, 0, 2],
//                                   child: textW(invoiceItems[index].total.toStringAsFixed(2), textAlign: "center"),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           if (invoiceItems.length - 1 != index) dashedLineW(),

//                           // rowW(children: [
//                           //   expandedW(
//                           //     // flex: 2,
//                           //     child: containerW(
//                           //       decoration: containerDecorationW(border: containerDecorationBorderW(width: 0.2)),
//                           //       // padding: [0, 2, 0, 2],
//                           //       // child: textW(invoiceItems[index].id, textAlign: "center"),
//                           //     ),
//                           //   ),
//                           // ]),
//                         ])),
//               ),
//            */
//         ),
//       ],
//     ),
//   );
// }
