import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class UploadImageController extends GetxController{
  Rxn<Uint8List?> selectedImageFile = Rxn();
  Future<void> pickImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      Uint8List file = result.files.single.bytes!;

      // Validate file size (2 MB = 2 * 1024 * 1024 bytes)
      if (file.length <= 2 * 1024 * 1024) {
          selectedImageFile.value = file;
      } else {
          selectedImageFile.value = null;
           CustomToast.instance.showMsg("File is more than 2 MB");
      }
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addImage(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      final storageRef = FirebaseStorage.instance.ref();

      final fileImageRef = storageRef.child('upload_image/${DateTime.now().millisecondsSinceEpoch}.png');
      await fileImageRef.putData(selectedImageFile.value!);
      String imageUrl = await fileImageRef.getDownloadURL();

      CollectionReference request = firestore.collection('upload_image');

      await request.add({
      'image': imageUrl,   
    });
      ProgressBar.instance.stopProgressBar(context);
      // Get.back();
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      // Get.back();
      print("Error $e");
      CustomToast.instance.showMsg("Something went wrong");
    } finally{
      selectedImageFile = Rxn();
      getImage();
    }
  }
  RxList<String> listId = <String>[].obs;
  RxList<Map<String, dynamic>> imageList = <Map<String, dynamic>>[].obs;
  Future<void> getImage() async {
    imageList.clear();
    listId.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('upload_image').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listId.add(doc.id);
        imageList.add(data);
        print(imageList);
      });
    });
  }

  Future<void> deleteImage(BuildContext context, int index) async {
  try {
    ProgressBar.instance.showProgressbar(context);
    await FirebaseFirestore.instance
        .collection('upload_image') // Replace with your collection name
        .doc(listId[index]) // Document ID
        .delete();
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Delete successfully");
  } catch (e) {
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Something went wrong");
  } finally {
    await getImage();
  }
}
}