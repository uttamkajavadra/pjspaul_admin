import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class BeliverSpritualContentController extends GetxController{
  RxBool isGo = true.obs;

  RxBool isShowAdd = false.obs;
  List<List<String>> list = [
    [],
    ["Blessing Text", "Image Upload", "Video Upload", "Delete"],
    ["Event Title", "Location", "Date and Time", "Description", "Delete"],
    ["Title", "Message Content", "Delete"],
    ["Video Title", "Video Upload", "Delete"],
    ["Song Title", "Audio File", "Delete"],
  ];
  RxInt selectedIndex = 0.obs;

  RxList<List<String>> listData = <List<String>>[].obs;
  RxList<String> listId = <String>[].obs;

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

  Rxn<Uint8List> selectedFile = Rxn();

  Future<void> pickFile({List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions ?? ['png', 'jpg', 'jpeg', 'png', 'mp4', 'mp3', 'wav', 'doc', 'docx', 'pdf'],
    );

    if (result != null) {
      Uint8List? file = result.files.single.bytes;

      // Validate file size (2 MB = 2 * 1024 * 1024 bytes)
      if (file!.length <= 2 * 1024 * 1024) {
          selectedFile.value = file;
      } else {
          selectedFile.value = null;
          CustomToast.instance.showMsg("File is more than 2 MB");
      }
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final radioForm = GlobalKey<FormState>();
  final TextEditingController lifeChangingRadioController = TextEditingController();
  Future<void> addRadioLink(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      // final storageRef = FirebaseStorage.instance.ref();

      // final fileImageRef = storageRef.child('today_blessing/${selectedImageFile.value!.path.split('/').last.split('.').first}_${DateTime.now().millisecondsSinceEpoch}.${selectedImageFile.value!.path.split('.').last}');
      // await fileImageRef.putData(selectedImageFile.value!);
      // String imageUrl = await fileImageRef.getDownloadURL();

      // final fileRef = storageRef.child('today_blessing/${selectedFile.value!.path.split('/').last.split('.').first}_${DateTime.now().millisecondsSinceEpoch}.${selectedFile.value!.path.split('.').last}');
      // await fileRef.putData(selectedFile.value!);
      // String videoUrl = await fileRef.getDownloadURL();

      CollectionReference request = firestore.collection('radio');

      await request.doc('radio_link').update({
      'link':lifeChangingRadioController.text         
    });
      ProgressBar.instance.stopProgressBar(context);
      // Get.back();
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      // Get.back();
      CustomToast.instance.showMsg("Something went wrong");
    } finally{
      lifeChangingRadioController.clear();
      getRadioLink();
    }
  }

  Future<void> getRadioLink() async {
    isGo.value = false;
    listData.clear();
    listId.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('radio').get().then((snapshot) {
      listData.clear();
    listId.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listId.add(doc.id);
        listData.add([data["link"]]);
      });
      print("getRadioLink");
      isGo.value = true;
    });
  }



  final blessingForm = GlobalKey<FormState>();
  final TextEditingController blessingController = TextEditingController();
  Future<void> addTodayBlessing(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      final storageRef = FirebaseStorage.instance.ref();

      final fileImageRef = storageRef.child('today_blessing/${DateTime.now().millisecondsSinceEpoch}.png');
      await fileImageRef.putData(selectedImageFile.value!);
      String imageUrl = await fileImageRef.getDownloadURL();

      final fileRef = storageRef.child('today_blessing/${DateTime.now().millisecondsSinceEpoch}.mp4');
      await fileRef.putData(selectedFile.value!);
      String videoUrl = await fileRef.getDownloadURL();

      CollectionReference request = firestore.collection('today_blessing');

      await request.add({
      'blessing': blessingController.text,
      'image': imageUrl,
      'video': videoUrl,    
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
      blessingController.clear();
      selectedFile = Rxn();
      selectedImageFile = Rxn();
      getTodayBlessing();
    }
  }

  Future<void> getTodayBlessing() async {
    isGo.value = false;
    listData.clear();
    listId.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('today_blessing').get().then((snapshot) {
      listData.clear();
      listId.clear();
      snapshot.docs.forEach((doc) {
        listId.add(doc.id);
        var data = doc.data();
        listId.add(doc.id);
        listData.add([data["blessing"], data["image"], data["video"], "delete"]);
      });
       print("getTodayBlessing");
       isGo.value = true;
    });
  }


Future<void> deleteTodayBlessing(BuildContext context, int index) async {
  try {
    ProgressBar.instance.showProgressbar(context);
    await FirebaseFirestore.instance
        .collection('today_blessing') // Replace with your collection name
        .doc(listId[index]) // Document ID
        .delete();
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Delete successfully");
  } catch (e) {
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Something went wrong");
  } finally {
    getTodayBlessing();
  }
}

  final upcomingEventForm = GlobalKey<FormState>();
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Rxn<DateTime> selectedDate = Rxn();
  Rxn<TimeOfDay> selectedTime = Rxn();
  String formatTimeOfDay(TimeOfDay tod, BuildContext contxet) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      return TimeOfDay.fromDateTime(dt).format(contxet);
    }
  Future<void> addUpcomingEvent(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      // final storageRef = FirebaseStorage.instance.ref();

      // final fileImageRef = storageRef.child('today_blessing/${DateTime.now().millisecondsSinceEpoch}.png');
      // await fileImageRef.putData(selectedImageFile.value!);
      // String imageUrl = await fileImageRef.getDownloadURL();

      // final fileRef = storageRef.child('today_blessing/${DateTime.now().millisecondsSinceEpoch}.png');
      // await fileRef.putData(selectedFile.value!);
      // String videoUrl = await fileRef.getDownloadURL();

      CollectionReference request = firestore.collection('upcoming_event');

      await request.add({
        'event_title': eventTitleController.text,
        'date': DateFormat('d MMM, yyyy').format(selectedDate.value!),
        'time': formatTimeOfDay(selectedTime.value!, context),
        'location': locationController.text,
        'description': descriptionController.text,
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
      eventTitleController.clear();
      locationController.clear();
      descriptionController.clear();
      selectedDate = Rxn();
      selectedTime = Rxn();
      getUpcomingEvent();
    }
  }
  
  Future<void> getUpcomingEvent() async {
    isGo.value = false;
    listData.clear();
    listId.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('upcoming_event').get().then((snapshot) {
      listData.clear();
      listId.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listId.add(doc.id);
        listData.add([data["event_title"], data["location"], "${data["date"]} ${data["time"]}", data["description"], "delete"]);
        
      });
      print("getUpcomingEvent");
              isGo.value = true;
    });
  }

  Future<void> deleteUpcomingEvent(BuildContext context, int index) async {
  try {
    ProgressBar.instance.showProgressbar(context);
    await FirebaseFirestore.instance
        .collection('upcoming_event') // Replace with your collection name
        .doc(listId[index]) // Document ID
        .delete();
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Delete successfully");
  } catch (e) {
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Something went wrong");
  } finally {
    getUpcomingEvent();
  }
}

  final shortMessageForm = GlobalKey<FormState>();
  final TextEditingController shortController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  Future<void> addShortMessage(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      // final storageRef = FirebaseStorage.instance.ref();

      // final fileImageRef = storageRef.child('today_blessing/${DateTime.now().millisecondsSinceEpoch}.png');
      // await fileImageRef.putData(selectedImageFile.value!);
      // String imageUrl = await fileImageRef.getDownloadURL();

      // final fileRef = storageRef.child('today_blessing/${DateTime.now().millisecondsSinceEpoch}.png');
      // await fileRef.putData(selectedFile.value!);
      // String videoUrl = await fileRef.getDownloadURL();

      CollectionReference request = firestore.collection('short_message');

      await request.add({
        'title': shortController.text,
        'message': messageController.text,
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
      shortController.clear();
      messageController.clear();
      getShortMessage();
    }
  }

  Future<void> getShortMessage() async {
    isGo.value = false;
    listData.clear();
    listId.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('short_message').get().then((snapshot) {
      listData.clear();
      listId.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listId.add(doc.id);
        listData.add([data["title"], data["message"], "delete"]);
      });
      print("getShortMessage");
        isGo.value = true;
      });
  }

  Future<void> deleteShortMessage(BuildContext context, int index) async {
  try {
    ProgressBar.instance.showProgressbar(context);
    await FirebaseFirestore.instance
        .collection('short_message') // Replace with your collection name
        .doc(listId[index]) // Document ID
        .delete();
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Delete successfully");
  } catch (e) {
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Something went wrong");
  } finally {
    getShortMessage();
  }
}

  final lifeMessgaeForm = GlobalKey<FormState>();
  final TextEditingController videoTitleController = TextEditingController();
  Future<void> addLifeMessage(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      final storageRef = FirebaseStorage.instance.ref();

      // final fileImageRef = storageRef.child('today_blessing/${DateTime.now().millisecondsSinceEpoch}.png');
      // await fileImageRef.putData(selectedImageFile.value!);
      // String imageUrl = await fileImageRef.getDownloadURL();

      final fileRef = storageRef.child('life_message/${DateTime.now().millisecondsSinceEpoch}.mp4');
      await fileRef.putData(selectedFile.value!);
      String videoUrl = await fileRef.getDownloadURL();

      CollectionReference request = firestore.collection('life_message');

      await request.add({
        'title': videoTitleController.text,
        'video': videoUrl,
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
      videoTitleController.clear();
      selectedFile = Rxn();
      getLifeMessage();
    }
  }

  Future<void> getLifeMessage() async {
    isGo.value = false;
    listData.clear();
    listId.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('life_message').get().then((snapshot) {
      listData.clear();
      listId.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listId.add(doc.id);
        listData.add([data["title"], data["video"], "delete"]);
      });
       print("getLifeMessage");
               isGo.value = true;
    });
  }

  Future<void> deleteLifeMessage(BuildContext context, int index) async {
  try {
    ProgressBar.instance.showProgressbar(context);
    await FirebaseFirestore.instance
        .collection('life_message') // Replace with your collection name
        .doc(listId[index]) // Document ID
        .delete();
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Delete successfully");
  } catch (e) {
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Something went wrong");
  } finally {
    getLifeMessage();
  }
}

  final lifeSongForm = GlobalKey<FormState>();
  final TextEditingController songTitleController = TextEditingController();
  Future<void> addLifeSong(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      final storageRef = FirebaseStorage.instance.ref();

      // final fileImageRef = storageRef.child('today_blessing/${DateTime.now().millisecondsSinceEpoch}.png');
      // await fileImageRef.putData(selectedImageFile.value!);
      // String imageUrl = await fileImageRef.getDownloadURL();

      final fileRef = storageRef.child('life_song/${DateTime.now().millisecondsSinceEpoch}.mp3');
      await fileRef.putData(selectedFile.value!);
      String url = await fileRef.getDownloadURL();

      CollectionReference request = firestore.collection('life_song');

      await request.add({
        'title': songTitleController.text,
        'audio': url,
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
      songTitleController.clear();
      selectedFile = Rxn();
      getLifeSong();
    }
  }

  Future<void> getLifeSong() async {
    isGo.value = false;
    listData.clear();
    listId.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('life_song').get().then((snapshot) {
      listData.clear();
      listId.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listId.add(doc.id);
        listData.add([data["title"], data["audio"], "delete"]);
      });
      print("getLifeSong");
              isGo.value = true;
    });
  }

  Future<void> deleteLifeSong(BuildContext context, int index) async {
  try {
    ProgressBar.instance.showProgressbar(context);
    await FirebaseFirestore.instance
        .collection('life_song') // Replace with your collection name
        .doc(listId[index]) // Document ID
        .delete();
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Delete successfully");
  } catch (e) {
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Something went wrong");
  } finally {
    getLifeSong();
  }
}
}