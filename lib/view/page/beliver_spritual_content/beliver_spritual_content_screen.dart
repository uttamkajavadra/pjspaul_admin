import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_spritual_content/beliver_spritual_content_controller.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/life_changing_message_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/life_changing_song_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/short_message_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/today_blessing_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/upcoming_event_form.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_text_form_field.dart';
import 'package:pjspaul_admin/view/widget/delete_confirmation_dialog.dart';

import 'package:pjspaul_admin/view/widget/detail_dialog.dart';
import 'package:pjspaul_admin/view/widget/responsive_data_grid.dart';

// ... (existing imports)

// ...

class BeliverSpritualContentScreen extends StatefulWidget {
  const BeliverSpritualContentScreen({super.key});

  @override
  State<BeliverSpritualContentScreen> createState() =>
      _BeliverSpritualContentScreenState();
}

class _BeliverSpritualContentScreenState
    extends State<BeliverSpritualContentScreen> {
  BeliverSpritualContentController controller =
      Get.isRegistered<BeliverSpritualContentController>()
          ? Get.find<BeliverSpritualContentController>()
          : Get.put(BeliverSpritualContentController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.selectedIndex.value == 0) {
        await controller.getRadioLink();
      } else if (controller.selectedIndex.value == 1) {
        await controller.getTodayBlessing();
      } else if (controller.selectedIndex.value == 2) {
        await controller.getUpcomingEvent();
      } else if (controller.selectedIndex.value == 3) {
        await controller.getShortMessage();
      } else if (controller.selectedIndex.value == 4) {
        await controller.getLifeMessage();
      } else if (controller.selectedIndex.value == 5) {
        await controller.getLifeSong();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Obx(() {
            if (controller.selectedIndex.value == 0) {
              return Form(
                key: controller.radioForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Life Changing Radio 24/7",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                        controller: controller.lifeChangingRadioController,
                        labelText: "Life Changing Radio Link",
                        validator: (value) => Validator.validateNull(
                            "Life Changing Radio Link", value)),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                        onPressed: () {
                          if (controller.radioForm.currentState!.validate()) {
                            controller.addRadioLink(context);
                          }
                        },
                        buttonText: "Save"),
                    const SizedBox(height: 40),
                    const Text(
                      "Current Radio Link",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    if (controller.listData.isNotEmpty)
                      Text(controller.listData[0][0]),
                  ],
                ),
              );
            }
            return Expanded(
              child: SingleChildScrollView(
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
                          buttonText:
                              (controller.isShowAdd.value) ? "Hide" : "+ Add"),
                    ),
                    if (controller.selectedIndex.value == 1 &&
                        controller.isShowAdd.value == true)
                      TodayBlessingForm(),
                    if (controller.selectedIndex.value == 2 &&
                        controller.isShowAdd.value == true)
                      UpcomingEventForm(),
                    if (controller.selectedIndex.value == 3 &&
                        controller.isShowAdd.value == true)
                      ShortMessageForm(),
                    if (controller.selectedIndex.value == 4 &&
                        controller.isShowAdd.value == true)
                      LifeChangingMessageForm(),
                    if (controller.selectedIndex.value == 5 &&
                        controller.isShowAdd.value == true)
                      LifeChangingSongForm(),
                    const SizedBox(height: 20),
                    Obx(() {
                      if (!controller.isGo.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.listData.isEmpty) {
                        return const Center(child: Text("No data found"));
                      }
                      return ResponsiveDataGrid(
                        itemCount: controller.listData.length,
                        itemBuilder: (context, index) => _buildCard(index),
                      );
                    }),
                  ],
                ),
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
    String? imageUrl;
    String? videoUrl;
    Map<String, String> details = {};

    // Helper to get video type
    String? getVideoType() {
      if (index < controller.listMeta.length) {
        return controller.listMeta[index]['video_type'];
      }
      return null;
    }

    if (selectedIndex == 1) {
      // Today's Blessing
      title = row[0]; // Blessing Text
      date = row[3];
      if (row[1].startsWith('http')) imageUrl = row[1];
      if (row[2].startsWith('http')) videoUrl = row[2];

      details = {
        "Blessing Text": row[0],
        "Date": row[3],
      };
    } else if (selectedIndex == 2) {
      // Upcoming Event
      title = row[0]; // Event Title
      subtitle = "${row[1]} • ${row[2]}"; // Location • Date
      date = row[6];
      if (row[4].startsWith('http')) imageUrl = row[4];
      if (row[5].startsWith('http')) videoUrl = row[5];

      details = {
        "Event Title": row[0],
        "Location": row[1],
        "Event Date": row[2],
        "Description": row[3],
        "Created At": row[6],
      };
    } else if (selectedIndex == 3) {
      // Short Message
      title = row[0]; // Title
      subtitle = row[1]; // Content
      date = row[3];
      if (row[2].startsWith('http')) videoUrl = row[2];

      details = {
        "Title": row[0],
        "Message": row[1],
        "Date": row[3],
      };
    } else if (selectedIndex == 4) {
      // Life Message
      title = row[0]; // Title
      date = row[2];
      if (row[1].startsWith('http')) videoUrl = row[1];

      details = {
        "Video Title": row[0],
        "Date": row[2],
      };
    } else if (selectedIndex == 5) {
      // Life Song
      title = row[0]; // Title
      date = row[2];
      // Audio is treated as videoUrl for preview in this context or we can add specific audio support later
      // But DetailDialog currently supports videoUrl which uses MediaCellWidget that might handle audio if generic enough
      // Checking MediaCellWidget: it handles audio. So videoUrl param is fine if we rename it or just pass it.
      // But DetailDialog uses generic MediaCellWidget for videoUrl.
      if (row[1].startsWith('http')) videoUrl = row[1];

      details = {
        "Song Title": row[0],
        "Date": row[2],
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
            imageUrl: imageUrl,
            videoUrl: videoUrl,
            videoType: getVideoType(),
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
                          if (selectedIndex == 1)
                            controller.deleteTodayBlessing(context, index);
                          else if (selectedIndex == 2)
                            controller.deleteUpcomingEvent(context, index);
                          else if (selectedIndex == 3)
                            controller.deleteShortMessage(context, index);
                          else if (selectedIndex == 4)
                            controller.deleteLifeMessage(context, index);
                          else if (selectedIndex == 5)
                            controller.deleteLifeSong(context, index);
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
                      "Click to view details",
                      style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
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
