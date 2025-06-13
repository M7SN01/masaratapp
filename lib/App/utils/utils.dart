// lib/utils/constants.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

const Color primaryColor = Colors.deepPurpleAccent;
const Color secondaryColor = Color(0XFFF5387C);
const Color saveColor = Color(0XFF37beac);
const Color oddRowColor = Color(0xFFFFFFFF);
const Color evenRowColor = Color(0xFFF6F6F6);
const Color disabledColor = Colors.grey;

String convertToArabicWords(double amount) {
  final units = ['', 'واحد', 'اثنان', 'ثلاثة', 'أربعة', 'خمسة', 'ستة', 'سبعة', 'ثمانية', 'تسعة'];
  final tens = ['', 'عشرة', 'عشرون', 'ثلاثون', 'أربعون', 'خمسون', 'ستون', 'سبعون', 'ثمانون', 'تسعون'];
  final teens = ['عشرة', 'أحد عشر', 'اثنا عشر', 'ثلاثة عشر', 'أربعة عشر', 'خمسة عشر', 'ستة عشر', 'سبعة عشر', 'ثمانية عشر', 'تسعة عشر'];
  final hundreds = ['', 'مائة', 'مائتان', 'ثلاثمائة', 'أربعمائة', 'خمسمائة', 'ستمائة', 'سبعمائة', 'ثمانمائة', 'تسعمائة'];

  String numberToWords(int number) {
    if (number == 0) return 'صفر';

    if (number < 10) return units[number];

    if (number < 20) return teens[number - 10];

    if (number < 100) {
      int unit = number % 10;
      int ten = number ~/ 10;
      return unit == 0 ? tens[ten] : '${units[unit]} و ${tens[ten]}';
    }

    if (number < 1000) {
      int hundred = number ~/ 100;
      int rest = number % 100;
      return rest == 0 ? hundreds[hundred] : '${hundreds[hundred]} و ${numberToWords(rest)}';
    }

    if (number < 1000000) {
      int thousands = number ~/ 1000;
      int rest = number % 1000;

      String thousandWord;
      if (thousands == 1) {
        thousandWord = 'ألف';
      } else if (thousands == 2) {
        thousandWord = 'ألفان';
      } else if (thousands <= 10) {
        thousandWord = '${numberToWords(thousands)} آلاف';
      } else {
        thousandWord = '${numberToWords(thousands)} ألف';
      }

      return rest == 0 ? thousandWord : '$thousandWord و ${numberToWords(rest)}';
    }

    if (number < 1000000000) {
      int millions = number ~/ 1000000;
      int rest = number % 1000000;

      String millionWord;
      if (millions == 1) {
        millionWord = 'مليون';
      } else if (millions == 2) {
        millionWord = 'مليونان';
      } else if (millions <= 10) {
        millionWord = '${numberToWords(millions)} ملايين';
      } else {
        millionWord = '${numberToWords(millions)} مليون';
      }

      return rest == 0 ? millionWord : '$millionWord و ${numberToWords(rest)}';
    }

    return number.toString(); // fallback
  }

  int riyal = amount.floor();
  int halala = ((amount - riyal) * 100).round();

  String riyalPart = '${numberToWords(riyal)} ريال';
  String halalaPart = halala > 0 ? ' و ${numberToWords(halala)} هللة' : '';

  return riyalPart + halalaPart;
}

final PlutoGridConfiguration configuration = PlutoGridConfiguration(
  localeText: const PlutoGridLocaleText.arabic(),
  scrollbar: PlutoGridScrollbarConfig(
    enableScrollAfterDragEnd: true,
    scrollbarThickness: 5,
    scrollBarColor: primaryColor,
    scrollbarRadius: const Radius.circular(12),
  ),
  style: PlutoGridStyleConfig(
    oddRowColor: oddRowColor,
    evenRowColor: evenRowColor,
    gridBorderColor: Colors.grey,
    iconColor: Colors.white,
    // filterHeaderColor: primaryColor,
    gridPopupBorderRadius: BorderRadius.circular(8),
    gridBorderRadius: BorderRadius.circular(8),
    enableColumnBorderVertical: true,
    enableColumnBorderHorizontal: true,
    enableCellBorderHorizontal: true,
  ),
);

WidgetSpan autoMultiLineColumn(String title) {
  return WidgetSpan(
    child: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

String formatCurrency(String amountStr) {
  try {
    double amount = double.parse(amountStr);
    final formatter = NumberFormat("#,##0.00");
    return formatter.format(amount);
  } catch (e) {
    return amountStr;
  }
}

String checkNullString(String val) {
  return val == "null" ? "" : val;
}

class UserColumnMenu implements PlutoColumnMenuDelegate<UserColumnMenuItem> {
  // BuildContext context;
  // UserColumnMenu({required this.context});
  @override
  List<PopupMenuEntry<UserColumnMenuItem>> buildMenuItems({
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
  }) {
    return [
      PopupMenuItem<UserColumnMenuItem>(
        value: column.frozen.isStart ? UserColumnMenuItem.unfrozeColumn : UserColumnMenuItem.frozeColumnStart,
        height: 36,
        enabled: true,
        child: Text(column.frozen.isStart ? 'الغاء التثبيت' : 'تثبيت في لبداية', style: const TextStyle(fontSize: 13)),
      ),
      PopupMenuItem<UserColumnMenuItem>(
        value: column.frozen.isEnd ? UserColumnMenuItem.unfrozeColumn : UserColumnMenuItem.frozeColumnEnd,
        height: 36,
        enabled: true,
        child: Text(column.frozen.isEnd ? 'الغاء التثبيت' : 'تثبيت في النهاية', style: const TextStyle(fontSize: 13)),
      ),
      const PopupMenuItem<UserColumnMenuItem>(
        value: UserColumnMenuItem.hideColumn,
        height: 36,
        enabled: true,
        child: Text('اخفاء', style: TextStyle(fontSize: 13)),
      ),
      const PopupMenuItem<UserColumnMenuItem>(
        value: UserColumnMenuItem.filterColumn,
        height: 36,
        enabled: true,
        child: Text('فلترة العمود', style: TextStyle(fontSize: 13)),
      ),
    ];
  }

  @override
  void onSelected({
    required BuildContext context,
    required PlutoGridStateManager stateManager,
    required PlutoColumn column,
    required bool mounted,
    required UserColumnMenuItem? selected,
  }) {
    switch (selected) {
      case UserColumnMenuItem.frozeColumnStart:
        // if (column.frozen.isFrozen) {
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.none);
        // } else {
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.start);
        // }
        break;
      case UserColumnMenuItem.frozeColumnEnd:
        // if (column.frozen.isStart) {
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.none);
        // } else {
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.end);
        // }
        break;
      case UserColumnMenuItem.unfrozeColumn:
        stateManager.toggleFrozenColumn(column, PlutoColumnFrozen.none);
        break;

      case UserColumnMenuItem.hideColumn:
        stateManager.hideColumn(notify: true, column, true);

      case UserColumnMenuItem.filterColumn:
        stateManager.setColumnSizeConfig(PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.scale));

        stateManager.showFilterPopup(
          context,
          calledColumn: PlutoColumn(
            title: column.title,
            field: column.field,
            type: column.type,
            backgroundColor: primaryColor,
          ),
          //   onClosed: () {
          //      // stateManager.setColumnSizeConfig(PlutoGridColumnSizeConfig(autoSizeMode: PlutoAutoSizeMode.none));
          // stateManager.setConfiguration(_configuration);
          // // stateManager.updateVisibilityLayout();
          // print("Colsed");
          //   },
        );

        break;

      case null:
        break;
    }
  }
}

enum UserColumnMenuItem {
  frozeColumnStart,
  frozeColumnEnd,
  unfrozeColumn,
  hideColumn,
  filterColumn,
}

class ShowTableFullSreccn extends StatefulWidget {
  final Widget child;
  final Text? title;
  const ShowTableFullSreccn({super.key, required this.child, this.title});

  @override
  State<ShowTableFullSreccn> createState() => _ShowTableFullSreccnState();
}

class _ShowTableFullSreccnState extends State<ShowTableFullSreccn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title ?? widget.title,
      ),
      body: widget.child,
    );
  }
}
