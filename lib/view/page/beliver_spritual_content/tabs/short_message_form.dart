import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_spritual_content/beliver_spritual_content_controller.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_text_form_field.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/custom_upload_file.dart';
import 'package:pjspaul_admin/view/widget/custom_yes_no.dart';

class ShortMessageForm extends StatelessWidget {
  const ShortMessageForm({super.key});

  @override
  Widget build(BuildContext context) {
    BeliverSpritualContentController controller = Get.isRegistered<BeliverSpritualContentController>()
        ? Get.find<BeliverSpritualContentController>()
        : Get.put(BeliverSpritualContentController());

    return Form(
      key: controller.shortMessageForm,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
                labelText: "Title",
                controller: controller.shortController, 
                maxLength: 100,
                minLines: 1,
                maxLines: 1,
                validator: (value)=>Validator.validateNull("Title", value)),
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
                labelText: "Message Content",
                controller: controller.messageController, 
                maxLength: 200,
                minLines: 3,
                maxLines: 3,
                validator: (value)=>Validator.validateNull("Message Content", value)),
                const SizedBox(
            height: 20,
          ),
          Obx(
            () {
              return CustomYesNo(
                isYoutube: controller.isYoutube.value, 
                onTap: (status){
                  controller.isYoutube.value = status;
                  controller.youtubeVideoController.text = "";
                });
            }
          ),
          const SizedBox(height: 20,),
          Obx(() {
            if(controller.isYoutube.value){
              return CustomTextFormField(
              controller: controller.youtubeVideoController,
              labelText: "Youtube Link",
              validator: (value) => Validator.validateNull("Youtube Link", value));
            }
            return CustomUploadFile(
              onTap: () {
                controller.pickFile();
              },
              selectedFile: controller.selectedFile.value,
              uploadText: "Upload Video",
              selectedText: "Video Selected",
            );
          }),
           const SizedBox(
            height: 20,
          ),
          CustomElevatedButton(
              onPressed: () {
                if (controller.shortMessageForm.currentState!.validate()) {
                  if (controller.youtubeVideoController.text.isNotEmpty || controller.selectedFile.value != null) {
                    controller.addShortMessage(context);
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