import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../Controllers/sanadat_controller.dart';
import '../../Widget/pick_date.dart';
import '../../utils/utils.dart';
import '../../Widget/widget.dart';

class Sanadat extends StatelessWidget {
  const Sanadat({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SanadatController>(
      // init: SanadatController(),
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Column(
            children: [
              Text("سند قبض"),
              if (controller.isOfflineMode)
                Text(
                  "العمل دون اتصال",
                  style: TextStyle(color: secondaryColor),
                ),
            ],
          ),
          centerTitle: true,
          actions: [
            //clear all
            // IconButton(
            //   onPressed: () {
            //     if (controller.selectedSanadTypeId != null || controller.selecetdCustomer != null) {
            //       Get.defaultDialog(
            //         radius: 8,
            //         title: "هل تريد حذف السند",
            //         // middleText: "لن تتمكن من استرجاعه لاحقًا",
            //         confirm: ElevatedButton(
            //           style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
            //           onPressed: () {
            //             controller.clearSanadData();
            //             Get.back();
            //           },
            //           child: const Text("موافق"),
            //         ),
            //         cancel: ElevatedButton(
            //           style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
            //           onPressed: () {
            //             Get.back();
            //           },
            //           child: const Text("إلغاء"),
            //         ),
            //       );
            //     }
            //   },
            //   icon: const Icon(
            //     Icons.delete_forever_rounded,
            //     color: secondaryColor,
            //   ),
            // ),
          ],
        ),
        body: Card(
          margin: const EdgeInsets.all(20),
          elevation: 1,
          // surfaceTintColor: Colors.amberAccent,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ///heder  Sanad type , customer
                IntrinsicHeight(
                  child: Row(
                    children: [
                      //sanad Type
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Colors.deepPurpleAccent,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          height: 60,
                          child: dropDownList(
                            enable: !controller.isPostedBefor,
                            initialText: "نوع السند",
                            iconColor: primaryColor,
                            chosedItem: controller.selectedSanadType,
                            showedList: controller.sanadatAct.map((e) => e.actName).toList(),
                            callback: (val) {
                              controller.selectedSanadType = val;
                              final selected = controller.sanadatAct.firstWhere((e) => e.actName == val);

                              controller.selectedSanadTypeId = selected.actId.toString();
                              controller.update();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

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

                SizedBox(height: controller.selecetdCustomer == null ? 10 : 0),
                Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      //date
                      Row(
                        children: [
                          PickDateW(
                            filedHeight: 60,
                            enabled: !controller.isPostedBefor,
                            // expandedFlix: 2,
                            labelText: "اختر تاريخ",
                            dateDontroller: controller.date,
                            // onSelectionChanged: () {
                            //   controller.date.text = "";
                            //   controller.update();
                            // },

                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى ادخال التاريخ';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      //amount
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: TextFormField(
                                controller: controller.amount,
                                enabled: !controller.isPostedBefor,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                ],
                                textAlign: TextAlign.center,
                                cursorColor: primaryColor,
                                decoration: const InputDecoration(
                                  labelText: "ادخل المبلغ",
                                  floatingLabelAlignment: FloatingLabelAlignment.center,
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                  border: OutlineInputBorder(
                                    gapPadding: 5,
                                    borderSide: BorderSide(color: primaryColor, width: 1),
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'يرجى ادخال المبلغ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      //descripition
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: TextFormField(
                                controller: controller.description,
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
                    ],
                  ),
                ),

                const SizedBox(height: 5),
                //Save Sand button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.isPostedBefor
                        ? Text(
                            controller.savedSanadId ?? "",
                            style: const TextStyle(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.center,
                          )
                        : Expanded(
                            child: controller.isPostingToApi
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                    ),
                                  )
                                : TextButton(
                                    onPressed: () async {
                                      await controller.saveSanad();
                                      //
                                    },
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      backgroundColor: Colors.deepPurpleAccent,
                                    ),
                                    child: const Text(
                                      "حــفــظ",
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

                //printing & priview & get Old Sanad
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (controller.selectedSanadTypeId != null || controller.selecetdCustomer != null) {
                          Get.defaultDialog(
                            radius: 8,
                            title: "هل تريد الغاء البيانات \nالمدونة وبدء سند جديد",
                            middleText: "",
                            confirm: ElevatedButton(
                              style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                              onPressed: () {
                                controller.clearSanadData();
                                Get.back();
                              },
                              child: const Text("موافق"),
                            ),
                            cancel: ElevatedButton(
                              style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("إلغاء"),
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      child: Icon(
                        Icons.add_box_rounded,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.printSanad();
                      },
                      icon: const Icon(
                        Icons.print,
                        size: 50,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.previewSanad();
                      },
                      icon: const Icon(
                        Icons.preview_rounded,
                        size: 50,
                      ),
                    ),
                    TextButton(
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
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        )
                        // const Text(
                        //   "بحث عن سند",
                        //   style: TextStyle(
                        //     color: Colors.white,
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),
                        ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
