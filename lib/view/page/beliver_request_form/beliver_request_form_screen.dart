import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_request_form/beliver_request_form_controller.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';

import 'package:pjspaul_admin/view/widget/responsive_data_table.dart';

class BeliverRequestFormScreen extends StatefulWidget {
  const BeliverRequestFormScreen({super.key});

  @override
  State<BeliverRequestFormScreen> createState() =>
      _BeliverRequestFormScreenState();
}

class _BeliverRequestFormScreenState extends State<BeliverRequestFormScreen> {
  BeliverRequestFormController controller =
      Get.isRegistered<BeliverRequestFormController>()
          ? Get.find<BeliverRequestFormController>()
          : Get.put(BeliverRequestFormController());

  @override
  void initState() {
    super.initState();
    controller.refreshCurrent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Obx(() => SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, label: Text("New Entries")),
                      ButtonSegment(value: true, label: Text("Old Entries")),
                    ],
                    selected: {controller.isShowOld.value},
                    onSelectionChanged: (Set<bool> newSelection) {
                      controller.isShowOld.value = newSelection.first;
                      controller.refreshCurrent();
                    },
                  )),
            ),
            Obx(() {
              return (!controller.isGo.value)
                  ? const Center(child: CircularProgressIndicator())
                  : (controller.listData.isEmpty)
                      ? const Center(child: Text("No data found"))
                      : ResponsiveDataTable(
                          headers: controller.list[controller.selectedIndex.value],
                          data: controller.listData,
                          isOldTab: controller.isShowOld.value,
                          onToggleStatus: (index) => controller.toggleStatus(context, index),
                          onDelete: (index) {
                            DeleteConfirmationDialog.show(
                              context,
                              onConfirm: () => controller.deleteRecord(context, index),
                            );
                          },
                        );
            }),
          ],
        ),
      ),
    );
  }


}
