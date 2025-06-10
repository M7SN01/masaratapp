import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../utils/utils.dart';

class PickDateW extends StatefulWidget {
  final TextEditingController dateDontroller;
  final String labelText;
  final double filedHeight;
  final Function onSelectionChanged;
  final int expandedFlix;
  const PickDateW({
    super.key,
    required this.dateDontroller,
    this.filedHeight = 45,
    required this.onSelectionChanged,
    this.labelText = "",
    this.expandedFlix = 1,
  });

  @override
  State<PickDateW> createState() => _PickDateWState();
}

class _PickDateWState extends State<PickDateW> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.expandedFlix,
      child: SizedBox(
        height: widget.filedHeight,
        child: TextFormField(
          // textAlignVertical: const TextAlignVertical(y: 0.5),
          controller: widget.dateDontroller,
          readOnly: true,
          onTap: () {
            showDialog(
              useRootNavigator: true,
              useSafeArea: true,
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  content: SizedBox(
                    width: 300,
                    height: 400,
                    child: SfDateRangePicker(
                      initialSelectedDate: widget.dateDontroller.text == ""
                          ? null
                          : DateFormat('yyyy-MM-dd').parse(
                              widget.dateDontroller.text,
                            ),
                      selectionColor: widget.dateDontroller.text == "" ? Colors.transparent : const Color(0xFF337ab7),
                      selectionTextStyle: widget.dateDontroller.text == ""
                          ? const TextStyle(color: Colors.black)
                          : const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      showNavigationArrow: true,
                      navigationMode: DateRangePickerNavigationMode.snap,
                      headerHeight: 50,
                      headerStyle: const DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(fontSize: 25),
                      ),
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                        dayFormat: 'EEE',
                        viewHeaderStyle: DateRangePickerViewHeaderStyle(
                          textStyle: TextStyle(fontSize: 12),
                        ),
                      ),
                      onSelectionChanged: (p0) {
                        String date = DateFormat('yyyy-MM-dd').format(DateTime.parse(p0.value.toString())).toString();

                        setState(() {
                          widget.dateDontroller.text = date;
                          widget.onSelectionChanged();
                        });
                        //  }
                        Navigator.pop(context);
                      },
                      view: DateRangePickerView.month,
                    ),
                  ),
                );
              },
            );
          },
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            isDense: true,
            labelText: widget.labelText,
            prefixIcon: widget.dateDontroller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        widget.dateDontroller.text = "";
                      });
                    },
                    icon: const Icon(Icons.clear, color: Colors.red, size: 30),
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class PickMonthW extends StatefulWidget {
  final TextEditingController dateDontroller;
  final String labelText;
  final double filedHeight;
  final Function onSelectionChanged;
  final int expandedFlix;
  const PickMonthW({
    super.key,
    required this.dateDontroller,
    this.labelText = "",
    this.filedHeight = 45,
    required this.onSelectionChanged,
    this.expandedFlix = 1,
  });

  @override
  State<PickMonthW> createState() => _PickMonthWState();
}

class _PickMonthWState extends State<PickMonthW> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.expandedFlix,
      child: SizedBox(
        height: widget.filedHeight,
        child: TextFormField(
          controller: widget.dateDontroller,
          readOnly: true,
          textAlignVertical: const TextAlignVertical(y: -0.8),
          onTap: () {
            showDialog(
              useRootNavigator: true,
              useSafeArea: true,
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                  content: SizedBox(
                    width: 300,
                    height: 400,
                    child: SfDateRangePicker(
                      initialSelectedDate: widget.dateDontroller.text == "" ? null : DateFormat('yyyy-MM').parse(widget.dateDontroller.text),
                      selectionColor: widget.dateDontroller.text == "" ? Colors.transparent : const Color(0xFF337ab7),
                      selectionTextStyle: widget.dateDontroller.text == ""
                          ? const TextStyle(color: Colors.black)
                          : const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      todayHighlightColor: Colors.transparent,
                      showNavigationArrow: true,
                      headerHeight: 50,
                      headerStyle: const DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(fontSize: 25),
                        backgroundColor: primaryColor,
                      ),
                      onSelectionChanged: (p0) {
                        String date = DateFormat('yyyy-MM').format(DateTime.parse(p0.value.toString())).toString();
                        setState(() {
                          widget.dateDontroller.text = date;
                          widget.onSelectionChanged();
                        });

                        Navigator.pop(context);
                      },
                      monthViewSettings: const DateRangePickerMonthViewSettings(dayFormat: 'EEE', viewHeaderStyle: DateRangePickerViewHeaderStyle(textStyle: TextStyle(fontSize: 12))),
                      view: DateRangePickerView.year,
                      allowViewNavigation: false,
                    ),
                  ),
                );
              },
            );
          },
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: const OutlineInputBorder(),
            prefixIcon: widget.dateDontroller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        widget.dateDontroller.text = "";
                      });
                    },
                    icon: const Icon(Icons.clear, color: Colors.red),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

Widget switchW({required bool value, required Function(bool) state}) {
  return Switch(
    thumbColor: const WidgetStatePropertyAll(Color(0xFF337ab7)),
    trackColor: const WidgetStatePropertyAll(Colors.transparent),
    thumbIcon: const WidgetStatePropertyAll(Icon(Icons.date_range_outlined, color: Colors.white)),
    trackOutlineColor: const WidgetStatePropertyAll(Color(0xFF337ab7)),
    value: value,
    onChanged: (val) {
      state(val);
    },
  );
}
