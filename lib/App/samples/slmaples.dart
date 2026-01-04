// import 'package:masaratapp/App/utils/utils.dart';

import '../Models/user_model.dart';
import '../Print/helpers/widgets_to_json.dart';

class PrintSamples {
  late CompData _compData;
  PrintSamples({required CompData compData}) {
    _compData = compData;
  }

  get getSlsShowSample => _slsShowSample(compData: _compData);

  get getSlsInvoiceSample => _slsInvoiceSample(compData: _compData);

  get getCusKshfSample => _cusKshfSample(compData: _compData);

  get getActKshfSample => _actKshfSample(compData: _compData);

  get getSanadSample => _sanadSample(compData: _compData);

  static Map<String, dynamic> _slsInvoiceSample({required CompData compData}) {
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

          sizedBoxW(height: 20),
          spacerW(),
          //footer totals
          containerW(
            containerDecorationW: containerDecorationW(
              containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
              radius: 4,
            ),
            child: columnW(
              children: [
                //Qr
                rowW(
                  mainAxisAlignment: "spaceBetween",
                  children: [
                    // expandedW(
                    //   child:
                    centerW(
                      child: qrCodeW(
                        data: "{{qr_data}}",
                        border: containerDecorationBorderW(
                          width: 0.5,
                          color: '#000000',
                        ),
                        borderRadius: 4,
                        padding: 10,
                      ),
                    ),
                    // ),
                    columnW(
                      crossAxisAlignment: 'end',
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
                        rowW(
                          children: [
                            containerW(
                              width: 120,
                              padding: [5, 5, 5, 5],
                              containerDecorationW: containerDecorationW(
                                containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                                radius: 4,
                              ),
                              child: textW("{{t_ttl_dis}}"),
                            ),
                            containerW(
                              width: 100,
                              padding: [5, 5, 5, 5],
                              containerDecorationW: containerDecorationW(
                                containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                                radius: 4,
                              ),
                              child: textW("{{ttl_dis}}"),
                            ),
                          ],
                        ),
                        //Row3

                        rowW(
                          children: [
                            containerW(
                              width: 120,
                              padding: [5, 5, 5, 5],
                              containerDecorationW: containerDecorationW(
                                containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                                radius: 4,
                              ),
                              child: textW("{{t_ttl_aftr_dis}}"),
                            ),
                            containerW(
                              width: 100,
                              padding: [5, 5, 5, 5],
                              containerDecorationW: containerDecorationW(
                                containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
                                radius: 4,
                              ),
                              child: textW("{{ttl_aftr_dis}}"),
                            ),
                          ],
                        ),

                        //Row 4

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
                      ],
                    ),
                  ],
                ),
                //Row 5
                rowW(
                  mainAxisAlignment: "spaceBetween",
                  children: [
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
                rowW(
                  mainAxisAlignment: "spaceBetween",
                  children: [
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
                  ],
                ),
                //Row 3
                rowW(
                  mainAxisAlignment: "spaceBetween",
                  children: [
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Map<String, dynamic> _cusKshfSample({required CompData compData}) {
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
                  mainAxisAlignment: "center",
                  children: [
                    textW("{{t_kshf}}", fontSize: 16, fontWeight: "bold"),
                    sizedBoxW(width: 20),
                    textW("{{fromToDate}}", fontSize: 14),
                  ],
                ),

                dashedLineW(height: 1, dashSpace: 0.2),
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
                  mainAxisAlignment: "spaceAround",
                  children: [
                    rowW(
                      children: [
                        textW("{{t_ttl_PRV_BAL}}"),
                        textW("  :  "),
                        textW("{{ttl_PRV_BAL}}"),
                      ],
                    ),
                    rowW(
                      children: [
                        textW("{{t_ttl_BAL}}"),
                        textW("  :  "),
                        textW("{{ttl_BAL}}"),
                      ],
                    ),
                  ],
                ),
                dashedLineW(
                  height: 0.5,
                ),
              ],
            ),
          ),

          sizedBoxW(height: 4),
          tableW(
            tableWHeadersListOfMap: [
              tableWHeadersListOfMap(name: "{{h_srl}}"),
              tableWHeadersListOfMap(name: "{{h_ACT_TYPE}}"),
              tableWHeadersListOfMap(name: "{{h_ACT_NO}}"),
              tableWHeadersListOfMap(name: "{{h_DATE}}"),
              tableWHeadersListOfMap(name: "{{h_DESC}}", isFlex: true),
              tableWHeadersListOfMap(name: "{{h_DN}}"),
              tableWHeadersListOfMap(name: "{{h_MD}}"),
              tableWHeadersListOfMap(name: "{{h_BAL}}"),
            ],
            tableWHeaderStyle: tableWHeaderStyle(fontWeight: "bold", color: "#ffffff", fontSize: 14),
            tableWHeaderCellDecoration: tableWHeaderCellDecoration(color: '#7C4DFF', borderColor: "#ffffff", borderRadius: 4, borderWidth: 1),
            tableWCellStyle: tableWCellStyle(),
            tableWCellDecoration: tableWCellDecoration(
              borderRadius: 4,
              borderWidth: 0.2,
            ),
            tableWFooterDecoration: tableWFooterDecoration(
              borderRadius: 0,
              borderWidth: 0.1,
              borderColor: "#7C4DFF",
              color: "#7C4DFF",
            ),
            tableWFooterStyle: tableWFooterStyle(fontWeight: "bold", color: "#ffffff", fontSize: 14),
          ),

/*
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
                rowW(
                  mainAxisAlignment: "spaceBetween",
                  children: [
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
                  ],
                ),
                //Row 3
                rowW(
                  mainAxisAlignment: "spaceBetween",
                  children: [
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
                  ],
                ),
              ],
            ),
          ),
    
    */
        ],
      ),
    );
  }

  static Map<String, dynamic> _actKshfSample({required CompData compData}) {
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

          sizedBoxW(height: 5),

          //kashf info
          rowW(
            mainAxisAlignment: "center",
            children: [
              textW("{{t_mragah}}", fontSize: 16, fontWeight: "bold"),
            ],
          ),
          rowW(
            mainAxisAlignment: "center",
            children: [
              textW("{{cus_no}}", fontSize: 14),
              sizedBoxW(width: 10),
              textW("{{cus_name}}", fontSize: 14),
            ],
          ),
          rowW(
            mainAxisAlignment: "center",
            children: [
              textW("{{fromToDate}}", fontSize: 14),
            ],
          ),

          // containerW(
          //   padding: [20, 5, 20, 5],
          //   containerDecorationW: containerDecorationW(
          //     containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
          //     radius: 2,
          //   ),
          //   child: columnW(
          //     children: [
          //      //
          //     ],
          //   ),
          // ),

          sizedBoxW(height: 4),
          tableW(
            tableWHeadersListOfMap: [
              tableWHeadersListOfMap(name: "{{h_srl}}"),
              tableWHeadersListOfMap(name: "{{h_ACT_TYPE}}"),
              tableWHeadersListOfMap(name: "{{h_ACT_NO}}"),
              tableWHeadersListOfMap(name: "{{h_DATE}}"),
              tableWHeadersListOfMap(name: "{{h_DESC}}", isFlex: true),
              tableWHeadersListOfMap(name: "{{h_TTL}}"),
            ],
            tableWHeaderStyle: tableWHeaderStyle(fontWeight: "bold", color: "#ffffff", fontSize: 14),
            tableWHeaderCellDecoration: tableWHeaderCellDecoration(color: '#7C4DFF', borderColor: "#ffffff", borderRadius: 4, borderWidth: 1),
            tableWCellStyle: tableWCellStyle(),
            tableWCellDecoration: tableWCellDecoration(
              borderRadius: 4,
              borderWidth: 0.2,
            ),
            tableWFooterDecoration: tableWFooterDecoration(
              borderRadius: 0,
              borderWidth: 0.1,
              borderColor: "#7C4DFF",
              color: "#7C4DFF",
            ),
            tableWFooterStyle: tableWFooterStyle(fontWeight: "bold", color: "#ffffff", fontSize: 14),
          ),
        ],
      ),
    );
  }

  static Map<String, dynamic> _sanadSample({required CompData compData}) {
    return containerW(
      height: 328,
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
                              "{{t_commercial_reg}}",
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
                              "{{t_tax_no}}",
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
                              "{{t_mobile_no}}",
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
          //type & date  & amount
          rowW(
            children: [
              //amount
              expandedW(
                // flex: 1,
                child: containerW(
                  padding: [5, 5, 5, 5],
                  // margin: [10, 0, 0, 0],
                  containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)),
                  child: rowW(
                    mainAxisAlignment: "center",
                    children: [
                      textW("{{t_amount}}", fontSize: 14),
                      textW("   :   ", fontSize: 14),
                      textW("{{amount}}", fontSize: 14),
                      sizedBoxW(width: 10),
                      imageSvgW(
                        assetName: "assets/images/rs.svg",
                        height: 18,
                        width: 18,
                      ),
                    ],
                  ),
                ),
              ),

              //sanad No
              expandedW(
                flex: 2,
                child: containerW(
                  padding: [5, 5, 5, 5],
                  margin: [10, 0, 10, 0],
                  containerDecorationW: containerDecorationW(
                    radius: 4,
                    containerDecorationBorderW: containerDecorationBorderW(width: 1),
                  ),
                  child: rowW(
                    mainAxisAlignment: "center",
                    children: [
                      textW(
                        "{{t_sanad_type}}",
                        fontSize: 14,
                        textAlign: "center",
                        // fontWeight: "bold",
                      ),
                    ],
                  ),
                ),
              ),

              //Date
              expandedW(
                // flex: 1,
                child: containerW(
                  padding: [5, 5, 5, 5],
                  // margin: [0, 0, 10, 0],
                  containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)),
                  child: rowW(
                    mainAxisAlignment: "center",
                    children: [
                      textW("{{t_date}}", fontSize: 14),
                      textW("   :   ", fontSize: 14),
                      textW("{{date}}", fontSize: 14),
                      // sizedBoxW(width: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),

          //content
          containerW(
            // height: 300,
            margin: [0, 5, 0, 0],
            padding: [5, 5, 5, 5],
            containerDecorationW: containerDecorationW(
              radius: 8,
              containerDecorationBorderW: containerDecorationBorderW(width: 0.5),
            ),
            child: columnW(
              children: [
                // 1st  row
                rowW(
                  children: [
                    expandedW(
                      flex: 1,
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: textW("{{a_t_recive_from}}"),
                      ),
                    ),
                    expandedW(
                      flex: 3,
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: textW("{{cus_name}}"),
                      ),
                    ),
                    expandedW(
                      flex: 1,
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: textW("{{e_t_recive_from}}"),
                      ),
                    ),
                  ],
                ),

                //2nd row
                rowW(
                  children: [
                    expandedW(
                      flex: 1,
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: textW("{{a_t_amount_words}}"),
                      ),
                    ),
                    expandedW(
                      flex: 3,
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: textW("{{amount_words}}", doubleToArabicWords: true),
                      ),
                    ),
                    expandedW(
                      flex: 1,
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(radius: 4, containerDecorationBorderW: containerDecorationBorderW(width: 1)),
                        child: textW("{{e_t_amount_words}}"),
                      ),
                    ),
                  ],
                ),

                //3rd row
                rowW(
                  children: [
                    expandedW(
                      flex: 1,
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: textW("{{a_t_payment_for}}"),
                      ),
                    ),
                    expandedW(
                      flex: 3,
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: textW("{{payment_for}}"),
                      ),
                    ),
                    expandedW(
                      flex: 1,
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: textW("{{e_t_payment_for}}"),
                      ),
                    ),
                  ],
                ),

                //3rd row
                rowW(
                  children: [
                    expandedW(
                      child: containerW(
                        height: 32,
                        margin: [1, 1, 1, 1],
                        padding: [5, 5, 5, 5],
                        containerDecorationW: containerDecorationW(
                          color: "#F5F5F5",
                          radius: 4,
                          containerDecorationBorderW: containerDecorationBorderW(width: 1),
                        ),
                        child: rowW(
                          mainAxisAlignment: "center",
                          children: [
                            textW("{{t_user_ins}}"),
                            textW("  <=>  "),
                            textW("{{user_ins}}"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
