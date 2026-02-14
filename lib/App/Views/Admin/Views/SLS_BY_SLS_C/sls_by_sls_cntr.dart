import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masaratapp/App/Views/Admin/other/TableView/Table.dart';
// import 'package:intl/intl.dart';
// import 'package:pluto_grid/pluto_grid.dart';

import '../../../../../Widget/pick_date.dart';
import '../../../../../Widget/search_chk_box.dart';
// import '../../../../../Widget/widget.dart';
import '../../../../../Widget/widget.dart';
import '../../../../../utils/utils.dart';

import 'View/full_view.dart';

import 'View/months_view.dart';

import 'controller/sls_cntr_controller.dart';

class SlsByslsCntr extends StatelessWidget {
  const SlsByslsCntr({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("مبيعات عام"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }
}

Widget _body() {
  return GetBuilder<SlsCenterController>(
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
                ? tableView(tableOPtions: controller.fullViewTableOptions)
                //  MonthView(
                //     loadingData: controller.loadingData,
                //     monthRows: controller.monthRows,
                //     columns: controller.monthColumns,
                //     repID: controller.fullRepId,
                //     // defaultTableSetting: defaultTableSetting,
                //   )
                : DefaultTabController(
                    length: 3,
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
                            Tab(
                              // icon: Icon(
                              //   Icons.tab,
                              //   size: 20,
                              // ),
                              text: "مبيعات",
                            ),
                            Tab(
                              // icon: Icon(
                              //   Icons.tab,
                              //   size: 20,
                              // ),
                              text: "تكلفة",
                            ),
                            Tab(
                              // icon: Icon(
                              //   Icons.tab,
                              //   size: 20,
                              // ),
                              text: "ربح",
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              tableView(tableOPtions: controller.slsViewTableOptions),
                              tableView(tableOPtions: controller.costViewTableOptions),
                              tableView(tableOPtions: controller.gainViewTableOptions),
                              // ReportTableView(
                              //   loading: controller.loadingData,
                              //   rows: controller.slsRows,
                              //   from: controller.fromDateController.text,
                              //   to: controller.toDateController.text,
                              //   repID: controller.slsRepId,
                              //   title: "مبيعات مراكز البيع",
                              // ),
                              // ReportTableView(
                              //   loading: controller.loadingData,
                              //   rows: controller.costRows,
                              //   from: controller.fromDateController.text,
                              //   to: controller.toDateController.text,
                              //   repID: controller.costRepId,
                              //   title: "تكلفة مراكز البيع",
                              // ),
                              // ReportTableView(
                              //   loading: controller.loadingData,
                              //   rows: controller.gainRows,
                              //   from: controller.fromDateController.text,
                              //   to: controller.toDateController.text,
                              //   repID: controller.gainRepId,
                              //   title: "ربح مراكز البيع",
                              // ),
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
    return GetBuilder<SlsCenterController>(
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
                        }),
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
                        })
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
                      color: controller.selectedslsCntr == "" ? primaryColor : secondaryColor,
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
                          "مركز بيع",
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
                          title: "اختر مركز بيع",
                          originalData: controller.slsCntrOrignalData,
                          OnSave: (filteredOptions) {
                            controller.selectedslsCntr = filteredOptions
                                .where((item) => item.state) // Filter items where state is true
                                .map((item) => "'${item.id}'")
                                .join(',');
                            // print(_selectedslsCntr);
                            controller.slsCntrOrignalData = filteredOptions;

                            controller.selectedslsCntr;
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
                      color: selectedslsCntrGroupId == "" ? Colors.redAccent : const Color.fromARGB(255, 3, 192, 101),
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
                            selectedslsCntrGroupId = filteredOptions
                                .where((item) => item.state) // Filter items where state is true
                                .map((item) => "'${item.id}'")
                                .join(',');
                            // print(_selectedslsCntr);
                            _slsCntrGrpOrignalData = filteredOptions;
                            setState(() {
                              selectedslsCntrGroupId;
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
