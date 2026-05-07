import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/user/user_controller.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';


import 'package:pjspaul_admin/view/widget/responsive_data_table.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserController controller = Get.isRegistered<UserController>()
      ? Get.find<UserController>()
      : Get.put(UserController());

  @override
  void initState() {
    controller.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Login User",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return (controller.listData.isEmpty)
                  ? const Center(child: Text("No data found"))
                  : ResponsiveDataTable(
                      headers: controller.list[controller.selectedIndex.value],
                      data: controller.listData,
                      onDelete: (index) {
                        DeleteConfirmationDialog.show(
                          context,
                          onConfirm: () => controller.deleteUser(context, index),
                        );
                      },
                    );
            }),
          ],
        ),
      ),
    );
  }


}
