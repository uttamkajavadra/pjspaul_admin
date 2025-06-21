import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/user/user_controller.dart';
// import 'dart:html' as html;

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserController controller = Get.isRegistered<UserController>() 
    ? Get.find<UserController>() : Get.put(UserController());

    @override
  void initState() {
    controller.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text("Login User",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
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