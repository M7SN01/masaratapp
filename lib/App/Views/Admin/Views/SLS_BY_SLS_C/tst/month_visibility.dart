// import 'package:intl/intl.dart';
// import 'package:pluto_grid/pluto_grid.dart';

// class MonthColumnController {
//   static void apply(List<PlutoColumn> columns, String from, String to) {
//     int? fromMonth;
//     int? toMonth;

//     if (from.isNotEmpty && to.isNotEmpty) {
//       fromMonth = DateFormat('yyyy-MM-dd').parse(from).month;
//       toMonth = DateFormat('yyyy-MM-dd').parse(to).month;
//     }

//     for (final col in columns) {
//       if (!_isMonth(col.field)) continue;

//       final m = int.parse(col.field);

//       if (fromMonth != null) {
//         col.hide = m < fromMonth || m > toMonth!;
//       } else {
//         col.hide = m > DateTime.now().month;
//       }
//     }
//   }

//   static bool _isMonth(String f) => int.tryParse(f) != null;
// }
