import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class OtherController extends GetxController{
   RxBool isGo = true.obs;
  RxBool isShowAdd = false.obs;
  List<List<String>> list = [
    ["Location"],
    ["Location"],
    ["TV Program Name", "delete"],
    ["Email Address"],
    ["Donor Name", "Contact Number", "Donation Amount", "Payment Method"],
  ];
  RxInt selectedIndex = 0.obs;

  RxList<List<String>> listData = <List<String>>[].obs;

  Future<void> getLifeChangingChurch() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('life_changing_church').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["location"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getPJSMinistries() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('pjs_ministies').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["ministry_location"]]);
      });
      isGo.value = true;
    });
  }

  final lifeTVProgram = GlobalKey<FormState>();
  TextEditingController tvProgramController = TextEditingController();
  RxList<String> listId = <String>[].obs;

  Future<void> addTVProgram(BuildContext context) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      CollectionReference request = firestore.collection('life_tv_program');

      await request.add({
        'tv_program': tvProgramController.text,
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
      tvProgramController.clear();
      getLifeTVProgram();
    }
  }

  Future<void> getLifeTVProgram() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('life_tv_program').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["tv_program"], "delete"]);
        listId.add(doc.id);
      });
    });
    isGo.value = true;
  }

  Future<void> deleteLifeTVProgram(BuildContext context, int index) async {
  try {
    ProgressBar.instance.showProgressbar(context);
    await FirebaseFirestore.instance
        .collection('life_tv_program') // Replace with your collection name
        .doc(listId[index]) // Document ID
        .delete();
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Delete successfully");
  } catch (e) {
    ProgressBar.instance.stopProgressBar(context);
    CustomToast.instance.showMsg("Something went wrong");
  } finally {
    getLifeTVProgram();
  }
}


  Future<void> getEmailAddress() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('email').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["email"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getDontation() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('donation').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["donor_name"], data["contact"], data["amount"], "Razorpay"]);
      });
      isGo.value = true;
    });
  }
}