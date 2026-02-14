import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pjspaul_admin/view/widget/custom_toast.dart';
import 'package:pjspaul_admin/view/widget/progressbar.dart';

class UserController extends GetxController {
  List<List<String>> list = [
    ["Full Name", "Location", "Contact Number", "Email", "Date", "Delete"],
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

  Future<void> getUser() async {
    listData.clear();
    listId.clear();
    final snapshot = await FirebaseFirestore.instance.collection('login').get();
    for (var doc in snapshot.docs) {
      var data = doc.data();
      listId.add(doc.id);
      listData.add([
        data["name"] ?? '',
        data["location"] ?? '',
        data["mobile"] ?? '',
        data["email"] ?? '',
        _formatDate(data["created_at"]),
        'delete',
      ]);
    }
  }

  Future<void> deleteUser(BuildContext context, int index) async {
    try {
      ProgressBar.instance.showProgressbar(context);
      await FirebaseFirestore.instance
          .collection('login')
          .doc(listId[index])
          .delete();
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Delete successfully");
    } catch (e) {
      ProgressBar.instance.stopProgressBar(context);
      CustomToast.instance.showMsg("Something went wrong");
    } finally {
      await getUser();
    }
  }
}
