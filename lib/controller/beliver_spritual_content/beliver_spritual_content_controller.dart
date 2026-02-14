import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pjspaul_admin/utils/firebase_storage_helper.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class BeliverSpritualContentController extends GetxController {
  RxBool isGo = true.obs;
  RxBool isShowAdd = false.obs;

  List<List<String>> list = [
    [],
    ["Blessing Text", "Image Upload", "Video Upload", "Date", "Delete"],
    [
      "Event Title",
      "Location",
      "Date and Time",
      "Description",
      "Image Upload",
      "Video Upload",
      "Date",
      "Delete"
    ],
    ["Title", "Message Content", "Video", "Date", "Delete"],
    ["Video Title", "Video Upload", "Date", "Delete"],
    ["Song Title", "Audio File", "Date", "Delete"],
  ];
  RxInt selectedIndex = 0.obs;

  // Store full doc data for proper media rendering and deletion
  RxList<List<String>> listData = <List<String>>[].obs;
  RxList<String> listId = <String>[].obs;
  // Store video_type info per row for each video column
  RxList<Map<String, String>> listMeta = <Map<String, String>>[].obs;

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

  Rxn<Uint8List> selectedFile = Rxn();
  Future<void> pickFile({List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions ??
          ['png', 'jpg', 'jpeg', 'mp4', 'mp3', 'wav', 'doc', 'docx', 'pdf'],
    );
    if (result != null) {
      selectedFile.value = result.files.single.bytes;
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

  // ──────────────── RADIO LINK ────────────────

  final radioForm = GlobalKey<FormState>();
  final TextEditingController lifeChangingRadioController =
      TextEditingController();

  Future<void> addRadioLink(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      CollectionReference request = firestore.collection('radio');
      await request.doc('radio_link').update({
        'link': lifeChangingRadioController.text,
        'updated_at': FieldValue.serverTimestamp(),
      });
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      lifeChangingRadioController.clear();
      getRadioLink();
    }
  }

  Future<void> getRadioLink() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];

    final snapshot = await firestore.collection('radio').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([data["link"] ?? '']);
    }

    listId.assignAll(tempIds);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  // ──────────────── TODAY'S BLESSING ────────────────

  final blessingForm = GlobalKey<FormState>();
  final TextEditingController blessingController = TextEditingController();
  final TextEditingController youtubeVideoController = TextEditingController();
  RxBool isYoutube = false.obs;

  Future<void> addTodayBlessing(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      // Upload image
      final imageResult = await FirebaseStorageHelper.uploadFile(
        folder: 'today_blessing',
        bytes: selectedImageFile.value!,
        extension: 'png',
      );

      // Upload video or use YouTube URL
      String videoUrl = "";
      String videoStoragePath = "";
      String videoType = "upload";

      if (youtubeVideoController.text.isNotEmpty) {
        videoUrl = youtubeVideoController.text;
        videoType = "youtube";
      } else {
        final videoResult = await FirebaseStorageHelper.uploadFile(
          folder: 'today_blessing',
          bytes: selectedFile.value!,
          extension: 'mp4',
        );
        videoUrl = videoResult['download_url']!;
        videoStoragePath = videoResult['storage_path']!;
      }

      await firestore.collection('today_blessing').add({
        'blessing': blessingController.text,
        'image': imageResult['download_url']!,
        'image_storage_path': imageResult['storage_path']!,
        'video': videoUrl,
        'video_storage_path': videoStoragePath,
        'video_type': videoType,
        'created_at': FieldValue.serverTimestamp(),
      });
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      debugPrint("Error $e");
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      blessingController.clear();
      selectedFile = Rxn();
      selectedImageFile = Rxn();
      youtubeVideoController.text = "";
      getTodayBlessing();
    }
  }

  Future<void> getTodayBlessing() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];
    List<Map<String, String>> tempMeta = [];

    final snapshot = await firestore.collection('today_blessing').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([
        data["blessing"] ?? '',
        data["image"] ?? '',
        data["video"] ?? '',
        _formatDate(data["created_at"]),
        "delete",
      ]);
      tempMeta.add({
        'video_type': data['video_type'] ?? '',
        'image_storage_path': data['image_storage_path'] ?? '',
        'video_storage_path': data['video_storage_path'] ?? '',
      });
    }

    listId.assignAll(tempIds);
    listMeta.assignAll(tempMeta);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> deleteTodayBlessing(BuildContext context, int index) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      // Delete storage files
      if (index < listMeta.length) {
        final meta = listMeta[index];
        final data = listData[index];

        // Delete Image
        String? imgPath = meta['image_storage_path'];
        if (imgPath != null && imgPath.isNotEmpty) {
          await FirebaseStorageHelper.deleteFile(imgPath);
        } else if (data.length > 1 && data[1].startsWith('http')) {
          await FirebaseStorageHelper.deleteFileByUrl(data[1]);
        }

        // Delete Video
        if (meta['video_type'] != 'youtube') {
          String? vidPath = meta['video_storage_path'];
          if (vidPath != null && vidPath.isNotEmpty) {
            await FirebaseStorageHelper.deleteFile(vidPath);
          } else if (data.length > 2 && data[2].startsWith('http')) {
            await FirebaseStorageHelper.deleteFileByUrl(data[2]);
          }
        }
      }

      await firestore.collection('today_blessing').doc(listId[index]).delete();
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Delete successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      getTodayBlessing();
    }
  }

  // ──────────────── UPCOMING EVENT ────────────────

  final upcomingEventForm = GlobalKey<FormState>();
  final TextEditingController eventTitleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Rxn<DateTime> selectedDate = Rxn();
  Rxn<TimeOfDay> selectedTime = Rxn();

  String formatTimeOfDay(TimeOfDay tod, BuildContext context) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  Future<void> addUpcomingEvent(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      String imageUrl = "";
      String imageStoragePath = "";
      if (selectedImageFile.value != null) {
        final result = await FirebaseStorageHelper.uploadFile(
          folder: 'upcoming_event',
          bytes: selectedImageFile.value!,
          extension: 'png',
        );
        imageUrl = result['download_url']!;
        imageStoragePath = result['storage_path']!;
      }

      String videoUrl = "";
      String videoStoragePath = "";
      if (selectedFile.value != null) {
        final result = await FirebaseStorageHelper.uploadFile(
          folder: 'upcoming_event',
          bytes: selectedFile.value!,
          extension: 'mp4',
        );
        videoUrl = result['download_url']!;
        videoStoragePath = result['storage_path']!;
      }

      await firestore.collection('upcoming_event').add({
        'event_title': eventTitleController.text,
        'date': DateFormat('d MMM, yyyy').format(selectedDate.value!),
        'time': formatTimeOfDay(selectedTime.value!, context),
        'location': locationController.text,
        'description': descriptionController.text,
        'image': imageUrl,
        'image_storage_path': imageStoragePath,
        'video': videoUrl,
        'video_storage_path': videoStoragePath,
        'video_type': 'upload',
        'created_at': FieldValue.serverTimestamp(),
      });
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      debugPrint("Error $e");
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      eventTitleController.clear();
      locationController.clear();
      descriptionController.clear();
      selectedDate = Rxn();
      selectedTime = Rxn();
      selectedFile = Rxn();
      selectedImageFile = Rxn();
      getUpcomingEvent();
    }
  }

  Future<void> getUpcomingEvent() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];
    List<Map<String, String>> tempMeta = [];

    final snapshot = await firestore.collection('upcoming_event').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([
        data["event_title"] ?? '',
        data["location"] ?? '',
        "${data["date"] ?? ''} ${data["time"] ?? ''}",
        data["description"] ?? '',
        data["image"] ?? '',
        data["video"] ?? '',
        _formatDate(data["created_at"]),
        "delete",
      ]);
      tempMeta.add({
        'video_type': data['video_type'] ?? 'upload',
        'image_storage_path': data['image_storage_path'] ?? '',
        'video_storage_path': data['video_storage_path'] ?? '',
      });
    }

    listId.assignAll(tempIds);
    listMeta.assignAll(tempMeta);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> deleteUpcomingEvent(BuildContext context, int index) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      if (index < listMeta.length) {
        final meta = listMeta[index];
        final data = listData[index];

        // Delete Image
        String? imgPath = meta['image_storage_path'];
        if (imgPath != null && imgPath.isNotEmpty) {
          await FirebaseStorageHelper.deleteFile(imgPath);
        } else if (data.length > 4 && data[4].startsWith('http')) {
          await FirebaseStorageHelper.deleteFileByUrl(data[4]);
        }

        // Delete Video
        if (meta['video_type'] != 'youtube') {
          String? vidPath = meta['video_storage_path'];
          if (vidPath != null && vidPath.isNotEmpty) {
            await FirebaseStorageHelper.deleteFile(vidPath);
          } else if (data.length > 5 && data[5].startsWith('http')) {
            await FirebaseStorageHelper.deleteFileByUrl(data[5]);
          }
        }
      }

      await firestore.collection('upcoming_event').doc(listId[index]).delete();
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Delete successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      getUpcomingEvent();
    }
  }

  // ──────────────── SHORT MESSAGE ────────────────

  final shortMessageForm = GlobalKey<FormState>();
  final TextEditingController shortController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  Future<void> addShortMessage(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      String videoUrl = "";
      String videoStoragePath = "";
      String videoType = "upload";

      if (youtubeVideoController.text.isNotEmpty) {
        videoUrl = youtubeVideoController.text;
        videoType = "youtube";
      } else {
        final result = await FirebaseStorageHelper.uploadFile(
          folder: 'short_video',
          bytes: selectedFile.value!,
          extension: 'mp4',
        );
        videoUrl = result['download_url']!;
        videoStoragePath = result['storage_path']!;
      }

      await firestore.collection('short_message').add({
        'title': shortController.text,
        'message': messageController.text,
        'video': videoUrl,
        'video_storage_path': videoStoragePath,
        'video_type': videoType,
        'created_at': FieldValue.serverTimestamp(),
      });
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      debugPrint("Error $e");
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      shortController.clear();
      messageController.clear();
      selectedFile = Rxn();
      youtubeVideoController.text = "";
      getShortMessage();
    }
  }

  Future<void> getShortMessage() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];
    List<Map<String, String>> tempMeta = [];

    final snapshot = await firestore.collection('short_message').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([
        data["title"] ?? '',
        data["message"] ?? '',
        data["video"] ?? '',
        _formatDate(data["created_at"]),
        "delete",
      ]);
      tempMeta.add({
        'video_type': data['video_type'] ?? '',
        'video_storage_path': data['video_storage_path'] ?? '',
      });
    }

    listId.assignAll(tempIds);
    listMeta.assignAll(tempMeta);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> deleteShortMessage(BuildContext context, int index) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      if (index < listMeta.length) {
        final meta = listMeta[index];
        final data = listData[index];

        if (meta['video_type'] != 'youtube') {
          String? vidPath = meta['video_storage_path'];
          if (vidPath != null && vidPath.isNotEmpty) {
            await FirebaseStorageHelper.deleteFile(vidPath);
          } else if (data.length > 2 && data[2].startsWith('http')) {
            await FirebaseStorageHelper.deleteFileByUrl(data[2]);
          }
        }
      }

      await firestore.collection('short_message').doc(listId[index]).delete();
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Delete successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      getShortMessage();
    }
  }

  // ──────────────── LIFE CHANGING MESSAGE ────────────────

  final lifeMessgaeForm = GlobalKey<FormState>();
  final TextEditingController videoTitleController = TextEditingController();

  Future<void> addLifeMessage(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      String videoUrl = "";
      String videoStoragePath = "";
      String videoType = "upload";

      if (youtubeVideoController.text.isNotEmpty) {
        videoUrl = youtubeVideoController.text;
        videoType = "youtube";
      } else {
        final result = await FirebaseStorageHelper.uploadFile(
          folder: 'life_message',
          bytes: selectedFile.value!,
          extension: 'mp4',
        );
        videoUrl = result['download_url']!;
        videoStoragePath = result['storage_path']!;
      }

      await firestore.collection('life_message').add({
        'title': videoTitleController.text,
        'video': videoUrl,
        'video_storage_path': videoStoragePath,
        'video_type': videoType,
        'created_at': FieldValue.serverTimestamp(),
      });
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      debugPrint("Error $e");
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      videoTitleController.clear();
      selectedFile = Rxn();
      youtubeVideoController.text = "";
      getLifeMessage();
    }
  }

  Future<void> getLifeMessage() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];
    List<Map<String, String>> tempMeta = [];

    final snapshot = await firestore.collection('life_message').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([
        data["title"] ?? '',
        data["video"] ?? '',
        _formatDate(data["created_at"]),
        "delete",
      ]);
      tempMeta.add({
        'video_type': data['video_type'] ?? '',
        'video_storage_path': data['video_storage_path'] ?? '',
      });
    }

    listId.assignAll(tempIds);
    listMeta.assignAll(tempMeta);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> deleteLifeMessage(BuildContext context, int index) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      if (index < listMeta.length) {
        final meta = listMeta[index];
        final data = listData[index];

        if (meta['video_type'] != 'youtube') {
          String? vidPath = meta['video_storage_path'];
          if (vidPath != null && vidPath.isNotEmpty) {
            await FirebaseStorageHelper.deleteFile(vidPath);
          } else if (data.length > 1 && data[1].startsWith('http')) {
            await FirebaseStorageHelper.deleteFileByUrl(data[1]);
          }
        }
      }

      await firestore.collection('life_message').doc(listId[index]).delete();
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Delete successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      getLifeMessage();
    }
  }

  // ──────────────── LIFE CHANGING SONG ────────────────

  final lifeSongForm = GlobalKey<FormState>();
  final TextEditingController songTitleController = TextEditingController();

  Future<void> addLifeSong(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      final result = await FirebaseStorageHelper.uploadFile(
        folder: 'life_song',
        bytes: selectedFile.value!,
        extension: 'mp3',
      );

      await firestore.collection('life_song').add({
        'title': songTitleController.text,
        'audio': result['download_url']!,
        'audio_storage_path': result['storage_path']!,
        'created_at': FieldValue.serverTimestamp(),
      });
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      debugPrint("Error $e");
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      songTitleController.clear();
      selectedFile = Rxn();
      getLifeSong();
    }
  }

  Future<void> getLifeSong() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];
    List<Map<String, String>> tempMeta = [];

    final snapshot = await firestore.collection('life_song').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([
        data["title"] ?? '',
        data["audio"] ?? '',
        _formatDate(data["created_at"]),
        "delete",
      ]);
      tempMeta.add({
        'audio_storage_path': data['audio_storage_path'] ?? '',
      });
    }

    listId.assignAll(tempIds);
    listMeta.assignAll(tempMeta);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> deleteLifeSong(BuildContext context, int index) async {
    try {
      ProgressBar.instance.showProgressbar(context);

      if (index < listMeta.length) {
        final meta = listMeta[index];
        final data = listData[index];

        String? audioPath = meta['audio_storage_path'];
        if (audioPath != null && audioPath.isNotEmpty) {
          await FirebaseStorageHelper.deleteFile(audioPath);
        } else if (data.length > 1 && data[1].startsWith('http')) {
          await FirebaseStorageHelper.deleteFileByUrl(data[1]);
        }
      }

      await firestore.collection('life_song').doc(listId[index]).delete();
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
