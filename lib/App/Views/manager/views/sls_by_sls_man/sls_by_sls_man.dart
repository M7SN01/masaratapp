import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widget/pick_date.dart';
import '../../../../../widget/search_chk_box.dart';
import '../../../../../widget/widget.dart';
import '../../../../../table_view/table.dart';
import '../../../../../utils/utils.dart';
import '../../controller/sls_by_sls_man_controller.dart';
import 'grid_columns.dart';

class SlsByslsMan extends StatelessWidget {
  const SlsByslsMan({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SlsBySlsManController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text("مبيعات حسب المناديب"),
          centerTitle: true,
        ),
        body: _body(),
      ),
    );
  }
}

Widget _body() {
  return GetBuilder<SlsBySlsManController>(
    builder: (controller) => Container(
      // width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(right: 20, left: 20, bottom: 5, top: 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        children: [
          optionSwitcher(
            duration: const Duration(microseconds: 500),
            searchOptions: const SearchOptions(),
            isShowed: controller.optionShow,
            state: (val) {
              controller.optionShow = !controller.optionShow;
              controller.update();
            },
          ),
          Expanded(
            child: controller.showMonthRep
                ? tableView(tableOPtions: controller.fullViewTableOptions(columns: SlsBySlsManColumns().getColumnsByMonthRep))
                : DefaultTabController(
                    length: 4,
                    initialIndex: controller.currentTab,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: primaryColor,
                          indicatorColor: primaryColor,
                          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                          onTap: (value) {
                            controller.currentTab = value;
                            controller.update();
                            // print(value);
                          },
                          tabs: [
                            Tab(text: "مبيعات"),
                            Tab(text: "ربح"),
                            Tab(text: "مديونية"),
                            Tab(text: "تحصيلات"),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              tableView(
                                  tableOPtions: controller.slsViewTableOptions(
                                columns: SlsBySlsManColumns().getColumnsFromToDateRep(
                                  fromDateController: controller.fromDateController,
                                  toDateController: controller.toDateController,
                                ),
                              )),
                              tableView(
                                  tableOPtions: controller.gainViewTableOptions(
                                columns: SlsBySlsManColumns().getColumnsFromToDateRep(
                                  fromDateController: controller.fromDateController,
                                  toDateController: controller.toDateController,
                                ),
                              )),
                              tableView(
                                  tableOPtions: controller.mdunihViewTableOptions(
                                columns: SlsBySlsManColumns().getColumnsFromToDateRep(
                                  fromDateController: controller.fromDateController,
                                  toDateController: controller.toDateController,
                                ),
                              )),
                              tableView(
                                  tableOPtions: controller.t7silViewTableOptions(
                                columns: SlsBySlsManColumns().getColumnsFromToDateRep(
                                  fromDateController: controller.fromDateController,
                                  toDateController: controller.toDateController,
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}

class SearchOptions extends StatelessWidget {
  const SearchOptions({super.key});

  @override
  Widget build(BuildContext context) {
    double filedHeight = 45;
    return GetBuilder<SlsBySlsManController>(
      builder: (controller) => Column(
        children: [
          controller.dateSwitcher
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: switchW(
                        value: controller.dateSwitcher,
                        state: (val) {
                          controller.dateSwitcher = val;
                          controller.update();
                        },
                      ),
                    ),
                    PickDateW(
                      expandedFlix: 2,
                      labelText: "من تاريخ",
                      dateDontroller: controller.fromDateController,
                      onSelectionChanged: () {
                        controller.mnthDateController.text = "";
                        controller.update();
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    PickDateW(
                      expandedFlix: 2,
                      labelText: "الى تاريخ",
                      dateDontroller: controller.toDateController,
                      onSelectionChanged: () {
                        controller.mnthDateController.text = "";
                        controller.update();
                      },
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: switchW(
                          value: controller.dateSwitcher,
                          state: (val) {
                            controller.dateSwitcher = val;
                            controller.update();
                          },
                        )),
                    PickMonthW(
                        expandedFlix: 4,
                        labelText: "شهر",
                        dateDontroller: controller.mnthDateController,
                        onSelectionChanged: () {
                          controller.fromDateController.text = "";
                          controller.toDateController.text = "";
                          controller.update();
                        })
                  ],
                ),

          const SizedBox(
            height: 5,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // search cus
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    // margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    // width: (MediaQuery.of(context).size.width / 2) - 25,
                    height: filedHeight,
                    decoration: BoxDecoration(
                      color: controller.selectedslsMan == "" ? primaryColor : secondaryColor,
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.checklist_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "مناديب",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return CheckboxListWithSearch(
                          title: "إختر مندوب",
                          originalData: controller.slsManOrignalData,
                          OnSave: (filteredOptions) {
                            controller.selectedslsMan = filteredOptions
                                .where((element) => element.state) // Filter elements where state is true
                                .map((element) => "${element.id}")
                                .join(',');
                            // print(_selectedslsMan);
                            controller.slsManOrignalData = filteredOptions;

                            controller.selectedslsMan;
                            controller.update();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: controller.loadingData
                    ? Container(
                        height: filedHeight,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            controller.loadingData = false;
                            controller.update();
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Container(
                        height: filedHeight,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          shape: BoxShape.rectangle,
                        ),
                        child: IconButton(
                          onPressed: () {
                            controller.getdata();
                          },
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
              /*
              Expanded(
                flex: 1,
                child: GestureDetector(
                  child: Container(
                    // margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    // width: (MediaQuery.of(context).size.width / 2) - 25,
                    height: filedHeight,
                    decoration: BoxDecoration(
                      color: selectedslsManGroupId == "" ? Colors.redAccent : const Color.fromARGB(255, 3, 192, 101),
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5),
                      shape: BoxShape.rectangle,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.checklist_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          currentLang["SLS_CNTR_GRP"] ?? "",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return CheckboxListWithSearch(
                          title: currentLang["CHS_SLS_CNTR_GRP"] ?? "",
                          originalData: _slsCntrGrpOrignalData,
                          OnSave: (filteredOptions) {
                            selectedslsManGroupId = filteredOptions
                                .where((item) => item.state) // Filter items where state is true
                                .map((item) => "'${item.id}'")
                                .join(',');
                            // print(_selectedslsMan);
                            _slsCntrGrpOrignalData = filteredOptions;
                            setState(() {
                              selectedslsManGroupId;
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              */
            ],
          ),

          const SizedBox(height: 10),
          const Divider(
            color: Colors.blueGrey,
            height: 1,
            thickness: 0.5,
          ),
          const SizedBox(height: 5),
          //  const Divider(color: Colors.grey,height: 1,thickness: 10,)
        ],
      ),
    );
  }
}
