import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class OtherController extends GetxController{
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