import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/view/widget/custom_dropdown.dart';

class BeliverRegistrationScreen extends StatefulWidget {
  const BeliverRegistrationScreen({super.key});

  @override
  State<BeliverRegistrationScreen> createState() => _BeliverRegistrationScreenState();
}

class _BeliverRegistrationScreenState extends State<BeliverRegistrationScreen> {
  List<List<String>> list = [
    ["Full Name", "Location", "Contact Number", "Age", "Profession"],
    ["Full Name", "Address", "Contact Number", "I am a", "Ministry Name", "Ministry Details", "Ministry started Date"],
    ["Full Name", "Address", "Contact Number", "Gender", "Education", "Reason to pursue Bible college"],
    ["Full Name", "Contact Number", "Complete Address", "Business Name", "Industry"],
    ["Full Name", "Contact Number", "Complete Address", "Gender", "Attending Church Since"],
    ["Full Name", "Profession", "Contact Number", "Working Organization"],
    ["Full Name", "Location", "Contact Number", "Gender", "Prayer  Slot Preference"],
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
                      items: ["Youth Registration", "Pastors & Leaders Registration", "Bible College Registration", "Businessman Registration", "Baptism Registration", "Doctors/Nurses/Technicians Registration", "Chain Prayer Registration"],            
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