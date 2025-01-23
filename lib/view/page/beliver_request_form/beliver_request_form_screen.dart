import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/view/widget/custom_dropdown.dart';

class BeliverRequestFormScreen extends StatefulWidget {
  const BeliverRequestFormScreen({super.key});

  @override
  State<BeliverRequestFormScreen> createState() =>
      _BeliverRequestFormScreenState();
}

class _BeliverRequestFormScreenState extends State<BeliverRequestFormScreen> {
  List<List<String>> list = [
    [
      "Full Name",
      "Location",
      "Contact Number",
      "Prayer Request",
      "Upload File"
    ],
    [
      "Full Name",
      "Location",
      "Contact Number",
      "Testimony Details",
      "Upload File"
    ],
    ["Full Name", "Location", "Contact Number", "Visit requested for"],
    ["Full Name", "Contact Number", "Counseling Requested For"],
    ["Full Name", "Contact Number", "Suggestions/Feedback"],
    [
      "Full Name",
      "Location",
      "Contact Number",
      "Reason for Appointment requested",
      "Preferred Date"
    ],
    [
      "Full Name",
      "Contact Number",
      "Child's Name",
      "Gender",
      "Complete Address"
    ],
    [
      "Full Name",
      "Complete Address",
      "Contact Number",
      "Volunteering Area of Interest",
      "Profession"
    ]
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
                child: Obx(() {
                  return CustomDropDown(
                      value: selectedIndex.value,
                      items: [
                        "Prayer Request",
                        "Testimony Request",
                        "Cottage Prayers/Hospital Visit Request",
                        "Prayer & Counseling Request",
                        "Suggestions/Feedback Request",
                        "Pastor's Appointment Request",
                        "Child Dedication Request"
                      ],
                      onChanged: (index) {
                        selectedIndex.value = index;
                      },
                      validator: (value) => null);
                }),
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
                   DataRow(cells: [
                    for (int i = 0;
                      i < list[selectedIndex.value].length;
                      i++) ...[
                        DataCell(Text('1', overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),)),
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
