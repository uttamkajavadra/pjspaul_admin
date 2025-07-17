import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_registration/beliver_registration_controller.dart';
import 'package:pjspaul_admin/controller/beliver_request_form/beliver_request_form_controller.dart';
import 'package:pjspaul_admin/controller/beliver_spritual_content/beliver_spritual_content_controller.dart';
import 'package:pjspaul_admin/controller/other/other_controller.dart';
import 'package:pjspaul_admin/view/page/beliver_registration/beliver_registration_screen.dart';
import 'package:pjspaul_admin/view/page/beliver_request_form/beliver_request_form_screen.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/beliver_spritual_content_screen.dart';
import 'package:pjspaul_admin/view/page/other/other_screen.dart';
import 'package:pjspaul_admin/view/page/upload_image/upload_image_screen.dart';
import 'package:pjspaul_admin/view/page/user/user_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BeliverSpritualContentController beliverSpritualContentController = Get.isRegistered<BeliverSpritualContentController>()
      ? Get.find<BeliverSpritualContentController>()
      : Get.put(BeliverSpritualContentController());

  BeliverRequestFormController beliverRequestFormController =
      Get.isRegistered<BeliverRequestFormController>() ? Get.find<BeliverRequestFormController>() : Get.put(BeliverRequestFormController());

  BeliverRegistrationController beliverRegistrationController =
      Get.isRegistered<BeliverRegistrationController>() ? Get.find<BeliverRegistrationController>() : Get.put(BeliverRegistrationController());

  OtherController otherController = Get.isRegistered<OtherController>() ? Get.find<OtherController>() : Get.put(OtherController());

  List<Map<String, dynamic>> list = [
    {"title": "User", 'screen': UserScreen()},
    {"title": "Upload Image Screen", "screen": UploadImageScreen()},
    {"title": "Today's Blessing", "screen": BeliverSpritualContentScreen()},
    {"title": "Life Changing Radio 24x7", "screen": BeliverSpritualContentScreen()},
    {"title": "Life Changing Short Videos", "screen": BeliverSpritualContentScreen()},
    {"title": "Donations", "screen": OtherScreen()},
    {"title": "Life Changing Message Live", "screen": BeliverSpritualContentScreen()},
    {"title": "Connect With Us", "screen": OtherScreen()},
    {"title": "Life Changing Songs", "screen": BeliverSpritualContentScreen()},
    {"title": "Upcoming Events", "screen": BeliverSpritualContentScreen()},
    {"title": "My Prayer Request", "screen": BeliverRequestFormScreen()},
    {"title": "My Testimonies", "screen": BeliverRequestFormScreen()},
    {"title": "Pastor Appointment Request", "screen": BeliverRequestFormScreen()},
    {"title": "Suggest/Feedback", "screen": BeliverRequestFormScreen()},
    {"title": "Spiritual Guidance & Counselling Request", "screen": BeliverRequestFormScreen()},
    {"title": "Cottage Prayer/Hospital Visit Request", "screen": BeliverRequestFormScreen()},
    {"title": "Volunteer Enrollment Request", "screen": BeliverRequestFormScreen()},
    {"title": "Youth Registration", "screen": BeliverRegistrationScreen()},
    {"title": "Baptism Registration", "screen": BeliverRegistrationScreen()},
    {"title": "Chain Prayer Registration", "screen": BeliverRegistrationScreen()},
    {"title": "Holy Spirit Bible College Registration", "screen": BeliverRegistrationScreen()},
    {"title": "Pastors & Leaders Registration", "screen": BeliverRegistrationScreen()},
    {"title": "Businessman Registration", "screen": BeliverRegistrationScreen()},
    {"title": "Doctor/Nurses/Technicians Registration", "screen": BeliverRegistrationScreen()},
    // {"title": "Believers Spiritual Content", "screen": BeliverSpritualContentScreen()},
    // {"title": "Believers Registrations", "screen": BeliverRegistrationScreen()},
    // {"title": "Others", "screen": OtherScreen()},
  ];
  RxInt selectedIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 200,
            height: double.infinity,
            color: Colors.black,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 100),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          return GestureDetector(
                            onTap: () {
                              // selectedIndex.value = index;
                              // beliverSpritualContentController.listData.clear();
                              // beliverSpritualContentController.listId.clear();
                              // print(beliverSpritualContentController.isGo.value);
                              // selectedIndex.value = index;
                              if (beliverRequestFormController.isGo.value == true &&
                                  beliverRegistrationController.isGo.value == true &&
                                  beliverSpritualContentController.isGo.value == true &&
                                  otherController.isGo.value == true) {
                                selectedIndex.value = index;
                                if (selectedIndex.value == 0) {
                                } else if (selectedIndex.value == 1) {
                                } else if (selectedIndex.value == 2) {
                                  beliverSpritualContentController.selectedIndex.value = 1;
                                } else if (selectedIndex.value == 3) {
                                  beliverSpritualContentController.selectedIndex.value = 0;
                                } else if (selectedIndex.value == 4) {
                                  beliverSpritualContentController.selectedIndex.value = 3;
                                } else if (selectedIndex.value == 5) {
                                  otherController.selectedIndex.value = 4;
                                } else if (selectedIndex.value == 6) {
                                  beliverSpritualContentController.selectedIndex.value = 4;
                                } else if (selectedIndex.value == 7) {
                                  otherController.selectedIndex.value = 3;
                                } else if (selectedIndex.value == 8) {
                                  beliverSpritualContentController.selectedIndex.value = 5;
                                } else if (selectedIndex.value == 9) {
                                  beliverSpritualContentController.selectedIndex.value = 2;
                                } else if (selectedIndex.value == 10) {
                                  beliverRequestFormController.selectedIndex.value = 0;
                                } else if (selectedIndex.value == 11) {
                                  beliverRequestFormController.selectedIndex.value = 1;
                                } else if (selectedIndex.value == 12) {
                                  beliverRequestFormController.selectedIndex.value = 5;
                                } else if (selectedIndex.value == 13) {
                                  beliverRequestFormController.selectedIndex.value = 4;
                                } else if (selectedIndex.value == 14) {
                                  beliverRequestFormController.selectedIndex.value = 3;
                                } else if (selectedIndex.value == 15) {
                                  beliverRequestFormController.selectedIndex.value = 2;
                                } else if (selectedIndex.value == 16) {
                                  beliverRequestFormController.selectedIndex.value = 7;
                                } else if (selectedIndex.value == 17) {
                                  beliverRegistrationController.selectedIndex.value = 0;
                                } else if (selectedIndex.value == 18) {
                                  beliverRegistrationController.selectedIndex.value = 4;
                                } else if (selectedIndex.value == 19) {
                                  beliverRegistrationController.selectedIndex.value = 6;
                                } else if (selectedIndex.value == 20) {
                                  beliverRegistrationController.selectedIndex.value = 2;
                                } else if (selectedIndex.value == 21) {
                                  beliverRegistrationController.selectedIndex.value = 1;
                                } else if (selectedIndex.value == 22) {
                                  beliverRegistrationController.selectedIndex.value = 3;
                                } else if (selectedIndex.value == 23) {
                                  beliverRegistrationController.selectedIndex.value = 5;
                                }
                                print(selectedIndex.value );
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                              decoration: BoxDecoration(
                                  color: (selectedIndex.value == index) ? Colors.amber : null, borderRadius: BorderRadius.all(Radius.circular(4))),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      list[index]["title"],
                                      style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                      })
                ],
              ),
            ),
          ),
          Expanded(child: Obx(() {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: list[selectedIndex.value]["screen"],
            );
          }))
        ],
      ),
    );
  }
}
