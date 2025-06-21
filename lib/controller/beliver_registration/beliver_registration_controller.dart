import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BeliverRegistrationController extends GetxController{
  RxBool isGo = true.obs;
  List<List<String>> list = [
    ["Full Name", "Location", "Contact Number", "Age", "Profession"],
    ["Full Name", "Address", "Contact Number", "I am a", "Church Name", "Church Address", "Current Profession", "Ministry started Date"],
    ["Full Name", "Address", "Contact Number", "Age", "Gender", "Education", "Reason to pursue Bible college"],
    ["Full Name", "Contact Number", "Complete Address", "Business Name", "Industry"],
    ["Full Name", "Contact Number", "Complete Address", "Gender", "Attending Church Since"],
    ["Full Name", "Profession", "Speciality", "Contact Number", "Working Organization"],
    ["Full Name", "Location", "Contact Number", "Gender", "Prayer  Slot Preference"],
  ];
  RxInt selectedIndex = 0.obs;

  RxList<List<String>> listData = <List<String>>[].obs;

  Future<void> getYouthRegistration() async {
     isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('youth_registration').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["location"], data["contact"], data["Age"], data["profession"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getLeaderRegistration() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('leader_register').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["location"], data["contact"], data["i_am"], data["church_name"], data["church_address"], data["current_profession"], data["ministry_started"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getCollegeRegister() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('college_register').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["location"], data["contact"], data["birth_date"], data["gender"], data["education"], data["reason"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getBusinessRegister() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('business_register').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["contact"], data["address"], data["business_name"], data["industry"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getBaptismRegister() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('baptism_register').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["address"], data["contact"], data["gender"], data["attending_church"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getDoctorRegister() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('doctor_register').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["profession"], data["specially"], data["contact"], data["working"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getChainPrayer() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('chain_prayer_register').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["address"], data["contact"], data["gender"], data["prayer_slot"]]);
      });
      isGo.value = true;
    });
  }
}