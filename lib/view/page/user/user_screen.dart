import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/user/user_controller.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';

import 'package:pjspaul_admin/view/widget/detail_dialog.dart';
import 'package:pjspaul_admin/view/widget/responsive_data_grid.dart';

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
                  : ResponsiveDataGrid(
                      itemCount: controller.listData.length,
                      itemBuilder: (context, index) => _buildCard(index),
                    );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    final row = controller.listData[index];
    // Data: Name(0), Location(1), Contact(2), Email(3), Date(4), Delete(5)

    String name = row.isNotEmpty ? row[0] : 'Unknown';
    String location = row.length > 2 ? row[1] : '';
    String contact = row.length > 2 ? row[2] : '';
    String email = row.length > 3 ? row[3] : '';
    String date = row.length > 4 ? row[4] : '';

    Map<String, String> details = {
      "Name": name,
      "Location": location,
      "Contact": contact,
      "Email": email,
      "Date": date
    };

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () {
          DetailDialog.show(
            context,
            title: "User Details",
            data: details,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      DeleteConfirmationDialog.show(
                        context,
                        onConfirm: () => controller.deleteUser(context, index),
                      );
                    },
                  ),
                ],
              ),
              const Divider(),
              if (location.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text("Location: $location",
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ),
              if (email.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text("Email: $email",
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ),
              const Spacer(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Click to view details",
                    style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
