import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class TableOptions {
  /*final*/ bool isLoadingData;
  /*final*/ String repID;
  /*final*/ List<PlutoRow> tableRows;
  /*final*/ List<PlutoColumn> tableColumns;
  /*final*/ String? pdfTitle;
  /*final*/ String? fullScreenTitle;
  // double? totalAll;
  /*final*/ List<String> tatalTopTitle;
  /*final*/ String? groupRowByColumnName;
  /*final*/ int pageSize;
  // bool columnPerPageSumVisible = true ;
  /*final*/ bool pagetion;
  /*final*/ bool showColumnFilter;
  /*final*/ bool showTableHeader;
  /*final*/ Widget? title;

  /*final*/ List<String> defultPdf;
  /*final*/ List<String> defultExcel;
  /*final*/ bool showPdfSumLastRow;
  // pw.Widget? pdfHeader;
  // pw.Widget? pdfFooter;
  /*final*/ bool fullScreenWithAddedCouumon;
  bool isFullScreenMode;

  //

  TableOptions({
    required this.isLoadingData,
    required this.repID,
    required this.tableRows,
    required this.tableColumns,
    this.pdfTitle = "",
    this.fullScreenTitle = "",
    this.pagetion = false,
    this.showColumnFilter = false,
    this.showTableHeader = true,
    this.title,
    this.tatalTopTitle = const [],
    this.groupRowByColumnName,
    this.pageSize = 100,
    this.showPdfSumLastRow = true,
    this.fullScreenWithAddedCouumon = false,
    this.defultPdf = const [],
    this.defultExcel = const [],
    this.isFullScreenMode = false,
  });
}
