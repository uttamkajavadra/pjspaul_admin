import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/other/other_controller.dart';
import 'package:pjspaul_admin/view/page/other/tabs/life_changing_message_live.dart';
import 'package:pjspaul_admin/view/widget/custom_button.dart';
import 'package:pjspaul_admin/view/widget/custom_dropdown.dart';
import 'dart:html' as html;

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  OtherController controller = Get.isRegistered<OtherController>() 
    ? Get.find<OtherController>() : Get.put(OtherController());

  @override
  void initState() {
    if(controller.selectedIndex.value == 0){
                          controller.getLifeChangingChurch();
                        } else if(controller.selectedIndex.value == 1){
                          controller.getPJSMinistries();
                        } else if(controller.selectedIndex.value == 2){
                          controller.getLifeTVProgram();
                        } else if(controller.selectedIndex.value == 3){
                          controller.getEmailAddress();
                        } else if(controller.selectedIndex.value == 3){
                          controller.getDontation();
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
                child: Obx(
                  () {
                    return CustomDropDown(
                      value: controller.selectedIndex.value,
                      items: ["Life Changing Churches", "PJS Paul Ministries Offices", "Life Changing Messages Live", "Email Us", "Donations"],            
                      onChanged: (index){
                        controller.selectedIndex.value = index;
                        if(index == 0){
                          controller.getLifeChangingChurch();
                        } else if(index == 1){
                          controller.getPJSMinistries();
                        } else if(index == 2){
                          controller.getLifeTVProgram();
                        } else if(index == 3){
                          controller.getEmailAddress();
                        } else if(index == 3){
                          controller.getDontation();
                        } 
                      }, validator: (value)=>null);
                  }
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Obx(() {
            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(controller.selectedIndex.value == 2) Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 100,
                          child: CustomElevatedButton(onPressed: (){
                            controller.isShowAdd.value = !controller.isShowAdd.value;
                          }, buttonText: (controller.isShowAdd.value)?"Hide":"+ Add"),
                        ),
                    if (controller.selectedIndex.value == 2 && controller.isShowAdd.value == true) LifeChangingMessageLive(),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    (controller.listData.isEmpty)?
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
                    ),
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