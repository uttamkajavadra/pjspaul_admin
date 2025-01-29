import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/other/other_controller.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_text_form_field.dart';

class LifeChangingMessageLive extends StatelessWidget {
  const LifeChangingMessageLive({super.key});

  @override
  Widget build(BuildContext context) {
    OtherController controller = Get.isRegistered<OtherController>()
        ? Get.find<OtherController>()
        : Get.put(OtherController());

    return Form(
      key: controller.lifeTVProgram,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
              controller: controller.tvProgramController,
              labelText: "TV Program Name",
              validator: (value) => Validator.validateNull("TV Program Name", value)),
          const SizedBox(
            height: 20,
          ),
          CustomElevatedButton(
              onPressed: () {
                if (controller.lifeTVProgram.currentState!.validate()) {
                  controller.addTVProgram(context);
                }
              },
              buttonText: "ADD"),
        ],
      ),
    );
  }
}