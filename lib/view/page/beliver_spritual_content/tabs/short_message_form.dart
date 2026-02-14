import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_spritual_content/beliver_spritual_content_controller.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_text_form_field.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/custom_upload_file.dart';
import 'package:pjspaul_admin/view/widget/custom_yes_no.dart';
import 'package:pjspaul_admin/view/widget/form_container.dart';

class ShortMessageForm extends StatelessWidget {
  const ShortMessageForm({super.key});

  @override
  Widget build(BuildContext context) {
    BeliverSpritualContentController controller =
        Get.isRegistered<BeliverSpritualContentController>()
            ? Get.find<BeliverSpritualContentController>()
            : Get.put(BeliverSpritualContentController());

    return FormContainer(
      title: "Add Short Message",
      child: Form(
        key: controller.shortMessageForm,
        child: Column(
          children: [
            CustomTextFormField(
                labelText: "Title",
                controller: controller.shortController,
                maxLength: 100,
                minLines: 1,
                maxLines: 1,
                validator: (value) => Validator.validateNull("Title", value)),
            const SizedBox(
              height: 24,
            ),
            CustomTextFormField(
                labelText: "Message Content",
                controller: controller.messageController,
                maxLength: 200,
                minLines: 3,
                maxLines: 5,
                validator: (value) =>
                    Validator.validateNull("Message Content", value)),
            const SizedBox(
              height: 24,
            ),
            Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Video Source",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 8),
                  CustomYesNo(
                      isYoutube: controller.isYoutube.value,
                      onTap: (status) {
                        controller.isYoutube.value = status;
                        controller.youtubeVideoController.text = "";
                      }),
                ],
              );
            }),
            const SizedBox(
              height: 24,
            ),
            Obx(() {
              if (controller.isYoutube.value) {
                return CustomTextFormField(
                    controller: controller.youtubeVideoController,
                    labelText: "Youtube Link",
                    prefixIcon: const Icon(Icons.link),
                    validator: (value) =>
                        Validator.validateNull("Youtube Link", value));
              }
              return CustomUploadFile(
                onTap: () {
                  controller.pickFile();
                },
                selectedFile: controller.selectedFile.value,
                uploadText: "Click to Upload Video",
                selectedText: "Video Selected",
              );
            }),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: 200,
              height: 48,
              child: CustomElevatedButton(
                  onPressed: () {
                    if (controller.shortMessageForm.currentState!.validate()) {
                      if (controller.youtubeVideoController.text.isNotEmpty ||
                          controller.selectedFile.value != null) {
                        controller.addShortMessage(context);
                      } else {
                        CustomToast.instance
                            .showMsg("Please fill all the details");
                      }
                    }
                  },
                  buttonText: "Publish Message"),
            ),
          ],
        ),
      ),
    );
  }
}
