import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class BeliverRegistrationController extends GetxController {
  RxBool isGo = true.obs;

  List<List<String>> list = [
    [
      "Full Name",
      "Location",
      "Contact Number",
      "Age",
      "Profession",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Address",
      "Contact Number",
      "I am a",
      "Church Name",
      "Church Address",
      "Current Profession",
      "Ministry started Date",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Address",
      "Contact Number",
      "Age",
      "Gender",
      "Education",
      "Reason to pursue Bible college",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Contact Number",
      "Complete Address",
      "Business Name",
      "Industry",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Contact Number",
      "Complete Address",
      "Gender",
      "Attending Church Since",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Profession",
      "Speciality",
      "Contact Number",
      "Working Organization",
      "Date",
      "Delete"
    ],
    [
      "Full Name",
      "Location",
      "Contact Number",
      "Gender",
      "Prayer  Slot Preference",
      "Date",
      "Delete"
    ],
  ];
  RxInt selectedIndex = 0.obs;

  RxList<List<String>> listData = <List<String>>[].obs;
  RxList<String> listId = <String>[].obs;

  String _formatDate(dynamic timestamp) {
    if (timestamp == null) return 'N/A';
    if (timestamp is Timestamp) {
      return DateFormat('dd MMM yyyy, hh:mm a').format(timestamp.toDate());
    }
    if (timestamp is String) return timestamp;
    return 'N/A';
  }

  // Helper to fetch data with date and doc IDs
  Future<void> _fetchCollection(String collection, List<String> fields) async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];

    final snapshot =
        await FirebaseFirestore.instance.collection(collection).get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      List<String> row = fields.map((f) => (data[f] ?? '').toString()).toList();
      row.add(_formatDate(data['created_at']));
      row.add('delete');
      tempData.add(row);
    }

    listId.assignAll(tempIds);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> deleteRecord(BuildContext context, int index) async {
    String collection = '';
    if (selectedIndex.value == 0)
      collection = 'youth_registration';
    else if (selectedIndex.value == 1)
      collection = 'leader_register';
    else if (selectedIndex.value == 2)
      collection = 'college_register';
    else if (selectedIndex.value == 3)
      collection = 'business_register';
    else if (selectedIndex.value == 4)
      collection = 'baptism_register';
    else if (selectedIndex.value == 5)
      collection = 'doctor_register';
    else if (selectedIndex.value == 6) collection = 'chain_prayer_register';

    try {
      ProgressBar.instance.showProgressbar(context);
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
    if (selectedIndex.value == 0)
      getYouthRegistration();
    else if (selectedIndex.value == 1)
      getLeaderRegistration();
    else if (selectedIndex.value == 2)
      getCollegeRegister();
    else if (selectedIndex.value == 3)
      getBusinessRegister();
    else if (selectedIndex.value == 4)
      getBaptismRegister();
    else if (selectedIndex.value == 5)
      getDoctorRegister();
    else if (selectedIndex.value == 6) getChainPrayer();
  }

  Future<void> getYouthRegistration() async {
    await _fetchCollection('youth_registration',
        ['name', 'location', 'contact', 'birth_date', 'profession']);
  }

  Future<void> getLeaderRegistration() async {
    await _fetchCollection('leader_register', [
      'name',
      'location',
      'contact',
      'i_am',
      'church_name',
      'church_address',
      'current_profession',
      'ministry_started'
    ]);
  }

  Future<void> getCollegeRegister() async {
    await _fetchCollection('college_register', [
      'name',
      'location',
      'contact',
      'birth_date',
      'gender',
      'education',
      'reason'
    ]);
  }

  Future<void> getBusinessRegister() async {
    await _fetchCollection('business_register',
        ['name', 'contact', 'address', 'business_name', 'industry']);
  }

  Future<void> getBaptismRegister() async {
    await _fetchCollection('baptism_register',
        ['name', 'address', 'contact', 'gender', 'attending_church']);
  }

  Future<void> getDoctorRegister() async {
    await _fetchCollection('doctor_register',
        ['name', 'profession', 'specially', 'contact', 'working']);
  }

  Future<void> getChainPrayer() async {
    await _fetchCollection('chain_prayer_register',
        ['name', 'address', 'contact', 'gender', 'prayer_slot']);
  }
}
