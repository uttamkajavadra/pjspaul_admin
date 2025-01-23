import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/view/widget/custom_dropdown.dart';

class BeliverSpritualContentScreen extends StatefulWidget {
  const BeliverSpritualContentScreen({super.key});

  @override
  State<BeliverSpritualContentScreen> createState() => _BeliverSpritualContentScreenState();
}

class _BeliverSpritualContentScreenState extends State<BeliverSpritualContentScreen> {
  List<List<String>> list = [
    [],
    ["Blessing Text", "Image Upload", "Video Upload"],
    ["Event Title", "Location", "Date and Time", "Description"],
    ["Title", "Message Content"],
    ["Video Title", "Video Upload"],
    ["Song Title", "Audio File"],
  ];
  RxInt selectedIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      value: selectedIndex.value,
                      items: ["Life Changing Radio 24/7", "Today’s Blessing/Promise", "Upcoming Events", "Short Messages", "Life Changing Messages", "Life Changing Songs"],            
                      onChanged: (index){
                        selectedIndex.value = index;
                      }, validator: (value)=>null);
                  }
                ),
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Obx(() {
            if(selectedIndex.value == 0){
              return Container();
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 20.0
                  )
                ]
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(columns: [
                  for (int i = 0;
                      i < list[selectedIndex.value].length;
                      i++) ...[
                    DataColumn(
                      label: Text(
                        list[selectedIndex.value][i],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]
                ], rows: [
                  for (int i = 0;
                      i < list[selectedIndex.value].length;
                      i++) ...[
                   
                  ],
                  DataRow(cells: [
                    for (int i = 0;
                      i < list[selectedIndex.value].length;
                      i++) ...[
                        DataCell(Text('1', overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),)),
                      ],
                  ]),
                ]),
              ),
            );
          })
        ],
      ),
    );
  }
}