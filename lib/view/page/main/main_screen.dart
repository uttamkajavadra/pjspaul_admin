import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pjspaul_admin/controller/beliver_registration/beliver_registration_controller.dart';
import 'package:pjspaul_admin/controller/beliver_request_form/beliver_request_form_controller.dart';
import 'package:pjspaul_admin/controller/beliver_spritual_content/beliver_spritual_content_controller.dart';
import 'package:pjspaul_admin/controller/other/other_controller.dart';
import 'package:pjspaul_admin/route/app_routes.dart';
import 'package:pjspaul_admin/view/page/beliver_registration/beliver_registration_screen.dart';
import 'package:pjspaul_admin/view/page/beliver_request_form/beliver_request_form_screen.dart';
import 'package:pjspaul_admin/view/page/beliver_spritual_content/beliver_spritual_content_screen.dart';
import 'package:pjspaul_admin/view/page/other/other_screen.dart';
import 'package:pjspaul_admin/view/page/upload_image/upload_image_screen.dart';
import 'package:pjspaul_admin/view/page/user/user_screen.dart';
import 'package:pjspaul_admin/view/theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Controllers
  final BeliverSpritualContentController beliverSpritualContentController =
      Get.put(BeliverSpritualContentController());
  final BeliverRequestFormController beliverRequestFormController =
      Get.put(BeliverRequestFormController());
  final BeliverRegistrationController beliverRegistrationController =
      Get.put(BeliverRegistrationController());
  final OtherController otherController = Get.put(OtherController());

  // Menu Items
  final List<Map<String, dynamic>> menuItems = [
    {
      "title": "Dashboard Users",
      "icon": Icons.people_alt,
      "screen": UserScreen()
    },
    {
      "title": "Upload Gallery",
      "icon": Icons.photo_library,
      "screen": UploadImageScreen()
    },
    // Spiritual Content
    {
      "title": "Today's Blessing",
      "icon": Icons.volunteer_activism,
      "screen": BeliverSpritualContentScreen()
    },
    {
      "title": "Radio 24x7",
      "icon": Icons.radio,
      "screen": BeliverSpritualContentScreen()
    },
    {
      "title": "Short Videos",
      "icon": Icons.video_library,
      "screen": BeliverSpritualContentScreen()
    },
    {
      "title": "Live Message",
      "icon": Icons.live_tv,
      "screen": BeliverSpritualContentScreen()
    },
    {
      "title": "Songs",
      "icon": Icons.music_note,
      "screen": BeliverSpritualContentScreen()
    },
    {
      "title": "Upcoming Events",
      "icon": Icons.event,
      "screen": BeliverSpritualContentScreen()
    },
    // Requests
    {
      "title": "Prayer Request",
      "icon": Icons.verified_user,
      "screen": BeliverRequestFormScreen()
    },
    {
      "title": "Testimonies",
      "icon": Icons.message,
      "screen": BeliverRequestFormScreen()
    },
    {
      "title": "Pastor Appointment",
      "icon": Icons.schedule,
      "screen": BeliverRequestFormScreen()
    },
    {
      "title": "Feedback",
      "icon": Icons.feedback,
      "screen": BeliverRequestFormScreen()
    },
    {
      "title": "Counseling",
      "icon": Icons.support_agent,
      "screen": BeliverRequestFormScreen()
    },
    {
      "title": "Cottage Prayer",
      "icon": Icons.home_work,
      "screen": BeliverRequestFormScreen()
    },
    {
      "title": "Volunteer",
      "icon": Icons.handshake,
      "screen": BeliverRequestFormScreen()
    },
    // Registrations
    {
      "title": "Youth Reg.",
      "icon": Icons.child_care,
      "screen": BeliverRegistrationScreen()
    },
    {
      "title": "Baptism Reg.",
      "icon": Icons.water_drop,
      "screen": BeliverRegistrationScreen()
    },
    {
      "title": "Chain Prayer",
      "icon": Icons.link,
      "screen": BeliverRegistrationScreen()
    },
    {
      "title": "Bible College",
      "icon": Icons.school,
      "screen": BeliverRegistrationScreen()
    },
    {
      "title": "Leaders Reg.",
      "icon": Icons.person_pin,
      "screen": BeliverRegistrationScreen()
    },
    {
      "title": "Business Reg.",
      "icon": Icons.business_center,
      "screen": BeliverRegistrationScreen()
    },
    {
      "title": "Medical Reg.",
      "icon": Icons.medical_services,
      "screen": BeliverRegistrationScreen()
    },
    // Other
    {
      "title": "Donations",
      "icon": Icons.monetization_on,
      "screen": OtherScreen()
    },
    {"title": "Connect/Email", "icon": Icons.email, "screen": OtherScreen()},
  ];

  RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            color: AppTheme.surfaceColor,
            child: Column(
              children: [
                _buildSidebarHeader(),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: menuItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) => _buildMenuItem(index),
                  ),
                ),
                _buildLogoutButton(),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    color: AppTheme.surfaceColor,
                    child: Obx(() => menuItems[selectedIndex.value]["screen"]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppTheme.primaryColor,
      child: Row(
        children: [
          const Icon(Icons.admin_panel_settings, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Text(
            "Admin Panel",
            style: AppTheme.titleMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(int index) {
    return Obx(() {
      final isSelected = selectedIndex.value == index;
      return ListTile(
        leading: Icon(
          menuItems[index]["icon"],
          color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
        ),
        title: Text(
          menuItems[index]["title"],
          style: isSelected
              ? AppTheme.bodyLarge.copyWith(
                  color: AppTheme.primaryColor, fontWeight: FontWeight.w600)
              : AppTheme.bodyMedium,
        ),
        selected: isSelected,
        selectedTileColor: AppTheme.primaryColor.withOpacity(0.05),
        onTap: () => _handleMenuSelection(index),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      );
    });
  }

  Widget _buildLogoutButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout, color: AppTheme.errorColor),
        title: Text(
          "Logout",
          style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.errorColor, fontWeight: FontWeight.w600),
        ),
        onTap: () {
          Get.offAllNamed(AppRoutes.login);
        },
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Obx(() => Text(
                menuItems[selectedIndex.value]["title"],
                style: AppTheme.displayMedium.copyWith(fontSize: 20),
              )),
          const Spacer(),
          CircleAvatar(
            backgroundColor: AppTheme.backgroundColor,
            child: const Icon(Icons.person, color: AppTheme.textSecondary),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Administrator",
                  style:
                      AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              Text("pjspaulministry@gmail.com",
                  style: AppTheme.bodyMedium.copyWith(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(int index) {
    // Map index to specific logic for detailed controller setup
    // Note: Keeping existing logic structure but cleaned up
    selectedIndex.value = index;

    // Reset controllers or set specific tabs based on index
    // Spiritual Content
    if (index == 2)
      _setContentTab(
          1, () => beliverSpritualContentController.getTodayBlessing());
    else if (index == 3)
      _setContentTab(0, () => beliverSpritualContentController.getRadioLink());
    else if (index == 4)
      _setContentTab(
          3, () => beliverSpritualContentController.getShortMessage());
    else if (index == 5)
      _setContentTab(
          4, () => beliverSpritualContentController.getLifeMessage());
    else if (index == 6)
      _setContentTab(5, () => beliverSpritualContentController.getLifeSong());
    else if (index == 7)
      _setContentTab(
          2, () => beliverSpritualContentController.getUpcomingEvent());

    // Requests
    else if (index == 8)
      _setRequestTab(0, () => beliverRequestFormController.getPrayerRequest());
    else if (index == 9)
      _setRequestTab(
          1, () => beliverRequestFormController.getTestimonyRequest());
    else if (index == 10)
      _setRequestTab(5, () => beliverRequestFormController.getPastorRequest());
    else if (index == 11)
      _setRequestTab(
          4, () => beliverRequestFormController.getFeedbackRequest());
    else if (index == 12)
      _setRequestTab(
          3, () => beliverRequestFormController.getCounselingRequest());
    else if (index == 13)
      _setRequestTab(2, () => beliverRequestFormController.getCottagePrayer());
    else if (index == 14)
      _setRequestTab(
          7, () => beliverRequestFormController.getVolunteerEnrollment());

    // Registrations
    else if (index == 15)
      _setRegistrationTab(
          0, () => beliverRegistrationController.getYouthRegistration());
    else if (index == 16)
      _setRegistrationTab(
          4, () => beliverRegistrationController.getBaptismRegister());
    else if (index == 17)
      _setRegistrationTab(
          6, () => beliverRegistrationController.getChainPrayer());
    else if (index == 18)
      _setRegistrationTab(
          2, () => beliverRegistrationController.getCollegeRegister());
    else if (index == 19)
      _setRegistrationTab(
          1, () => beliverRegistrationController.getLeaderRegistration());
    else if (index == 20)
      _setRegistrationTab(
          3, () => beliverRegistrationController.getBusinessRegister());
    else if (index == 21)
      _setRegistrationTab(
          5, () => beliverRegistrationController.getDoctorRegister());

    // Other
    else if (index == 22) {
      otherController.selectedIndex.value = 4;
      otherController.getDontation();
    } else if (index == 23) {
      otherController.selectedIndex.value = 3;
      otherController.getEmailAddress();
    }
  }

  void _setContentTab(int tabIndex, Function fetchData) {
    beliverSpritualContentController.selectedIndex.value = tabIndex;
    fetchData();
  }

  void _setRequestTab(int tabIndex, Function fetchData) {
    beliverRequestFormController.selectedIndex.value = tabIndex;
    fetchData();
  }

  void _setRegistrationTab(int tabIndex, Function fetchData) {
    beliverRegistrationController.selectedIndex.value = tabIndex;
    fetchData();
  }
}
