import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_spritual_content/beliver_spritual_content_controller.dart';
import 'package:pjspaul_admin/utils/validator.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/life_changing_message_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/life_changing_song_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/short_message_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/today_blessing_form.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/tabs/upcoming_event_form.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_dropdown.dart';
import 'package:pjspaul_admin/view/widget/custom_text_form_field.dart';
// import 'package:pjspaul_admin/view/widget/custom_toast.dart';
// import 'package:pjspaul_admin/view/widget/custom_upload_file.dart';
// import 'dart:html' as html;

class BeliverSpritualContentScreen extends StatefulWidget {
  const BeliverSpritualContentScreen({super.key});

  @override
  State<BeliverSpritualContentScreen> createState() => _BeliverSpritualContentScreenState();
}

class _BeliverSpritualContentScreenState extends State<BeliverSpritualContentScreen> {
  BeliverSpritualContentController controller = Get.isRegistered<BeliverSpritualContentController>()
      ? Get.find<BeliverSpritualContentController>()
      : Get.put(BeliverSpritualContentController());

  @override
  void initState() {
    // if (controller.selectedIndex.value  == 0) {
    //                       controller.getRadioLink();
    //                     } else if (controller.selectedIndex.value  == 1) {
    //                       controller.getTodayBlessing();
    //                     } else if (controller.selectedIndex.value  == 2) {
    //                       controller.getUpcomingEvent();
    //                     } else if (controller.selectedIndex.value  == 3) {
    //                       controller.getShortMessage();
    //                     } else if (controller.selectedIndex.value  == 4) {
    //                       controller.getLifeMessage();
    //                     } else if (controller.selectedIndex.value  == 5) {
    //                       controller.getLifeSong();
    //                     }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ModalRoute.of(context)?.isCurrent ?? false) {
        // controller.isGo.value = false;
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
        // controller.isGo.value = true;
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   children: [
          //     Spacer(),
          //     SizedBox(
          //       width: 300,
          //       child: Obx(() {
          //         return CustomDropDown(
          //             value: controller.selectedIndex.value,
          //             items: [
          //               "Life Changing Radio 24/7",
          //               "Today’s Blessing/Promise",
          //               "Upcoming Events",
          //               "Short Messages",
          //               "Life Changing Messages",
          //               "Life Changing Songs"
          //             ],
          //             onChanged: (index) {
          //               controller.selectedIndex.value = index;
          //               if (index == 0) {
          //                 controller.getRadioLink();
          //               } else if (index == 1) {
          //                 controller.getTodayBlessing();
          //               } else if (index == 2) {
          //                 controller.getUpcomingEvent();
          //               } else if (index == 3) {
          //                 controller.getShortMessage();
          //               } else if (index == 4) {
          //                 controller.getLifeMessage();
          //               } else if (index == 5) {
          //                 controller.getLifeSong();
          //               }
          //             },
          //             validator: (value) => null);
          //       }),
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            if (controller.selectedIndex.value == 0) {
              return Form(
                key: controller.radioForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Life Changing Radio 24/7",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                        controller: controller.lifeChangingRadioController,
                        labelText: "Life Changin Radio Link",
                        validator: (value) => Validator.validateNull("Life Changin Radio Link", value)),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomElevatedButton(
                        onPressed: () {
                          if (controller.radioForm.currentState!.validate()) {
                            controller.addRadioLink(context);
                          }
                        },
                        buttonText: "Save"),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Current Radio Link",
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    if (controller.listData.isNotEmpty) Text(controller.listData[0][0])
                  ],
                ),
              );
            }
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 100,
                      child: CustomElevatedButton(
                          onPressed: () {
                            controller.isShowAdd.value = !controller.isShowAdd.value;
                          },
                          buttonText: (controller.isShowAdd.value) ? "Hide" : "+ Add"),
                    ),
                    if (controller.selectedIndex.value == 1 && controller.isShowAdd.value == true) TodayBlessingForm(),
                    if (controller.selectedIndex.value == 2 && controller.isShowAdd.value == true) UpcomingEventForm(),
                    if (controller.selectedIndex.value == 3 && controller.isShowAdd.value == true) ShortMessageForm(),
                    if (controller.selectedIndex.value == 4 && controller.isShowAdd.value == true) LifeChangingMessageForm(),
                    if (controller.selectedIndex.value == 5 && controller.isShowAdd.value == true) LifeChangingSongForm(),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() {
                      if (controller.listData.isEmpty) {
                        return Text("No data found");
                      }
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 20.0)]),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(columns: [
                            for (int i = 0; i < controller.list[controller.selectedIndex.value].length; i++) ...[
                              DataColumn(
                                label: Text(
                                  controller.list[controller.selectedIndex.value][i],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ]
                          ], rows: [
                            for (int i = 0; i < controller.listData.length; i++) ...[
                              DataRow(cells: [
                                for (int j = 0; j < controller.listData[i].length; j++) ...[
                                  DataCell((controller.listData[i][j].startsWith("http"))
                                      ? GestureDetector(
                                          onTap: () {
                                            // html.window.open(controller.listData[i][j], '_blank');
                                            if (controller.listData[i][j].contains("mp4")) {
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      child: Container(
                                                        width: 500,
                                                        height: 500,
                                                        child: Image.network(
                                                          controller.listData[i][j],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(6)),
                                            child: Text(
                                              "View",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : (controller.listData[i][j].toString() == "delete")
                                          ? GestureDetector(
                                              onTap: () async {
                                                if (controller.selectedIndex.value == 1) {
                                                  controller.deleteTodayBlessing(context, i);
                                                } else if (controller.selectedIndex.value == 2) {
                                                  controller.deleteUpcomingEvent(context, i);
                                                } else if (controller.selectedIndex.value == 3) {
                                                  controller.deleteShortMessage(context, i);
                                                } else if (controller.selectedIndex.value == 4) {
                                                  controller.deleteLifeMessage(context, i);
                                                } else if (controller.selectedIndex.value == 5) {
                                                  controller.deleteLifeSong(context, i);
                                                }
                                              },
                                              child: Icon(Icons.delete_rounded))
                                          : Text(
                                              controller.listData[i][j],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                            )),
                                ],
                                // DataCell(GestureDetector(onTap: () {}, child: Icon(Icons.edit_rounded))),
                                // DataCell(GestureDetector(
                                //     onTap: () async {
                                //       if (controller.selectedIndex.value == 1) {
                                //         controller.deleteTodayBlessing(context, i);
                                //       } else if (controller.selectedIndex.value == 2) {
                                //         controller.getUpcomingEvent();
                                //       } else if (controller.selectedIndex.value == 3) {
                                //         controller.getShortMessage();
                                //       } else if (controller.selectedIndex.value == 4) {
                                //         controller.getLifeMessage();
                                //       } else if (controller.selectedIndex.value == 5) {
                                //         controller.getLifeSong();
                                //       }
                                //     },
                                //     child: Icon(Icons.delete_rounded)))
                              ]),
                            ],
                          ]),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}
