import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_registration/beliver_registration_controller.dart';
import 'package:pjspaul_admin/view/widget/custom_dropdown.dart';
// import 'dart:html' as html;

class BeliverRegistrationScreen extends StatefulWidget {
  const BeliverRegistrationScreen({super.key});

  @override
  State<BeliverRegistrationScreen> createState() => _BeliverRegistrationScreenState();
}

class _BeliverRegistrationScreenState extends State<BeliverRegistrationScreen> {
  BeliverRegistrationController controller =
      Get.isRegistered<BeliverRegistrationController>() ? Get.find<BeliverRegistrationController>() : Get.put(BeliverRegistrationController());

  @override
  void initState() {
    // controller.getPrayerRequest();
    // if (controller.selectedIndex.value == 0) {
    //   controller.getYouthRegistration();
    // } else if (controller.selectedIndex.value == 1) {
    //   controller.getLeaderRegistration();
    // } else if (controller.selectedIndex.value == 2) {
    //   controller.getCollegeRegister();
    // } else if (controller.selectedIndex.value == 3) {
    //   controller.getBusinessRegister();
    // } else if (controller.selectedIndex.value == 4) {
    //   controller.getBaptismRegister();
    // } else if (controller.selectedIndex.value == 5) {
    //   controller.getDoctorRegister();
    // } else if (controller.selectedIndex.value == 6) {
    //   controller.getChainPrayer();
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.selectedIndex.value == 0) {
      controller.getYouthRegistration();
    } else if (controller.selectedIndex.value == 1) {
      controller.getLeaderRegistration();
    } else if (controller.selectedIndex.value == 2) {
      controller.getCollegeRegister();
    } else if (controller.selectedIndex.value == 3) {
      controller.getBusinessRegister();
    } else if (controller.selectedIndex.value == 4) {
      controller.getBaptismRegister();
    } else if (controller.selectedIndex.value == 5) {
      controller.getDoctorRegister();
    } else if (controller.selectedIndex.value == 6) {
      controller.getChainPrayer();
    }
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
          //               "Youth Registration",
          //               "Pastors & Leaders Registration",
          //               "Bible College Registration",
          //               "Businessman Registration",
          //               "Baptism Registration",
          //               "Doctors/Nurses/Technicians Registration",
          //               "Chain Prayer Registration"
          //             ],
          //             onChanged: (index) {
          //               controller.selectedIndex.value = index;
          //               if (index == 0) {
          //                 controller.getYouthRegistration();
          //               } else if (index == 1) {
          //                 controller.getLeaderRegistration();
          //               } else if (index == 2) {
          //                 controller.getCollegeRegister();
          //               } else if (index == 3) {
          //                 controller.getBusinessRegister();
          //               } else if (index == 4) {
          //                 controller.getBaptismRegister();
          //               } else if (index == 5) {
          //                 controller.getDoctorRegister();
          //               } else if (index == 6) {
          //                 controller.getChainPrayer();
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
            return (controller.listData.isEmpty)
                ? Text("No data found")
                : Container(
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
                                        showDialog(context: context, builder: (context){
                                          return Dialog(
                                            child: Container(
                                              width: 500,
                                              height: 500,
                                              child: Image.network(controller.listData[i][j],),
                                            ),
                                          );
                                        });
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
                                  : Text(
                                      controller.listData[i][j],
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
                                    )),
                            ],
                          ]),
                        ],
                      ]),
                    ),
                  );
          })
        ],
      ),
    );
  }
}
