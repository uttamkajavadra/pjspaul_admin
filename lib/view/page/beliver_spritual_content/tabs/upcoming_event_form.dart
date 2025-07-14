import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_spritual_content/beliver_spritual_content_controller.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_date_picker.dart';
import 'package:pjspaul_admin/view/widget/custom_text_form_field.dart';
import 'package:pjspaul_admin/view/widget/custom_time_picker.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/custom_upload_file.dart';

class UpcomingEventForm extends StatelessWidget {
  const UpcomingEventForm({super.key});

  @override
  Widget build(BuildContext context) {
    BeliverSpritualContentController controller = Get.isRegistered<BeliverSpritualContentController>()
        ? Get.find<BeliverSpritualContentController>()
        : Get.put(BeliverSpritualContentController());

    return Form(
      key: controller.upcomingEventForm,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
                labelText: "Event Title",
                controller: controller.eventTitleController, 
                maxLength: 500,
                minLines: 5,
                maxLines: 5,
                validator: (value)=>Validator.validateNull("Event Title", value)),
          const SizedBox(
            height: 20,
          ),
          Obx(
                () {
                  return Row(
                    children: [
                      Expanded(
                        child: CustomDatePicker(onTap: (date){
                          controller.selectedDate.value = date;
                        }, selectedDate: controller.selectedDate.value),
                      ),
                      const SizedBox(width: 20,),
                      Expanded(child: CustomTimePicker(onTap: (time){
                    controller.selectedTime.value = time;
                  }, selectedTime: controller.selectedTime.value))
                    ],
                  );
                }
              ),
          const SizedBox(
            height: 20,
          ),
          CustomTextFormField(
                labelText: "Location",
                controller: controller.locationController, 
                maxLength: 200,
                minLines: 3,
                maxLines: 3,
                validator: (value)=>Validator.validateNull("Location", value)),
                const SizedBox(
            height: 20,
          ),
              CustomTextFormField(
                labelText: "Description",
                controller: controller.descriptionController, 
                maxLength: 500,
                minLines: 5,
                maxLines: 5,
                validator: (value)=>Validator.validateNull("Description", value)),
                const SizedBox(
            height: 20,
          ),
          Obx(() {
            return CustomUploadFile(
              onTap: () {
                controller.pickImageFile();
              },
              selectedFile: controller.selectedImageFile.value,
              uploadText: "Upload Image",
              selectedText: "Image Selected",
            );
          }),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
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
                if (controller.upcomingEventForm.currentState!.validate()) {
                  if (controller.selectedFile.value != null && controller.selectedImageFile.value != null) {
                    controller.addUpcomingEvent(context);
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