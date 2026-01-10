import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../App/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../Controllers/visit_plan_controller.dart';

class VisitPlan extends StatelessWidget {
  const VisitPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VisitPlanController>(
      // init: InvoiceController(),
      builder: (controller) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("عملاء خطة اليوم"),
        ),
        body: Card(
          margin: EdgeInsets.all(20),
          elevation: 1,
          // surfaceTintColor: Colors.amberAccent,
          child: Column(
            children: [
              Divider(height: 8),
              Expanded(
                flex: 5,
                child: controller.isGettingFromApi
                    ? Center(child: const CircularProgressIndicator())
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
                        onRowDoubleTap: (event) {},
                        onSelected: (event) {
                          // debugPrint("select .........................");
                          // if (event.cell!.column.field == 'QTY') {
                          //   int? rowIndex = event.rowIdx;
                          //   if (rowIndex != null) {
                          //     controller.editqty(rowIndex);
                          //     // controller.stateManager!.clearCurrentCell();
                          //     // controller.stateManager!.setCurrentSelectingPosition(notify: false);
                          //     // event.selectedRows!.;
                          //   }
                          // }
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
