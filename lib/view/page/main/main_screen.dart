import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/view/page/beliver_registration/beliver_registration_screen.dart';
import 'package:pjspaul_admin/view/page/beliver_request_form/beliver_request_form_screen.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/beliver_spritual_content_screen.dart';
import 'package:pjspaul_admin/view/page/other/other_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  List<Map<String, dynamic>> list = [
    {"title": "Believers Request Forms", "screen": BeliverRequestFormScreen()},
    {"title": "Believers Spiritual Content", "screen": BeliverSpritualContentScreen()},
    {"title": "Believers Registrations", "screen": BeliverRegistrationScreen()},
    {"title": "Others", "screen": OtherScreen()},
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
                  const SizedBox(height: 15,),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return Obx(
                        () {
                          return GestureDetector(
                            onTap: (){
                              selectedIndex.value = index;
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
                              decoration: BoxDecoration(
                                color: (selectedIndex.value == index)?Colors.amber:null,
                                borderRadius: BorderRadius.all(Radius.circular(4))
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(list[index]["title"], style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500
                                    ),),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 14,)
                                ],
                              ),
                            ),
                          );
                        }
                      );
                    }
                  )
                ],
              ),
            ),
          ),
          Expanded(child: Obx(
            () {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: list[selectedIndex.value]["screen"],
              );
            }
          ))
        ],
      ),
    );
  }
}