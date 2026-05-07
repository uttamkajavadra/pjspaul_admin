import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/other/other_controller.dart';
import 'package:pjspaul_admin/view/page/other/tabs/life_changing_message_live.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';

import 'package:pjspaul_admin/view/widget/responsive_data_table.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  OtherController controller = Get.isRegistered<OtherController>()
      ? Get.find<OtherController>()
      : Get.put(OtherController());

  @override
  void initState() {
    super.initState();
    controller.refreshCurrent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Obx(() {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.selectedIndex.value == 2)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              width: 100,
                              child: CustomElevatedButton(
                                  onPressed: () {
                                    controller.isShowAdd.value =
                                        !controller.isShowAdd.value;
                                  },
                                  buttonText: (controller.isShowAdd.value)
                                      ? "Hide"
                                      : "+ Add"),
                            ),
                            if (controller.selectedIndex.value == 2 &&
                                controller.isShowAdd.value == true)
                              const LifeChangingMessageLive(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    (!controller.isGo.value)
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
                              ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }


}
