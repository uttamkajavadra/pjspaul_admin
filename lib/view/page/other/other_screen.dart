import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/view/widget/custom_dropdown.dart';

class OtherScreen extends StatefulWidget {
  const OtherScreen({super.key});

  @override
  State<OtherScreen> createState() => _OtherScreenState();
}

class _OtherScreenState extends State<OtherScreen> {
  List<List<String>> list = [
    ["Location"],
    ["Location"],
    ["TV Program Name"],
    ["Email Address"],
    ["Donor Name", "Contact Number", "Donation Amount", "Payment Method"],
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
                      items: ["Life Changing Churches", "PJS Paul Ministries Offices", "Life Changing Messages Live", "Email Us", "Donations"],            
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