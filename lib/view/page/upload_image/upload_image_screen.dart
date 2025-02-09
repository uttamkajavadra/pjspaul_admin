import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/upload_image/upload_image_controller.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_upload_file.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  UploadImageController controller = Get.isRegistered<UploadImageController>() 
    ? Get.find<UploadImageController>() : Get.put(UploadImageController());
  
  @override
  void initState() {
    controller.selectedImageFile = Rxn();
    controller.getImage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return CustomUploadFile(
                onTap: () async{
                  await controller.pickImageFile();
                  await controller.addImage(context);
                },
                selectedFile: controller.selectedImageFile.value,
                uploadText: "Upload Image",
                selectedText: "Image Selected",
              );
            }),
            const SizedBox(height: 30,),
            Obx(
              () {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.imageList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3), 
                    itemBuilder: (context, index){
                      // return Container(
                      //   width: double.infinity,
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //     image: DecorationImage(
                      //       image: NetworkImage(controller.imageList[index]["image"])
                      //     )
                      //   ),
                      // );
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                    controller.imageList[index]["image"] , 
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child; // Image is fully loaded
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    ); // Show a loading indicator while the image is loading
                                  }
                                },
                                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                  return Center(
                                    child: Icon(Icons.error), // Show an error icon if the image fails to load
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10,),
                            CustomElevatedButton(onPressed: () async{
                              await controller.deleteImage(context, index);
                            }, 
                            buttonText: "Delete Image")
                          ],
                        ),
                      );
                    });
              }
            )
          ],
        ),
      ),
    );
  }
}