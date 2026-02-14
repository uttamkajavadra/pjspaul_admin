import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_registration/beliver_registration_controller.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';
import 'package:pjspaul_admin/view/widget/detail_dialog.dart';
import 'package:pjspaul_admin/view/widget/responsive_data_grid.dart';

class BeliverRegistrationScreen extends StatefulWidget {
  const BeliverRegistrationScreen({super.key});

  @override
  State<BeliverRegistrationScreen> createState() =>
      _BeliverRegistrationScreenState();
}

class _BeliverRegistrationScreenState extends State<BeliverRegistrationScreen> {
  BeliverRegistrationController controller =
      Get.isRegistered<BeliverRegistrationController>()
          ? Get.find<BeliverRegistrationController>()
          : Get.put(BeliverRegistrationController());

  @override
  void initState() {
    super.initState();
    controller.refreshCurrent();
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
            Obx(() {
              return (!controller.isGo.value)
                  ? const Center(child: CircularProgressIndicator())
                  : (controller.listData.isEmpty)
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
    final headers = controller.list[controller.selectedIndex.value];

    // Determine title (Name) - index 0
    String name = row.isNotEmpty ? row[0] : 'Unknown';
    String date = row.length > 1 ? row[row.length - 2] : '';

    // Create details map for dialog
    Map<String, String> details = {};
    // Iterate all columns except last 2 (Date, Delete)
    for (int i = 0; i < row.length - 2; i++) {
      if (i < headers.length) {
        details[headers[i]] = row[i];
      }
    }
    // Add Date to details if needed, or it's handled separately. Dialog usually shows key-value.
    details["Registered Date"] = date;

    // Subtitle preview (e.g. Mobile, City)
    List<String> subtitleParts = [];
    if (row.length > 9) subtitleParts.add(row[9]); // Mobile usually
    if (row.length > 6) subtitleParts.add(row[6]); // City usually
    String subtitle = subtitleParts.join(" • ");

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
            title: "Registration Details",
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
                        onConfirm: () =>
                            controller.deleteRecord(context, index),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const Spacer(),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Click to view full details",
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
