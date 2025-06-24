import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaratapp/App/utils/utils.dart';

Widget dropDownList({
  required Function(String?) callback,
  required List<String> showedList,
  required String? chosedItem, // now nullable
  String initialText = "",
  Color? iconColor,
  Widget? icon,
  bool enable = true,
}) {
  return DropdownButtonHideUnderline(
    child: DropdownButton<String>(
      value: chosedItem,
      hint: Text(initialText),
      isDense: true,
      isExpanded: true,
      iconEnabledColor: iconColor,
      icon: icon,
      onChanged: enable
          ? (newValue) {
              callback(newValue);
              // state.didChange(newValue);
            }
          : null,
      items: showedList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    ),
  );
}

/*
class SearchListChkBx {
  String id;
  String name;
  bool state;

  SearchListChkBx({required this.id, required this.name, required this.state});
}

class CheckboxListWithSearch extends StatefulWidget {
  final List<SearchListChkBx> originalData;

  final String title;
  final Function(List<SearchListChkBx>) OnSave;
  const CheckboxListWithSearch({
    super.key,
    required this.originalData,
    required this.title,
    required this.OnSave,
  });
  @override
  State<CheckboxListWithSearch> createState() => CheckboxListWithSearchState();
}

class CheckboxListWithSearchState extends State<CheckboxListWithSearch> {
  // Sample data
  List<SearchListChkBx> options = [];
  List<SearchListChkBx> filteredOptions = [];

  @override
  void initState() {
    super.initState();
    // filteredOptions.addAll(options);
    options.clear();

    options = widget.originalData.map((item) => SearchListChkBx(id: item.id, name: item.name, state: item.state)).toList();
    // Sort the options list by chicked items
    options.sort((a, b) => b.state.toString().compareTo(a.state.toString())); // Sort in descending order, so true values come first
    filteredOptions.addAll(options);
  }

  void filterOptions(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredOptions = [];
        filteredOptions = options.where((option1) => option1.name.toLowerCase().contains(query.toLowerCase())).toList();
      } else {
        filteredOptions = List<SearchListChkBx>.from(options);
      }
    });
  }

  bool selectAll = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(widget.title),
          Checkbox(
              value: selectAll,
              onChanged: (bool? val) {
                setState(() {
                  selectAll = val!;
                  for (var element in filteredOptions) {
                    element.state = val;
                  }
                });
              }),
        ],
      ),
      backgroundColor: Colors.white,
      content: Container(
        color: Colors.white24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: filterOptions,
                decoration: const InputDecoration(
                  labelText: 'بحث',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: ListView.builder(
                itemCount: filteredOptions.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = filteredOptions[index];
                  return CheckboxListTile(
                    title: Text(option.name),
                    value: option.state, // Set value based on checkbox state
                    onChanged: (bool? value) {
                      setState(() {
                        option.state = value!;
                        options[options.indexOf(option)].state = option.state;
                      });
                      // debugPrint("changed");
                      // Handle checkbox state change
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actionsPadding: const EdgeInsets.all(5),
      shadowColor: Colors.blueAccent,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "الغاء",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
            )),
        TextButton(
            onPressed: () {
              widget.OnSave(options);
              Navigator.pop(context);
            },
            child: const Text(
              "تاكيد",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16),
            ))
      ],
    );
  }
}
*/
//---------------------------
class SearchList {
  int id;
  String name;
  SearchList({required this.id, required this.name});
}

class SearchListDialog extends StatefulWidget {
  final List<SearchList> originalData;
  final String title;
  final Function(SearchList) onSelected;

  const SearchListDialog({
    super.key,
    required this.originalData,
    required this.title,
    required this.onSelected,
  });

  @override
  State<SearchListDialog> createState() => _SearchListDialogState();
}

class _SearchListDialogState extends State<SearchListDialog> {
  List<SearchList> options = [];
  List<SearchList> filteredOptions = [];

  @override
  void initState() {
    super.initState();
    options = widget.originalData.map((item) => SearchList(id: item.id, name: item.name)).toList();
    filteredOptions.addAll(options);
  }

  void filterOptions(String query) {
    setState(() {
      if (query.isNotEmpty) {
        filteredOptions = options.where((option) => option.name.toLowerCase().contains(query.toLowerCase())).toList();
      } else {
        filteredOptions = List<SearchList>.from(options);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      title: Text(widget.title),
      backgroundColor: Colors.white,
      content: Container(
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: filterOptions,
                decoration: const InputDecoration(
                  labelText: 'بحث',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: ListView.builder(
                itemCount: filteredOptions.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = filteredOptions[index];
                  return ListTile(
                    title: Text(option.name),
                    onTap: () {
                      widget.onSelected(option);
                      // Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // actionsAlignment: MainAxisAlignment.spaceAround,
      // actionsPadding: const EdgeInsets.all(5),
      // shadowColor: Colors.blueAccent,
      // actions: [
      //   TextButton(
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //     child: const Text(
      //       "الغاء",
      //       style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
      //     ),
      //   ),
      // ],
    );
  }
}

showMessage({
  String titleMsg = " ",
  String msg = " ",
  Color color = Colors.red,
  Color titelTextColor = Colors.white,
  Color msgTextColor = Colors.white,
  double titleFontSize = 14,
  double msgFontSize = 14,
  int durationMilliseconds = 2000,
}) {
  Get.snackbar(
    titleMsg,
    msg,
    titleText: Center(
      child: Text(
        titleMsg,
        style: TextStyle(
          color: titelTextColor,
          fontSize: titleFontSize,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    messageText: Center(
      child: Text(
        msg,
        style: TextStyle(
          color: msgTextColor,
          fontSize: msgFontSize,
        ),
        textAlign: TextAlign.center,
      ),
    ),
    //to make able close any other dialoag while snakBar is showed
    isDismissible: true,
    overlayColor: Colors.transparent,
    overlayBlur: 0,
    //-----------------
    snackPosition: SnackPosition.TOP,
    duration: Duration(
      milliseconds: durationMilliseconds,
    ),
    backgroundColor: color,
    colorText: Colors.white,
    maxWidth: Get.mediaQuery.size.width - 50,
    borderRadius: 4,
    mainButton: TextButton(
        onPressed: () {
          copyTextToClipboard("tittle :  \n $titleMsg \n ------ \n $msg");
        },
        child: Icon(
          Icons.copy,
          color: Colors.white,
        )),
    // onTap: (snack) {
    //   copyTextToClipboard("tittle :  \n ${snack.title} \n ------ \n ${snack.message}");
    // },
    // margin: const EdgeInsets.only(top: 10),
  );
}
