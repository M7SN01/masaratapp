import 'package:flutter/material.dart';

import 'widget.dart';

class CheckboxListWithSearch extends StatefulWidget {
  final List<SearchList> originalData;

  final String title;
  final Function(List<SearchList>) OnSave;
  const CheckboxListWithSearch({
    super.key,
    required this.originalData,
    required this.title,
    required this.OnSave,
  });
  @override
  _CheckboxListWithSearchState createState() => _CheckboxListWithSearchState();
}

class _CheckboxListWithSearchState extends State<CheckboxListWithSearch> {
  // Sample data
  List<SearchList> options = [];
  List<SearchList> filteredOptions = [];

  @override
  void initState() {
    super.initState();
    // filteredOptions.addAll(options);
    options.clear();

    options = widget.originalData.map((item) => SearchList(id: item.id, name: item.name, state: item.state)).toList();
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
        filteredOptions = List<SearchList>.from(options);
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
                  filteredOptions.forEach((element) {
                    element.state = val;
                  });
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
                      // print("changed");
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

// class SearchList {
//   dynamic id;
//   String name;
//   bool state;

//   SearchList({required this.id, required this.name, required this.state});
// }
