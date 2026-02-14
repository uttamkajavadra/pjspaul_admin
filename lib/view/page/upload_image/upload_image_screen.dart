import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/upload_image/upload_image_controller.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/custom_upload_file.dart';
import 'package:pjspaul_admin/view/theme/app_theme.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  UploadImageController controller = Get.isRegistered<UploadImageController>()
      ? Get.find<UploadImageController>()
      : Get.put(UploadImageController());

  @override
  void initState() {
    controller.selectedImageFile = Rxn();
    controller.getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 800),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload New Image",
                    style: AppTheme.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(() {
                    return CustomUploadFile(
                      onTap: () {
                        controller.pickImageFile();
                      },
                      selectedFile: controller.selectedImageFile.value,
                      uploadText: "Click or Drag to Upload Image",
                      selectedText: "Image Ready to Upload",
                    );
                  }),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: CustomElevatedButton(
                        onPressed: () {
                          if (controller.selectedImageFile.value != null) {
                            controller.addImage(
                                context); // Changed from uploadImage to addImage as per original logic
                          } else {
                            CustomToast.instance
                                .showMsg("Please select an image");
                          }
                        },
                        buttonText: "Upload Image"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Obx(() {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.imageList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    color: AppTheme.surfaceColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                controller.imageList[index]["image"],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                webHtmlElementStrategy:
                                    WebHtmlElementStrategy.prefer,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(child: Icon(Icons.error));
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.imageList[index]["created_at"] ?? '',
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: CustomElevatedButton(
                                  onPressed: () async {
                                    final url =
                                        controller.imageList[index]["image"];
                                    final uri = Uri.parse(url);
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri,
                                          mode: LaunchMode.externalApplication);
                                    }
                                  },
                                  buttonText: "Download",
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    DeleteConfirmationDialog.show(
                                      context,
                                      onConfirm: () => controller.deleteImage(
                                          context, index),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Delete"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
