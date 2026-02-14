import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_request_form/beliver_request_form_controller.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';
import 'package:pjspaul_admin/view/widget/detail_dialog.dart';
import 'package:pjspaul_admin/view/widget/responsive_data_grid.dart';

class BeliverRequestFormScreen extends StatefulWidget {
  const BeliverRequestFormScreen({super.key});

  @override
  State<BeliverRequestFormScreen> createState() =>
      _BeliverRequestFormScreenState();
}

class _BeliverRequestFormScreenState extends State<BeliverRequestFormScreen> {
  BeliverRequestFormController controller =
      Get.isRegistered<BeliverRequestFormController>()
          ? Get.find<BeliverRequestFormController>()
          : Get.put(BeliverRequestFormController());

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
          Expanded(
            child: Obx(() {
              return (!controller.isGo.value)
                  ? const Center(child: CircularProgressIndicator())
                  : (controller.listData.isEmpty)
                      ? const Center(child: Text("No data found"))
                      : ResponsiveDataGrid(
                          itemCount: controller.listData.length,
                          itemBuilder: (context, index) => _buildCard(index),
                        );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(int index) {
    final row = controller.listData[index];
    final headers = controller.list[controller.selectedIndex.value];

    // Determine title (Name) - index 0
    String name = row.isNotEmpty ? row[0] : 'Unknown';
    String date = row.length > 2 ? row[row.length - 2] : '';

    Map<String, String> details = {};
    String? imageUrl;
    String? videoUrl;

    // Scan for details and media
    for (int i = 0; i < row.length - 2; i++) {
      if (i < headers.length) {
        String val = row[i];
        // Simple media detection
        if (val.startsWith('http')) {
          if (val.contains('youtube') || val.endsWith('.mp4')) {
            videoUrl = val;
          } else if (val.endsWith('.jpg') ||
              val.endsWith('.png') ||
              val.endsWith('.jpeg')) {
            imageUrl = val;
          } else {
            // Fallback or just add to details?
            // Let's add to details if not identified or just assign to imageUrl as fallback (safe?)
            // Or just leave it in details
            details[headers[i]] = val;
          }
        } else {
          details[headers[i]] = val;
        }
      }
    }
    details['Date'] = date;

    // Subtitle construction
    List<String> subtitleParts = [];
    // Try to find common secondary fields like Email, Phone, Subject
    // Headers usually guide us, but we don't know index certainty.
    // Let's just grab index 1 and 2 if they exist and are not urls
    if (row.length > 1 && !row[1].startsWith('http')) subtitleParts.add(row[1]);
    if (row.length > 2 && !row[2].startsWith('http')) subtitleParts.add(row[2]);
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
            title: "Request Details",
            data: details,
            imageUrl: imageUrl,
            videoUrl: videoUrl,
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
              if (imageUrl != null || videoUrl != null) ...[
                const Divider(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (imageUrl != null)
                      const Icon(Icons.image, size: 16, color: Colors.blue),
                    if (imageUrl != null && videoUrl != null)
                      const SizedBox(width: 8),
                    if (videoUrl != null)
                      const Icon(Icons.play_circle,
                          size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      "Contains Media",
                      style: TextStyle(color: Colors.blue[800], fontSize: 12),
                    )
                  ],
                )
              ] else ...[
                const Divider(),
                const SizedBox(height: 8),
                Text(
                  "Click to view details",
                  style: TextStyle(
                      color: Colors.blue[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
