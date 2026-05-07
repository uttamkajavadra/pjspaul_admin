import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_spritual_content/beliver_spritual_content_controller.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/life_changing_message_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/life_changing_song_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/short_message_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/today_blessing_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/upcoming_event_form.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_text_form_field.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';


import 'package:pjspaul_admin/view/widget/responsive_data_table.dart';

// ... (existing imports)

// ...

class BeliverSpritualContentScreen extends StatefulWidget {
  const BeliverSpritualContentScreen({super.key});

  @override
  State<BeliverSpritualContentScreen> createState() =>
      _BeliverSpritualContentScreenState();
}

class _BeliverSpritualContentScreenState
    extends State<BeliverSpritualContentScreen> {
  BeliverSpritualContentController controller =
      Get.isRegistered<BeliverSpritualContentController>()
          ? Get.find<BeliverSpritualContentController>()
          : Get.put(BeliverSpritualContentController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.selectedIndex.value == 0) {
        await controller.getRadioLink();
      } else if (controller.selectedIndex.value == 1) {
        await controller.getTodayBlessing();
      } else if (controller.selectedIndex.value == 2) {
        await controller.getUpcomingEvent();
      } else if (controller.selectedIndex.value == 3) {
        await controller.getShortMessage();
      } else if (controller.selectedIndex.value == 4) {
        await controller.getLifeMessage();
      } else if (controller.selectedIndex.value == 5) {
        await controller.getLifeSong();
      }
    });
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
            if (controller.selectedIndex.value == 0) {
              return Form(
                key: controller.radioForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Life Changing Radio 24/7",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        controller: controller.lifeChangingRadioController,
                        labelText: "Life Changing Radio Link",
                        validator: (value) => Validator.validateNull(
                            "Life Changing Radio Link", value)),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                        onPressed: () {
                          if (controller.radioForm.currentState!.validate()) {
                            controller.addRadioLink(context);
                          }
                        },
                        buttonText: "Save"),
                    const SizedBox(height: 40),
                    const Text(
                      "Current Radio Link",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    if (controller.listData.isNotEmpty)
                      Text(controller.listData[0][0]),
                  ],
                ),
              );
            }
            return Expanded(
              child: SingleChildScrollView(
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
                          buttonText:
                              (controller.isShowAdd.value) ? "Hide" : "+ Add"),
                    ),
                    if (controller.selectedIndex.value == 1 &&
                        controller.isShowAdd.value == true)
                      TodayBlessingForm(),
                    if (controller.selectedIndex.value == 2 &&
                        controller.isShowAdd.value == true)
                      UpcomingEventForm(),
                    if (controller.selectedIndex.value == 3 &&
                        controller.isShowAdd.value == true)
                      ShortMessageForm(),
                    if (controller.selectedIndex.value == 4 &&
                        controller.isShowAdd.value == true)
                      LifeChangingMessageForm(),
                    if (controller.selectedIndex.value == 5 &&
                        controller.isShowAdd.value == true)
                      LifeChangingSongForm(),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (!controller.isGo.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.listData.isEmpty) {
                        return const Center(child: Text("No data found"));
                      }
                      return ResponsiveDataTable(
                        headers: controller.list[controller.selectedIndex.value],
                        data: controller.listData,
                        onDelete: (index) {
                          DeleteConfirmationDialog.show(
                            context,
                            onConfirm: () {
                              if (controller.selectedIndex.value == 1)
                                controller.deleteTodayBlessing(context, index);
                              else if (controller.selectedIndex.value == 2)
                                controller.deleteUpcomingEvent(context, index);
                              else if (controller.selectedIndex.value == 3)
                                controller.deleteShortMessage(context, index);
                              else if (controller.selectedIndex.value == 4)
                                controller.deleteLifeMessage(context, index);
                              else if (controller.selectedIndex.value == 5)
                                controller.deleteLifeSong(context, index);
                            },
                          );
                        },
                      );
                    }),
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
