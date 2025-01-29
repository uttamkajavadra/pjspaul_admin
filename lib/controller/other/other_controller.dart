import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class OtherController extends GetxController{
  RxBool isShowAdd = false.obs;
  List<List<String>> list = [
    ["Location"],
    ["Location"],
    ["TV Program Name"],
    ["Email Address"],
    ["Donor Name", "Contact Number", "Donation Amount", "Payment Method"],
  ];
  RxInt selectedIndex = 0.obs;

  RxList<List<String>> listData = <List<String>>[].obs;

  Future<void> getLifeChangingChurch() async {
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('life_changing_church').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["location"]]);
      });
    });
  }

  Future<void> getPJSMinistries() async {
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('pjs_ministies').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["ministry_location"]]);
      });
    });
  }

  final lifeTVProgram = GlobalKey<FormState>();
  TextEditingController tvProgramController = TextEditingController();

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
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('life_tv_program').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["tv_program"]]);
      });
    });
  }

  Future<void> getEmailAddress() async {
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('email').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["email"]]);
      });
    });
  }

  Future<void> getDontation() async {
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('donation').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["donor_name"], data["contact"], data["amount"], "Razorpay"]);
      });
    });
  }
}