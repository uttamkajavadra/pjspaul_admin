import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_request_form/beliver_request_form_controller.dart';
import 'package:pjspaul_admin/view/widget/custom_dropdown.dart';
import 'dart:html' as html;

class BeliverRequestFormScreen extends StatefulWidget {
  const BeliverRequestFormScreen({super.key});

  @override
  State<BeliverRequestFormScreen> createState() => _BeliverRequestFormScreenState();
}

class _BeliverRequestFormScreenState extends State<BeliverRequestFormScreen> {
  BeliverRequestFormController controller = Get.isRegistered<BeliverRequestFormController>() 
    ? Get.find<BeliverRequestFormController>() : Get.put(BeliverRequestFormController());

  @override
  void initState() {
    if (controller.selectedIndex.value == 0) {
                          controller.getPrayerRequest();
                        } else if(controller.selectedIndex.value == 1){
                          controller.getTestimonyRequest();
                        } else if(controller.selectedIndex.value == 2){
                          controller.getCottagePrayer();
                        } else if(controller.selectedIndex.value == 3){
                          controller.getCounselingRequest();
                        } else if(controller.selectedIndex.value == 4){
                          controller.getFeedbackRequest();
                        } else if(controller.selectedIndex.value == 5){
                          controller.getPastorRequest();
                        } else if(controller.selectedIndex.value == 6){
                          controller.getChildDedication();
                        } else if(controller.selectedIndex.value == 7){
                          controller.getVolunteerEnrollment();
                        }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Spacer(),
              SizedBox(
                width: 300,
                child: Obx(() {
                  return CustomDropDown(
                      value: controller.selectedIndex.value,
                      items: [
                        "Prayer Request",
                        "Testimony Request",
                        "Cottage Prayers/Hospital Visit Request",
                        "Prayer & Counseling Request",
                        "Suggestions/Feedback Request",
                        "Pastor's Appointment Request",
                        "Child Dedication Request",
                        "Volunteer Enrollment Request"
                      ],
                      onChanged: (index) {
                        controller.selectedIndex.value = index;
                        if (index == 0) {
                          controller.getPrayerRequest();
                        } else if(index == 1){
                          controller.getTestimonyRequest();
                        } else if(index == 2){
                          controller.getCottagePrayer();
                        } else if(index == 3){
                          controller.getCounselingRequest();
                        } else if(index == 4){
                          controller.getFeedbackRequest();
                        } else if(index == 5){
                          controller.getPastorRequest();
                        } else if(index == 6){
                          controller.getChildDedication();
                        } else if(index == 7){
                          controller.getVolunteerEnrollment();
                        }
                      },
                      validator: (value) => null);
                }),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() {
            return (controller.listData.isEmpty)?
            Text("No data found")
            :Container(
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
                        DataCell(
                          (controller.listData[i][j].startsWith("http"))
                          ? GestureDetector(
                            onTap: (){
                              html.window.open(controller.listData[i][j], '_blank');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(6)
                              ),
                              child: Text("View", style: TextStyle(color: Colors.white),),
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
