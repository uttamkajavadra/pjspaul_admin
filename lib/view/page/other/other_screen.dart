import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/other/other_controller.dart';
import 'package:pjspaul_admin/view/page/other/tabs/life_changing_message_live.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';
import 'package:pjspaul_admin/view/widget/detail_dialog.dart';
import 'package:pjspaul_admin/view/widget/responsive_data_grid.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  OtherController controller = Get.isRegistered<OtherController>()
      ? Get.find<OtherController>()
      : Get.put(OtherController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    controller.refreshCurrent();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Obx(() {
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.selectedIndex.value == 2)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 100,
                            child: CustomElevatedButton(
                                onPressed: () {
                                  controller.isShowAdd.value =
                                      !controller.isShowAdd.value;
                                },
                                buttonText: (controller.isShowAdd.value)
                                    ? "Hide"
                                    : "+ Add"),
                          ),
                          if (controller.selectedIndex.value == 2 &&
                              controller.isShowAdd.value == true)
                            const LifeChangingMessageLive(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  Expanded(
                    child: (!controller.isGo.value)
                        ? const Center(child: CircularProgressIndicator())
                        : (controller.listData.isEmpty)
                            ? const Center(child: Text("No data found"))
                            : ResponsiveDataGrid(
                                itemCount: controller.listData.length,
                                itemBuilder: (context, index) =>
                                    _buildCard(index),
                              ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    final row = controller.listData[index];
    final selectedIndex = controller.selectedIndex.value;

    String title = '';
    String subtitle = '';
    String date = '';
    Map<String, String> details = {};

    if (selectedIndex == 0) {
      // Life Changing Church
      title = row[0]; // Location
      date = row[1];
      details = {"Location": row[0], "Date": row[1]};
    } else if (selectedIndex == 1) {
      // PJS Ministries
      title = row[0]; // Ministry Location
      date = row[1];
      details = {"Ministry Location": row[0], "Date": row[1]};
    } else if (selectedIndex == 2) {
      // Life TV Program
      title = row[0]; // Program Name
      date = row[1];
      details = {"Program Name": row[0], "Date": row[1]};
    } else if (selectedIndex == 3) {
      // Email
      title = row[0]; // Name
      // Email, Phone, Subject, Message
      subtitle = "Subject: ${row[3]}";
      date = row[5];
      details = {
        "Name": row[0],
        "Email": row[1],
        "Phone": row[2],
        "Subject": row[3],
        "Message": row[4],
        "Date": row[5]
      };
    } else if (selectedIndex == 4) {
      // Donation
      title = "${row[0]} - ${row[2]}"; // Name - Amount
      subtitle = "Method: ${row[3]}";
      date = row[4];
      details = {
        "Name": row[0],
        "Contact": row[1],
        "Amount": row[2],
        "Payment Method": row[3],
        "Date": row[4]
      };
    }

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
            title: title,
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
                      title,
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
                        onConfirm: () {
                          controller.deleteRecord(context, index);
                        },
                      );
                    },
                  ),
                ],
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Spacer(),
              const Divider(),
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
