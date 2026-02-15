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
  // /*final*/ bool fullScreenWithAddedCouumon;
  bool isFullScreenMode;

  //

  TableOptions({
    required this.isLoadingData,
    required this.repID,
    required this.tableRows,
    required this.tableColumns,
    this.pdfTitle = "",
    this.fullScreenTitle,
    this.pagetion = false,
    this.showColumnFilter = false,
    this.showTableHeader = true,
    this.title,
    this.tatalTopTitle = const [],
    this.groupRowByColumnName,
    this.pageSize = 100,
    this.showPdfSumLastRow = true,
    // this.fullScreenWithAddedCouumon = false,
    this.defultPdf = const [],
    this.defultExcel = const [],
    this.isFullScreenMode = false,
  });

  TableOptions copyWith({
    bool? isLoadingData,
    String? repID,
    List<PlutoRow>? tableRows,
    List<PlutoColumn>? tableColumns,
    String? pdfTitle,
    String? fullScreenTitle,
    List<String>? tatalTopTitle,
    String? groupRowByColumnName,
    int? pageSize,
    bool? pagetion,
    bool? showColumnFilter,
    bool? showTableHeader,
    Widget? title,
    List<String>? defultPdf,
    List<String>? defultExcel,
    bool? showPdfSumLastRow,
    // bool? fullScreenWithAddedCouumon,
    bool? isFullScreenMode,
  }) {
    return TableOptions(
      isLoadingData: isLoadingData ?? this.isLoadingData,
      repID: repID ?? this.repID,
      tableRows: tableRows != null ? List<PlutoRow>.from(tableRows) : List<PlutoRow>.from(this.tableRows),
      tableColumns: tableColumns != null ? List<PlutoColumn>.from(tableColumns) : List<PlutoColumn>.from(this.tableColumns),
      pdfTitle: pdfTitle ?? this.pdfTitle,
      fullScreenTitle: fullScreenTitle ?? this.fullScreenTitle,
      tatalTopTitle: tatalTopTitle ?? List<String>.from(this.tatalTopTitle),
      groupRowByColumnName: groupRowByColumnName ?? this.groupRowByColumnName,
      pageSize: pageSize ?? this.pageSize,
      pagetion: pagetion ?? this.pagetion,
      showColumnFilter: showColumnFilter ?? this.showColumnFilter,
      showTableHeader: showTableHeader ?? this.showTableHeader,
      title: title ?? this.title,
      defultPdf: defultPdf ?? List<String>.from(this.defultPdf),
      defultExcel: defultExcel ?? List<String>.from(this.defultExcel),
      showPdfSumLastRow: showPdfSumLastRow ?? this.showPdfSumLastRow,
      // fullScreenWithAddedCouumon: fullScreenWithAddedCouumon ?? this.fullScreenWithAddedCouumon,
      isFullScreenMode: isFullScreenMode ?? this.isFullScreenMode,
    );
  }
}
