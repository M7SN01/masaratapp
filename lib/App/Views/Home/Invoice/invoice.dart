import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Controllers/invoice_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../utils/utils.dart';
import '../../../../Widget/widget.dart';

class Invoice extends StatelessWidget {
  const Invoice({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InvoiceController>(
      // init: InvoiceController(),
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                if (controller.selectedInvTypeId != null || controller.selecetdCustomer != null) {
                  Get.defaultDialog(
                    radius: 8,
                    title: "هل تريد حذف الفاتورة؟",
                    middleText: "لن تتمكن من استرجاعها لاحقًا",
                    confirm: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                      onPressed: () {
                        controller.clearInvoiceData();
                        Get.back();
                      },
                      child: Text("موافق"),
                    ),
                    cancel: ElevatedButton(
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("إلغاء"),
                    ),
                  );
                }
              },
              icon: Icon(Icons.delete_forever_rounded, color: secondaryColor),
            ),
          ],
        ),
        body: Card(
          margin: EdgeInsets.all(20),
          elevation: 1,
          // surfaceTintColor: Colors.amberAccent,
          child: Column(
            children: [
              ///heder  inv type , customer
              IntrinsicHeight(
                child: Row(
                  children: [
                    //INv Type
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), border: Border.all(width: 1, color: Colors.deepPurpleAccent, strokeAlign: BorderSide.strokeAlignInside)),
                        height: 60,
                        // margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: dropDownList(
                          enable: !controller.isPostedBefor,
                          initialText: "نوع الفاتورة",
                          iconColor: primaryColor,
                          chosedItem: controller.selectedInvType, // now nullable
                          showedList: controller.act.map((e) => e.actName).toList(),
                          callback: (val) {
                            controller.selectedInvType = val;
                            final selected = controller.act.firstWhere((e) => e.actName == val);
                            // debugPrint('Selected actId: ${selected.actId}');
                            controller.selectedInvTypeId = selected.actId.toString();
                            controller.update();
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 10),

                    //chose customer
                    Expanded(
                      child: GestureDetector(
                        onTap: controller.isPostedBefor
                            ? null
                            : () {
                                showDialog(
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) {
                                    return SearchListDialog(
                                      title: "اختر عميل",
                                      originalData: controller.cusData.map((e) => SearchList(id: e.cusId, name: e.cusName)).toList(),
                                      onSelected: (selectedItem) {
                                        controller.selecetdCustomer = controller.cusData.firstWhere((e) => e.cusId == selectedItem.id);
                                        controller.update();
                                        Get.back();
                                      },
                                    );
                                  },
                                );
                              },
                        child: Opacity(
                          opacity: !controller.isPostedBefor ? 1.0 : 0.5,
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: controller.selecetdCustomer == null ? primaryColor : secondaryColor,
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(5),
                              shape: BoxShape.rectangle,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.checklist_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "إختر عميل",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //customer information
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  // final isShowing = child.key != const ValueKey('empty');
                  final begin = controller.selecetdCustomer != null ? const Offset(1, 0) : const Offset(-1, 0); //in=> on x from 1 to zero 1,1 => 0,0
                  final end = controller.selecetdCustomer != null ? Offset.zero : const Offset(0, 0); // out =>  on -x ?????
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: begin,
                      end: end,
                    ).animate(animation),
                    child: child,
                  );
                },
                //FadeTransition(opacity: animation, child: child),
                child: controller.selecetdCustomer != null
                    ? Card(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 1,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                          side: BorderSide(
                            color: primaryColor,
                            width: 0.5,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        const Center(child: Text("اسم العميل :")),
                                        const SizedBox(width: 10),
                                        Expanded(child: Text(controller.selecetdCustomer!.cusName)),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Center(child: Text("جوال العميل :")),
                                        const SizedBox(width: 10),
                                        Expanded(child: Text(controller.selecetdCustomer!.mobl ?? "")),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Center(child: Text("العنوان :")),
                                        const SizedBox(width: 10),
                                        Expanded(child: Text(controller.selecetdCustomer!.adrs ?? "")),
                                      ],
                                    ),
                                    const Divider(),
                                    Row(
                                      children: [
                                        const Center(child: Text("الرقم الضريبي :")),
                                        const SizedBox(width: 10),
                                        Expanded(child: Text(controller.selecetdCustomer!.taxNo ?? "")),
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: IconButton(
                                onPressed: controller.isPostedBefor
                                    ? null
                                    : () {
                                        controller.selecetdCustomer = null;
                                        controller.update();
                                      },
                                icon: Icon(
                                  Icons.cancel_rounded,
                                  color: controller.isPostedBefor ? Colors.grey : secondaryColor,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(
                        key: ValueKey('empty'),
                      ),
              ),

              Divider(height: 8),
              //add item
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: controller.isPostedBefor
                        ? Text(" ${controller.selectedInvType} ( ${controller.savedInvoiceId} )", style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 16), textAlign: TextAlign.center)
                        : TextButton(
                            onPressed: () {
                              if (controller.selectedInvTypeId != null) {
                                controller.searchTextController.text = "";
                                // controller.filteredItems.clear();

                                controller.addNewItems();
                              } else {
                                controller.showInvTypemsg();
                              }
                            },
                            style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)), backgroundColor: Colors.deepPurpleAccent),
                            child: Text("اضافة صنف", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        controller.sanadSearchDialoag();
                        // Get.to(() => Diatest());
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      child: const Text(
                        "بحث عن فاتورة",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: controller.invDescription,
                        enabled: !controller.isPostedBefor,
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          labelText: "الوصف",
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          border: OutlineInputBorder(gapPadding: 10, borderSide: BorderSide(color: primaryColor, width: 1), borderRadius: BorderRadius.all(Radius.circular(8))),
                        ),
                        cursorColor: primaryColor,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'يرجى ادخال الوصف';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),

              Divider(height: 8),
              Expanded(
                flex: 5,
                child: controller.isGettingFromApi
                    ? Center(child: const CircularProgressIndicator())
                    : controller.isPostedBefor && controller.rows.isEmpty
                        ? Center(child: Text("لاتوجد بيانات"))
                        : PlutoGrid(
                            mode: PlutoGridMode.selectWithOneTap,
                            columns: controller.columns,
                            rows: controller.rows,
                            onLoaded: (PlutoGridOnLoadedEvent event) {
                              controller.stateManager = event.stateManager;
                            },
                            onChanged: (event) {
                              // controller.update();
                            },
                            // onRowSecondaryTap: (event) {
                            //   debugPrint("sssssssssssssssssssssssssssssssss");
                            // },
                            onRowDoubleTap: (event) {
                              // debugPrint("fffffffffffff00ffffff : ${event.cell.column.field}");
                              if (event.cell.column.field == 'QTY') {
                                int? rowIndex = event.rowIdx;
                                controller.editqty(rowIndex);
                                // event.row.
                              }
                            },
                            onSelected: (event) {
                              debugPrint("select .........................");
                              if (event.cell!.column.field == 'QTY') {
                                int? rowIndex = event.rowIdx;
                                if (rowIndex != null) {
                                  controller.editqty(rowIndex);
                                  // controller.stateManager!.clearCurrentCell();
                                  // controller.stateManager!.setCurrentSelectingPosition(notify: false);
                                  // event.selectedRows!.;
                                }
                              }
                            },
                            configuration: configuration,
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
