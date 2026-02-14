import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class OtherController extends GetxController {
  RxBool isGo = true.obs;
  RxBool isShowAdd = false.obs;

  List<List<String>> list = [
    ["Location", "Date", "Delete"],
    ["Location", "Date", "Delete"],
    ["TV Program Name", "Date", "Delete"],
    ["Name", "Email Address", "Phone", "Subject", "Message", "Date", "Delete"],
    [
      "Donor Name",
      "Contact Number",
      "Donation Amount",
      "Payment Method",
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

  final lifeTVProgram = GlobalKey<FormState>();
  TextEditingController tvProgramController = TextEditingController();

  Future<void> addTVProgram(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      await FirebaseFirestore.instance.collection('life_tv_program').add({
        'tv_program': tvProgramController.text,
        'created_at': FieldValue.serverTimestamp(),
      });
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Added Successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      debugPrint("Error $e");
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      tvProgramController.clear();
      getLifeTVProgram();
    }
  }

  Future<void> deleteRecord(BuildContext context, int index) async {
    final collectionMap = {
      0: 'life_changing_church',
      1: 'pjs_ministies',
      2: 'life_tv_program',
      3: 'email',
      4: 'donation',
    };
    final collection = collectionMap[selectedIndex.value] ?? '';
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
    switch (selectedIndex.value) {
      case 0:
        getLifeChangingChurch();
        break;
      case 1:
        getPJSMinistries();
        break;
      case 2:
        getLifeTVProgram();
        break;
      case 3:
        getEmailAddress();
        break;
      case 4:
        getDontation();
        break;
    }
  }

  Future<void> getLifeChangingChurch() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];

    final snapshot = await FirebaseFirestore.instance
        .collection('life_changing_church')
        .get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add(
          [data["location"] ?? '', _formatDate(data["created_at"]), 'delete']);
    }

    listId.assignAll(tempIds);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> getPJSMinistries() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];

    final snapshot =
        await FirebaseFirestore.instance.collection('pjs_ministies').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([
        data["ministry_location"] ?? '',
        _formatDate(data["created_at"]),
        'delete'
      ]);
    }

    listId.assignAll(tempIds);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> getLifeTVProgram() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];

    final snapshot =
        await FirebaseFirestore.instance.collection('life_tv_program').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([
        data["tv_program"] ?? '',
        _formatDate(data["created_at"]),
        'delete'
      ]);
    }

    listId.assignAll(tempIds);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> getEmailAddress() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];

    final snapshot = await FirebaseFirestore.instance.collection('email').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([
        data["name"] ?? '',
        data["email"] ?? '',
        data["phone"] ?? '',
        data["subject"] ?? '',
        data["message"] ?? '',
        _formatDate(data["created_at"]),
        'delete',
      ]);
    }

    listId.assignAll(tempIds);
    listData.assignAll(tempData);
    isGo.value = true;
  }

  Future<void> getDontation() async {
    isGo.value = false;
    List<List<String>> tempData = [];
    List<String> tempIds = [];

    final snapshot =
        await FirebaseFirestore.instance.collection('donation').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      tempIds.add(doc.id);
      tempData.add([
        data["donor_name"] ?? '',
        data["contact"] ?? '',
        data["amount"] ?? '',
        "Razorpay",
        _formatDate(data["created_at"]),
        'delete',
      ]);
    }

    listId.assignAll(tempIds);
    listData.assignAll(tempData);
    isGo.value = true;
  }
}
