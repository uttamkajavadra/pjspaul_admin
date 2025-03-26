import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  List<List<String>> list = [
    ["Full Name", "Location", "Contact Number", "Email"],
  ];
  RxInt selectedIndex = 0.obs;

  RxList<List<String>> listData = <List<String>>[].obs;

  Future<void> getUser() async {
    listData.clear();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection('login').get().then((snapshot) {
      snapshot.docs.forEach((doc) {
        var data = doc.data();
        listData.add([data["name"], data["location"], data["mobile"], data["email"]]);
      });
    });
  }

}