import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BeliverRequestFormController extends GetxController{
  RxBool isGo = true.obs;
  List<List<String>> list = [
    ["Full Name", "Location", "Contact Number", "Prayer Request", "Upload File"],
    ["Full Name", "Location", "Contact Number", "Testimony Details", "Upload File"],
    ["Full Name", "Location", "Contact Number", "Visit requested for"],
    ["Full Name", "Contact Number", "Counseling Requested For"],
    ["Full Name", "Contact Number", "Suggestions/Feedback"],
    ["Full Name", "Location", "Contact Number", "WhatsApp", "Reason for Appointment requested", "Preferred Date"],
    ["Full Name", "Contact Number", "Child's Name", "Gender", "Complete Address"],
    ["Full Name", "Complete Address", "Contact Number", "Volunteering Area of Interest", "Profession", "Volunteer Type"]
  ];
  RxInt selectedIndex = 0.obs;

  RxList<List<String>> listData = <List<String>>[].obs;

  Future<void> getPrayerRequest() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('prayer_request').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["location"], data["contact"], data["prayer_request"], data["image"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getTestimonyRequest() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('testimony_request').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["location"], data["contact"], data["testimony_request"], data["image"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getCottagePrayer() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('cottage_prayers').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["location"], data["contact"], data["visit_request"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getCounselingRequest() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('counseling_request').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["contact"], data["counseling_request"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getFeedbackRequest() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('feedback_request').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["contact"], data["feedback"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getPastorRequest() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('pastor_request').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["location"], data["contact"], data["whatsapp"], data["appointment"], data["date"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getChildDedication() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('child_dedication').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["contact"], data["child_name"], data["gender"], data["address"]]);
      });
      isGo.value = true;
    });
  }

  Future<void> getVolunteerEnrollment() async {
    isGo.value = false;
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('volunteer_enrollment').get().then((snapshot) {
      listData.clear();
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["address"], data["contact"], data["area_of_interest"], data["profession"], data["volunteer_type"]]);
      });
      isGo.value = true;
    });
  }
}