import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_spritual_content/beliver_spritual_content_controller.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_text_form_field.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/custom_upload_file.dart';

class LifeChangingSongForm extends StatelessWidget {
  const LifeChangingSongForm({super.key});

  @override
  Widget build(BuildContext context) {
    BeliverSpritualContentController controller = Get.isRegistered<BeliverSpritualContentController>()
        ? Get.find<BeliverSpritualContentController>()
        : Get.put(BeliverSpritualContentController());

    return Form(
      key: controller.lifeSongForm,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
              controller: controller.songTitleController,
              labelText: "Audio Title",
              validator: (value) => Validator.validateNull("Audio Title", value)),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            return CustomUploadFile(
              onTap: () {
                controller.pickFile();
              },
              selectedFile: controller.selectedFile.value,
              uploadText: "Upload Audio",
              selectedText: "Audio Selected",
            );
          }),
          const SizedBox(
            height: 20,
          ),
          CustomElevatedButton(
              onPressed: () {
                if (controller.lifeSongForm.currentState!.validate()) {
                  if (controller.selectedFile.value != null) {
                    controller.addLifeSong(context);
                  } else {
                    CustomToast.instance.showMsg("Please fill all the details");
                  }
                }
              },
              buttonText: "ADD"),
        ],
      ),
    );
  }
}