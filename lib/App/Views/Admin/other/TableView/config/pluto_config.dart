import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../../../utils/utils.dart';

class PlutoConfig {
  static PlutoGridConfiguration get config => PlutoGridConfiguration(
        localeText: const PlutoGridLocaleText.arabic(),
        // columnSize: const PlutoGridColumnSizeConfig(
        //   resizeMode: PlutoResizeMode.pushAndPull,
        // ),

        scrollbar: PlutoGridScrollbarConfig(
          enableScrollAfterDragEnd: true,
          // dragDevices: Set.identity(),//this stop horzintal scroll
          scrollbarThicknessWhileDragging: BorderSide.strokeAlignOutside,
          draggableScrollbar: PlutoChangeNotifierFilter.enabled,
          scrollbarThickness: 5,
          // scrollbarRadiusWhileDragging: Radius.circular(12),
          // isAlwaysShown: true,
          scrollBarColor: const Color(0XFFB77033),
          scrollbarRadius: const Radius.circular(12),
        ),
        enableMoveHorizontalInEditing: true,
        style: PlutoGridStyleConfig(
          gridPopupBorderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          gridBorderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          gridBorderColor: Colors.grey,
          oddRowColor: oddRowColor, // Color.fromARGB(100, 238, 241, 238),
          evenRowColor: evenRowColor,

          // borderColor: Colors.transparent,

          enableColumnBorderVertical: true,
          enableColumnBorderHorizontal: true,
          enableCellBorderHorizontal: true,
          enableCellBorderVertical: false,
          iconColor: Colors.black, // _primaryColor,
          // gridBackgroundColor: _primaryColor,
          columnTextStyle: const TextStyle(color: Colors.white),

          // filterHeaderColor: primaryColor, ------------------------------------------committed
        ),
      );
}
