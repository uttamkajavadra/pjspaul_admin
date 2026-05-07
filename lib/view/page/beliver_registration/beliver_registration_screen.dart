import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_registration/beliver_registration_controller.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';

import 'package:pjspaul_admin/view/widget/responsive_data_table.dart';

class BeliverRegistrationScreen extends StatefulWidget {
  const BeliverRegistrationScreen({super.key});

  @override
  State<BeliverRegistrationScreen> createState() =>
      _BeliverRegistrationScreenState();
}

class _BeliverRegistrationScreenState extends State<BeliverRegistrationScreen> {
  BeliverRegistrationController controller =
      Get.isRegistered<BeliverRegistrationController>()
          ? Get.find<BeliverRegistrationController>()
          : Get.put(BeliverRegistrationController());

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
            Obx(() {
              return (!controller.isGo.value)
                  ? const Center(child: CircularProgressIndicator())
                  : (controller.listData.isEmpty)
                      ? const Center(child: Text("No data found"))
                      : ResponsiveDataTable(
                          headers: controller.list[controller.selectedIndex.value],
                          data: controller.listData,
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
