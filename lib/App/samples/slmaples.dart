import 'package:masaratapp/App/utils/utils.dart';

import '../Models/user_model.dart';
import '../Print/helpers/widgets_to_json.dart';

class PrintSamples {
  late CompData _compData;
  PrintSamples({required CompData compData}) {
    _compData = compData;
  }

  get getSlsShowSample => _slsShowSample(compData: _compData);

  static Map<String, dynamic> _slsShowSample({required CompData compData}) {
    return containerW(
      padding: [10, 10, 10, 10],
      containerDecorationW: containerDecorationW(
        containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
        radius: 2,
      ),
      child: columnW(
        children: [
          //Comp Header
          sizedBoxW(
            height: 110,
            child: rowW(
              children: [
                //Comp Arabic
                expandedW(
                  flex: 1,
                  child: columnW(
                    crossAxisAlignment: "center",
                    children: [
                      textW(
                        "{{a_comp_name}}",
                        // "شركة مسارات الجمال",
                        fontSize: 18,
                        // textAlign: "center",
                        fontWeight: "bold",
                      ),
                      textW(
                        "{{a_activity}}",
                        // "لبيع العطور ومستحضرات التجميل",
                        fontSize: 14,
                        // textAlign: "center",
                        fontWeight: "bold",
                      ),
                      // sizedBoxW(height: 2),
                      if (compData.commercialReg.isNotEmpty)
                        rowW(
                          mainAxisAlignment: "center",
                          children: [
                            textW(
                              "رقم السجل التجاري",
                            ),
                            textW(
                              "  :  ",
                            ),
                            textW(
                              "{{commercial_reg}}",
                            ),
                          ],
                        ),
                      // sizedBoxW(height: 2),
                      if (compData.taxNo.isNotEmpty)
                        rowW(
                          mainAxisAlignment: "center",
                          children: [
                            textW(
                              "الرقم الضريبي",
                              fontSize: 14,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "  :  ",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "{{tax_no}}",
                              // "310310589800003",
                              fontSize: 14,
                              // fontFamily: "arial",
                            ),
                          ],
                        ),
                      if (compData.tel.isNotEmpty)
                        rowW(
                          mainAxisAlignment: "center",
                          children: [
                            textW(
                              "رقم الهاتف",
                              fontSize: 14,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "  :  ",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "{{mobile_no}}",
                              // "310310589800003",
                              fontSize: 14,
                              // fontFamily: "arial",
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                //logo
                expandedW(
                  flex: 1,
                  child: containerW(
                    padding: [0, 0, 0, 10],
                    child: centerW(
                      child: imageW(assetName: "assets/images/mlogo.png"),
                    ),
                  ),
                ),
                //Comp english
                expandedW(
                  flex: 1,
                  child: columnW(
                    crossAxisAlignment: "center",
                    children: [
                      textW(
                        "{{e_comp_name}}",
                        // "MASARAT AL-JAMAL",
                        fontSize: 18,
                        textAlign: "center",
                        fontWeight: "bold",
                      ),
                      textW(
                        "{{e_activity}}",
                        // "For selling perfumes and cosmetics",
                        fontSize: 12,
                        textAlign: "center",
                        fontWeight: "bold",
                      ),
                      // sizedBoxW(height: 2),
                      if (compData.commercialReg.isNotEmpty)
                        rowW(
                          mainAxisAlignment: "center",
                          children: [
                            textW(
                              "{{commercial_reg}}",
                              // "4030323869",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "  :  ",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "REG. NO.",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                          ],
                        ),
                      // sizedBoxW(height: 2),
                      if (compData.taxNo.isNotEmpty)
                        rowW(
                          mainAxisAlignment: "center",
                          children: [
                            textW(
                              "{{tax_no}}",
                              // "310310589800003",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "  :  ",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "TAX. NO. ",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                          ],
                        ),
                      if (compData.tel.isNotEmpty)
                        rowW(
                          mainAxisAlignment: "center",
                          children: [
                            textW(
                              "{{mobile_no}}",
                              // "310310589800003",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "  :  ",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                            textW(
                              "Mobile No.",
                              // fontSize: 12,
                              // fontFamily: "arial",
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //header line
          rowW(
            children: [
              expandedW(
                child: containerW(
                  containerDecorationW: containerDecorationW(
                    containerDecorationBorderW: containerDecorationBorderW(width: 1),
                  ),
                ),
              ),
            ],
          ),

          sizedBoxW(height: 10),
          //ACT INFO & CUS INFO
          containerW(
            padding: [20, 5, 20, 5],
            containerDecorationW: containerDecorationW(
              containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
              radius: 2,
            ),
            child: columnW(
              children: [
                rowW(
                  children: [
                    expandedW(
                      child: rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW("{{t_inv_type}}"),
                          textW("  :  "),
                          textW("{{inv_type}}"),
                        ],
                      ),
                    ),
                    expandedW(
                      child: rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW("{{t_inv_no}}"),
                          textW("  :  "),
                          textW("{{inv_no}}"),
                        ],
                      ),
                    ),
                    expandedW(
                      child: rowW(
                        mainAxisAlignment: "center",
                        children: [
                          textW("{{t_inv_date}}"),
                          textW("  :  "),
                          textW("{{inv_date}}"),
                        ],
                      ),
                    )
                  ],
                ),

                dashedLineW(
                  height: 0.5,
                ),
                //
                rowW(
                  children: [
                    expandedW(
                      flex: 3,
                      child: rowW(
                        // mainAxisAlignment: "center",
                        children: [
                          textW("{{t_cus_no}}"),
                          textW("  :  "),
                          textW("{{cus_no}}"),
                        ],
                      ),
                    ),
                    expandedW(
                      flex: 5,
                      child: rowW(
                        // mainAxisAlignment: "center",
                        children: [
                          textW("{{t_cus_name}}"),
                          textW("  :  "),
                          textW("{{cus_name}}"),
                        ],
                      ),
                    ),
                  ],
                ),
                dashedLineW(
                  height: 0.5,
                ),
                //
                rowW(
                  children: [
                    expandedW(
                      flex: 3,
                      child: rowW(
                        // mainAxisAlignment: "center",
                        children: [
                          textW("{{t_cus_mobile}}"),
                          textW("  :  "),
                          textW("{{cus_mobile}}"),
                        ],
                      ),
                    ),
                    expandedW(
                      flex: 5,
                      child: rowW(
                        // mainAxisAlignment: "center",
                        children: [
                          textW("{{t_cus_adrs}}"),
                          textW("  :  "),
                          textW("{{cus_adrs}}"),
                        ],
                      ),
                    ),
                  ],
                ),
                dashedLineW(
                  height: 0.5,
                ),
                //
                rowW(
                  children: [
                    expandedW(
                      flex: 3,
                      child: rowW(
                        // mainAxisAlignment: "center",
                        children: [
                          textW("{{t_cus_tax_no}}"),
                          textW("  :  "),
                          textW("{{cus_tax_no}}"),
                        ],
                      ),
                    ),
                    expandedW(
                      flex: 5,
                      child: rowW(
                        // mainAxisAlignment: "center",
                        children: [
                          textW("{{t_inv_desc}}"),
                          textW("  :  "),
                          textW("{{inv_desc}}"),
                        ],
                      ),
                    ),
                  ],
                ),
                dashedLineW(
                  height: 0.5,
                ),
              ],
            ),
          ),

          //Data--------------------
          //Header
          /*
          containerW(
            padding: [2, 2, 2, 2],
            containerDecorationW: containerDecorationW(
              containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
              radius: 2,
            ),
            child: rowW(
              children: [
                containerW(
                  padding: [2, 2, 2, 2],
                  containerDecorationW: containerDecorationW(
                    containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                  ),
                  width: 25,
                  // height: 100,
                  child: textW("{{h_srl}}"),
                ),
                expandedW(
                  flex: 3,
                  child: containerW(
                    padding: [2, 2, 2, 2],
                    containerDecorationW: containerDecorationW(
                      containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                    ),
                    child: textW("{{h_item_id}}"),
                  ),
                ),
                expandedW(
                  flex: 6,
                  child: containerW(
                    padding: [2, 2, 2, 2],
                    containerDecorationW: containerDecorationW(
                      containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                    ),
                    child: textW("{{h_item_name}}"),
                  ),
                ),
                expandedW(
                  flex: 2,
                  child: containerW(
                    padding: [2, 2, 2, 2],
                    containerDecorationW: containerDecorationW(
                      containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                    ),
                    child: textW("{{h_unit}}"),
                  ),
                ),
                expandedW(
                  flex: 2,
                  child: containerW(
                    padding: [2, 2, 2, 2],
                    containerDecorationW: containerDecorationW(
                      containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                    ),
                    child: textW("{{h_item_qty}}"),
                  ),
                ),
                expandedW(
                  flex: 2,
                  child: containerW(
                    padding: [2, 2, 2, 2],
                    containerDecorationW: containerDecorationW(
                      containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                    ),
                    child: textW("{{h_item_price}}"),
                  ),
                ),
                expandedW(
                  flex: 2,
                  child: containerW(
                    padding: [2, 2, 2, 2],
                    containerDecorationW: containerDecorationW(
                      containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                    ),
                    child: textW("{{h_item_vat}}"),
                  ),
                ),
                expandedW(
                  flex: 3,
                  child: containerW(
                    padding: [2, 2, 2, 2],
                    containerDecorationW: containerDecorationW(
                      containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                    ),
                    child: textW("{{h_item_total}}"),
                  ),
                ),
              ],
            ),
          ),
*/
          sizedBoxW(height: 4),
          tableW(
            tableWHeadersListOfMap: [
              tableWHeadersListOfMap(name: "{{h_srl}}", width: 30),
              tableWHeadersListOfMap(name: "{{h_item_id}}", width: 90),
              tableWHeadersListOfMap(name: "{{h_item_name}}"),
              tableWHeadersListOfMap(name: "{{h_unit}}", width: 45),
              tableWHeadersListOfMap(name: "{{h_item_qty}}", width: 45),
              tableWHeadersListOfMap(name: "{{h_item_price}}", width: 70),
              tableWHeadersListOfMap(name: "{{h_item_vat}}", width: 70),
              tableWHeadersListOfMap(name: "{{h_item_total}}", width: 100),
            ],
            tableWHeaderStyle: tableWHeaderStyle(fontWeight: "bold", color: "#ffffff", fontSize: 14),
            tableWHeaderCellDecoration: tableWHeaderCellDecoration(color: '#7C4DFF', borderColor: "#ffffff", borderRadius: 4, borderWidth: 1),
            tableWCellStyle: tableWCellStyle(),
            tableWCellDecoration: tableWCellDecoration(
              borderRadius: 4,
              borderWidth: 0.2,
            ),
          ),

          //Details
          // containerW(
          //   containerDecorationW: containerDecorationW(
          //     // containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
          //     radius: 2,
          //   ),
          //   child: {
          //     "type": "table",
          //     "args": {
          //       // "columns": ["item_total", "item_vat", "item_price", "item_qty", "unit", "item_name", "item_id", "srl"],
          //       "headers": ["{{h_item_total}}", "{{h_item_vat}}", "{{h_item_price}}", "{{h_item_qty}}", "{{h_unit}}", "{{h_item_name}}", "{{h_item_id}}", "{{h_srl}}"]
          //     }
          //   },
          /*
            repateW(
              child: columnW(
                children: [
                  rowW(
                    crossAxisAlignment: "center",
                    // mainAxisAlignment: "start",
                    children: [
                      containerW(
                        padding: [2, 4, 4, 2],
                        // containerDecorationW: containerDecorationW(
                        //   containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                        //   radius: 2,
                        // ),
                        width: 25,
                        // height: 100,
                        child: textW("{{srl}}"),
                      ),
                      // ),
                      expandedW(
                        flex: 3,
                        child: containerW(
                          padding: [2, 4, 4, 2],
                          // containerDecorationW: containerDecorationW(
                          //   containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          //   radius: 2,
                          // ),
                          child: textW("{{item_id}}"),
                        ),
                      ),
                      expandedW(
                        flex: 6,
                        child: containerW(
                          padding: [2, 4, 4, 2],
                          // containerDecorationW: containerDecorationW(
                          //   containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          //   radius: 2,
                          // ),
                          child: textW("{{item_name}}"),
                        ),
                      ),
                      expandedW(
                        flex: 2,
                        child: containerW(
                          padding: [2, 4, 4, 2],
                          // containerDecorationW: containerDecorationW(
                          //   containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          //   radius: 2,
                          // ),
                          child: textW("{{unit}}"),
                        ),
                      ),
                      expandedW(
                        flex: 2,
                        child: containerW(
                          padding: [2, 4, 4, 2],
                          // containerDecorationW: containerDecorationW(
                          //   containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          //   radius: 2,
                          // ),
                          child: textW("{{item_qty}}"),
                        ),
                      ),
                      expandedW(
                        flex: 2,
                        child: containerW(
                          padding: [2, 4, 4, 2],
                          // containerDecorationW: containerDecorationW(
                          //   containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          //   radius: 2,
                          // ),
                          child: textW("{{item_price}}"),
                        ),
                      ),
                      expandedW(
                        flex: 2,
                        child: containerW(
                          padding: [2, 4, 4, 2],
                          // containerDecorationW: containerDecorationW(
                          //   containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          //   radius: 2,
                          // ),
                          child: textW("{{item_vat}}"),
                        ),
                      ),
                      expandedW(
                        flex: 3,
                        child: containerW(
                          padding: [2, 4, 4, 2],
                          // containerDecorationW: containerDecorationW(
                          //   containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          //   radius: 2,
                          // ),
                          child: textW("{{item_total}}"),
                        ),
                      ),
                    ],
                  ),
                  dashedLineW(dashSpace: 0, height: 0.5)
                ],
              ),
            ),
            */
          // ),

          sizedBoxW(height: 20),
          //footer totals
          containerW(
            containerDecorationW: containerDecorationW(
              containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
              radius: 4,
            ),
            child: columnW(
              children: [
                //Row 1
                rowW(
                  mainAxisAlignment: "end",
                  children: [
                    rowW(
                      children: [
                        sizedBoxW(width: 10),
                        textW("{{t_ttl_qty}}"),
                        sizedBoxW(width: 10),
                        containerW(
                          width: 45,
                          padding: [5, 5, 5, 5],
                          containerDecorationW: containerDecorationW(
                            containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                            radius: 4,
                          ),
                          child: textW("{{ttl_qty}}"),
                        ),
                        sizedBoxW(width: 22),
                      ],
                    ),
                    rowW(
                      children: [
                        containerW(
                          width: 120,
                          padding: [5, 5, 5, 5],
                          containerDecorationW: containerDecorationW(
                            containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                            radius: 4,
                          ),
                          child: textW("{{t_ttl_price}}"),
                        ),
                        containerW(
                          width: 100,
                          padding: [5, 5, 5, 5],
                          containerDecorationW: containerDecorationW(
                            containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                            radius: 4,
                          ),
                          child: textW("{{ttl_price}}"),
                        ),
                      ],
                    ),
                  ],
                ),
                //Row 2
                rowW(mainAxisAlignment: "spaceBetween", children: [
                  sizedBoxW(),
                  rowW(
                    children: [
                      containerW(
                        width: 120,
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          radius: 4,
                        ),
                        child: textW("{{t_ttl_vat}}"),
                      ),
                      containerW(
                        width: 100,
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          radius: 4,
                        ),
                        child: textW("{{ttl_vat}}"),
                      ),
                    ],
                  ),
                ]),
                //Row 3
                rowW(mainAxisAlignment: "spaceBetween", children: [
                  expandedW(
                    child: containerW(
                      padding: [5, 5, 5, 5],
                      containerDecorationW: containerDecorationW(
                        containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                        radius: 4,
                      ),
                      child: textW("{{ttl_aftr_vat}}", doubleToArabicWords: true),
                    ),
                  ),
                  rowW(
                    children: [
                      containerW(
                        width: 120,
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          radius: 4,
                        ),
                        child: textW("{{t_ttl_aftr_vat}}"),
                      ),
                      containerW(
                        width: 100,
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                          radius: 4,
                        ),
                        child: textW("{{ttl_aftr_vat}}"),
                      ),
                    ],
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
