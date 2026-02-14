import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pjspaul_admin/utils/firebase_storage_helper.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class BeliverRequestFormController extends GetxController {
  RxBool isGo = true.obs;

  List<List<String>> list = [
    [
      "Full Name",
      "Location",
      "Contact Number",
      "Prayer Request",
      "Upload File",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Location",
      "Contact Number",
      "Testimony Details",
      "Upload File",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Location",
      "Contact Number",
      "Visit requested for",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Contact Number",
      "Counseling Requested For",
      "Date",
      "Delete"
    ],
    ["Full Name", "Contact Number", "Suggestions/Feedback", "Date", "Delete"],
    [
      "Full Name",
      "Location",
      "Contact Number",
      "WhatsApp",
      "Reason for Appointment requested",
      "Preferred Date",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Contact Number",
      "Child's Name",
      "Gender",
      "Complete Address",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Complete Address",
      "Contact Number",
      "Volunteering Area of Interest",
      "Profession",
      "Volunteer Type",
      "Date",
      "Delete"
    ],
  ];
  RxInt selectedIndex = 0.obs;

  RxList<List<String>> listData = <List<String>>[].obs;
  RxList<String> listId = <String>[].obs;
  // Store storage paths for file columns
  RxList<Map<String, String>> listMeta = <Map<String, String>>[].obs;

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    if (timestamp is Timestamp) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());
    }
    if (timestamp is String) return timestamp;
    return 'N/A';
  }

  Future<void> _fetchCollection(String collection, List<String> fields,
      {bool hasFile = false}) async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];
    List<Map<String, String>> tempMeta = [];

    final snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      List<String> row = fields.map((f) => (data[f] ?? '').toString()).toList();
      row.add(_formatDate(data['created_at']));
      row.add('delete');
      tempData.add(row);
      tempMeta.add({
        if (hasFile) 'image_storage_path': data['image_storage_path'] ?? '',
      });
    }

    listId.assignAll(tempIds);
    listMeta.assignAll(tempMeta);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> deleteRecord(BuildContext context, int index) async {
    final collectionMap = {
      0: 'prayer_request',
      1: 'testimony_request',
      2: 'cottage_prayers',
      3: 'counseling_request',
      4: 'feedback_request',
      5: 'pastor_request',
      6: 'child_dedication',
      7: 'volunteer_enrollment',
    };
    final hasFileMap = {0: true, 1: true};
    final collection = collectionMap[selectedIndex.value] ?? '';
    final hasFile = hasFileMap.containsKey(selectedIndex.value);

    try {
      ProgressBar.instance.showProgressbar(context);
      // Clean up storage files if applicable
      // Clean up storage files if applicable
      if (hasFile) {
        String? storagePath;
        if (index < listMeta.length &&
            listMeta[index].containsKey('image_storage_path')) {
          storagePath = listMeta[index]['image_storage_path'];
        }

        if (storagePath != null && storagePath.isNotEmpty) {
          await FirebaseStorageHelper.deleteFile(storagePath);
        } else {
          // Fallback: Try deleting by URL if storage path is missing
          if (index < listData.length && listData[index].length > 4) {
            String url = listData[index][4];
            if (url.startsWith('http')) {
              await FirebaseStorageHelper.deleteFileByUrl(url);
            }
          }
        }
      }
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(listId[index])
          .delete();
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Delete successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      refreshCurrent();
    }
  }

  void refreshCurrent() {
    switch (selectedIndex.value) {
      case 0:
        getPrayerRequest();
        break;
      case 1:
        getTestimonyRequest();
        break;
      case 2:
        getCottagePrayer();
        break;
      case 3:
        getCounselingRequest();
        break;
      case 4:
        getFeedbackRequest();
        break;
      case 5:
        getPastorRequest();
        break;
      case 6:
        getChildDedication();
        break;
      case 7:
        getVolunteerEnrollment();
        break;
    }
  }

  Future<void> getPrayerRequest() async {
    await _fetchCollection('prayer_request',
        ['name', 'location', 'contact', 'prayer_request', 'image'],
        hasFile: true);
  }

  Future<void> getTestimonyRequest() async {
    await _fetchCollection('testimony_request',
        ['name', 'location', 'contact', 'testimony_request', 'image'],
        hasFile: true);
  }

  Future<void> getCottagePrayer() async {
    await _fetchCollection(
        'cottage_prayers', ['name', 'location', 'contact', 'visit_request']);
  }

  Future<void> getCounselingRequest() async {
    await _fetchCollection(
        'counseling_request', ['name', 'contact', 'counseling_request']);
  }

  Future<void> getFeedbackRequest() async {
    await _fetchCollection('feedback_request', ['name', 'contact', 'feedback']);
  }

  Future<void> getPastorRequest() async {
    await _fetchCollection('pastor_request',
        ['name', 'location', 'contact', 'whatsapp', 'appointment', 'date']);
  }

  Future<void> getChildDedication() async {
    await _fetchCollection('child_dedication',
        ['name', 'contact', 'child_name', 'gender', 'address']);
  }

  Future<void> getVolunteerEnrollment() async {
    await _fetchCollection('volunteer_enrollment', [
      'name',
      'address',
      'contact',
      'area_of_interest',
      'profession',
      'volunteer_type'
    ]);
  }
}
