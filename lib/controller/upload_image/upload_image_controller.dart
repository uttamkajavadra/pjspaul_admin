import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pjspaul_admin/utils/firebase_storage_helper.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class UploadImageController extends GetxController {
  Rxn<Uint8List?> selectedImageFile = Rxn();

  Future<void> pickImageFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (result != null) {
      Uint8List file = result.files.single.bytes!;
      if (file.length <= 2 * 1024 * 1024) {
        selectedImageFile.value = file;
      } else {
        selectedImageFile.value = null;
        CustomToast.instance.showMsg("File is more than 2 MB");
      }
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    if (timestamp is Timestamp) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());
    }
    if (timestamp is String) return timestamp;
    return 'N/A';
  }

  Future<void> addImage(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      final result = await FirebaseStorageHelper.uploadFile(
        folder: 'upload_image',
        bytes: selectedImageFile.value!,
        extension: 'png',
      );

      await firestore.collection('upload_image').add({
        'image': result['download_url']!,
        'storage_path': result['storage_path']!,
        'created_at': FieldValue.serverTimestamp(),
      });
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      debugPrint("Error $e");
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      selectedImageFile = Rxn();
      getImage();
    }
  }

  RxList<String> listId = <String>[].obs;
  RxList<Map<String, dynamic>> imageList = <Map<String, dynamic>>[].obs;

  Future<void> getImage() async {
    imageList.clear();
    listId.clear();
    firestore.collection('upload_image').get().then((snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        listId.add(doc.id);
        imageList.add({
          'image': data['image'] ?? '',
          'storage_path': data['storage_path'] ?? '',
          'created_at': _formatDate(data['created_at']),
        });
      }
    });
  }

  Future<void> deleteImage(BuildContext context, int index) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      // Delete from Firebase Storage
      final doc =
          await firestore.collection('upload_image').doc(listId[index]).get();
      if (doc.exists) {
        await FirebaseStorageHelper.deleteFile(doc.data()?['storage_path']);
      }
      // Delete from Firestore
      await firestore.collection('upload_image').doc(listId[index]).delete();
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
